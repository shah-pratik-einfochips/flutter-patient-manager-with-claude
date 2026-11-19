import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patient_health/data/fhir_client.dart';
import 'package:patient_health/data/fhir_mapper.dart';
import 'package:patient_health/domain/enums.dart';
import 'package:patient_health/domain/models.dart';

import '../support/fixtures.dart';

/// Scripted HTTP adapter: returns queued responses and records requests.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.script);
  final List<Object>
  script; // int status | String body | (int, String) | DioException
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final next = script.length > 1 ? script.removeAt(0) : script.first;
    if (next is DioException) throw next;
    final (status, body) = switch (next) {
      (int s, String b) => (s, b),
      int s => (s, ''),
      String b => (200, b),
      _ => throw StateError('bad script'),
    };
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: ['application/fhir+json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

FhirClient clientWith(
  FakeAdapter a, {
  int retries = 3,
  Future<String?> Function()? token,
}) => FhirClient(
  baseUrl: 'https://fhir.test/base',
  dio: Dio()..httpClientAdapter = a,
  maxRetries: retries,
  retryDelay: Duration.zero,
  tokenProvider: token,
);

void main() {
  group('FhirMapper patient', () {
    test('builds a Patient resource', () {
      final j = FhirMapper.patientResource(samplePatient());
      expect(j['resourceType'], 'Patient');
      expect(j.containsKey('id'), isFalse);
      expect((j['identifier'] as List).first, {
        'system': FhirMapper.medicalIdSystem,
        'value': 'MRN-001',
      });
      expect(((j['name'] as List).first as Map)['family'], 'Lee');
      expect(((j['name'] as List).first as Map)['given'], ['Anna']);
      expect(j['gender'], 'female');
      expect(j['birthDate'], '1990-04-05');
      expect((j['telecom'] as List).length, 2);
      expect((((j['extension'] as List).first) as Map)['valueString'], 'AB+');
    });
    test(
      'includes id when already uploaded and omits empty telecom entries',
      () {
        final p = samplePatient(fhirId: 'srv-9').copyWith(phone: '', email: '');
        final j = FhirMapper.patientResource(p);
        expect(j['id'], 'srv-9');
        expect(j['telecom'], isEmpty);
      },
    );
    test('applyPatient overwrites present fields and keeps absent ones', () {
      final out = FhirMapper.applyPatient({
        'id': 'srv-1',
        'name': [
          {
            'family': 'Smith',
            'given': ['Jo'],
          },
        ],
        'gender': 'other',
        'birthDate': '1985-01-02',
      }, samplePatient());
      expect(
        (out.fhirId, out.lastName, out.firstName, out.gender, out.dob),
        ('srv-1', 'Smith', 'Jo', Gender.other, DateTime(1985, 1, 2)),
      );
      expect(out.phone, '+1 555 123 4567'); // untouched
      expect(out.medicalId, 'MRN-001');
    });
    test('applyPatient tolerates junk', () {
      final out = FhirMapper.applyPatient({
        'name': 'x',
        'gender': 5,
        'birthDate': 'nope',
        'telecom': [1, {}],
      }, samplePatient());
      expect(out.lastName, 'Lee');
      expect(out.dob, DateTime(1990, 4, 5));
    });
    test(
      'unknown gender code falls back',
      () => expect(Gender.fromFhir('zzz'), Gender.unknown),
    );
  });

  group('FhirMapper observations', () {
    final at = DateTime.utc(2026, 6, 1, 8, 30);
    test('BP produces a panel and MAP; others one each with LOINC codes', () {
      final r = VitalRecord(
        patientId: 'p1',
        recordedAt: at,
        systolic: 120,
        diastolic: 80,
        heartRate: 72,
        heightCm: 170,
        weightKg: 65,
        temperatureC: 36.8,
        respiratoryRate: 16,
        spo2: 98,
        painLevel: 2,
      );
      final obs = FhirMapper.observations(r, 'srv-1');
      String code(Map o) =>
          (((o['code'] as Map)['coding'] as List).first as Map)['code']
              as String;
      expect(obs.map(code), [
        '85354-9',
        '8478-0',
        '8867-4',
        '8302-2',
        '29463-7',
        '8310-5',
        '9279-1',
        '59408-5',
        '72514-3',
      ]);
      final panel = obs.first;
      expect(panel['subject'], {'reference': 'Patient/srv-1'});
      expect(panel['effectiveDateTime'], '2026-06-01T08:30:00.000Z');
      expect((panel['component'] as List).length, 2);
      expect(((obs[1]['valueQuantity'] as Map)['value']), 93.3);
      expect(((obs[2]['valueQuantity'] as Map)['code']), '/min');
    });
    test(
      'only recorded values produce observations; lone systolic produces none',
      () {
        expect(
          FhirMapper.observations(
            VitalRecord(patientId: 'p', recordedAt: at, systolic: 120),
            's',
          ),
          isEmpty,
        );
        expect(
          FhirMapper.observations(
            VitalRecord(patientId: 'p', recordedAt: at, spo2: 97),
            's',
          ).length,
          1,
        );
      },
    );
    test('round trip through vitalRecord', () {
      final r = VitalRecord(
        patientId: 'p1',
        recordedAt: at,
        systolic: 118,
        diastolic: 76,
        heartRate: 70,
        temperatureC: 36.6,
        painLevel: 1,
      );
      final back = FhirMapper.vitalRecord(
        FhirMapper.observations(r, 's'),
        'p1',
        at,
      )!;
      expect(
        (
          back.systolic,
          back.diastolic,
          back.heartRate,
          back.temperatureC,
          back.painLevel,
        ),
        (118, 76, 70, 36.6, 1),
      );
      expect(back.map, r.map);
    });
    test('unknown observations are ignored', () {
      final other = {
        'resourceType': 'Observation',
        'code': {
          'coding': [
            {'code': '0000-0'},
          ],
        },
        'valueQuantity': {'value': 1},
      };
      expect(FhirMapper.vitalRecord([other], 'p', at), isNull);
    });
  });

  group('FhirClient', () {
    test('POST for new patient and PUT with id; sends FHIR headers and bearer token', () async {
      final a = FakeAdapter(['{"resourceType":"Patient","id":"abc"}']);
      final c = clientWith(a, token: () async => 'tok');
      final created = await c.upsertPatient({'resourceType': 'Patient'});
      await c.upsertPatient({'resourceType': 'Patient', 'id': 'abc'});
      expect(created['id'], 'abc');
      expect(a.requests[0].method, 'POST');
      expect(a.requests[0].uri.toString(), 'https://fhir.test/base/Patient');
      expect(a.requests[1].method, 'PUT');
      expect(a.requests[1].uri.path, '/base/Patient/abc');
      expect(a.requests[0].headers['Authorization'], 'Bearer tok');
      expect(a.requests[0].headers['Accept'], 'application/fhir+json');
    });
    test('no Authorization header without a token', () async {
      final a = FakeAdapter(['{"id":"x"}']);
      await clientWith(a).fetchPatient('x');
      expect(a.requests.single.headers.containsKey('Authorization'), isFalse);
    });
    test('retries transient statuses then succeeds', () async {
      final a = FakeAdapter([503, 429, (200, '{"id":"ok"}')]);
      expect((await clientWith(a).fetchPatient('x'))['id'], 'ok');
      expect(a.requests.length, 3);
    });
    test('gives up after maxRetries on 5xx', () async {
      final a = FakeAdapter([500]);
      await expectLater(
        clientWith(a, retries: 2).fetchPatient('x'),
        throwsA(isA<FhirHttpException>().having((e) => e.code, 'code', 500)),
      );
      expect(a.requests.length, 3); // 1 try + 2 retries
    });
    test('does not retry client errors', () async {
      final a = FakeAdapter([404]);
      await expectLater(
        clientWith(a).fetchPatient('x'),
        throwsA(isA<FhirHttpException>().having((e) => e.code, 'code', 404)),
      );
      expect(a.requests.length, 1);
    });
    test('network errors are retried then surfaced', () async {
      final err = DioException.connectionError(
        requestOptions: RequestOptions(),
        reason: 'offline',
      );
      final a = FakeAdapter([err]);
      await expectLater(
        clientWith(a, retries: 1).fetchPatient('x'),
        throwsA(isA<FhirNetworkException>()),
      );
      expect(a.requests.length, 2);
    });
    test('malformed body is a decoding error', () async {
      await expectLater(
        clientWith(FakeAdapter(['[1,2]'])).fetchPatient('x'),
        throwsA(isA<FhirDecodingException>()),
      );
      await expectLater(
        clientWith(FakeAdapter(['{}'])).createObservation({}),
        throwsA(isA<FhirDecodingException>()),
      );
    });
    test('fetchObservations unwraps bundle entries', () async {
      final bundle = jsonEncode({
        'entry': [
          {
            'resource': {'id': '1'},
          },
          {'nope': true},
          {
            'resource': {'id': '2'},
          },
        ],
      });
      final out = await clientWith(FakeAdapter([bundle]))
          .fetchObservations('p');
      expect(out.map((o) => o['id']), ['1', '2']);
    });
    test('retryable statuses', () {
      for (final s in [408, 429, 500, 502, 503, 599]) {
        expect(FhirClient.isRetryable(s), isTrue, reason: '$s');
      }
      for (final s in [200, 400, 401, 403, 404, 409, 422]) {
        expect(FhirClient.isRetryable(s), isFalse, reason: '$s');
      }
    });
  });
}
