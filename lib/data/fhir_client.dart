import 'dart:async';

import 'package:dio/dio.dart';

import 'fhir_mapper.dart';

sealed class FhirException implements Exception {
  const FhirException(this.message);
  final String message;
  @override
  String toString() => message;
}

class FhirHttpException extends FhirException {
  FhirHttpException(this.code)
    : super('The server responded with status $code.');
  final int code;
}

class FhirDecodingException extends FhirException {
  const FhirDecodingException()
    : super('The server response could not be read.');
}

class FhirNetworkException extends FhirException {
  FhirNetworkException(Object cause)
    : super(
        'Network error: ${cause is DioException ? (cause.message ?? cause.type.name) : cause}',
      );
}

abstract interface class FhirApi {
  Future<Json> upsertPatient(Json json);
  Future<Json> fetchPatient(String id);
  Future<String> createObservation(Json json);
  Future<List<Json>> fetchObservations(String patientId);
}

class FhirClient implements FhirApi {
  FhirClient({
    required String baseUrl,
    Dio? dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(milliseconds: 500),
    this.tokenProvider,
  }) : _dio = (dio ?? Dio())
         ..options.baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'
         ..options.headers['Accept'] = 'application/fhir+json'
         ..options.connectTimeout = const Duration(seconds: 15)
         ..options.receiveTimeout = const Duration(seconds: 30)
         // Status handling is done here so retries are explicit and bounded.
         ..options.validateStatus = ((_) => true);

  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;
  final Future<String?> Function()? tokenProvider;

  @override
  Future<Json> upsertPatient(Json json) {
    final id = json['id'];
    return id is String
        ? _call('Patient/$id', 'PUT', json)
        : _call('Patient', 'POST', json);
  }

  @override
  Future<Json> fetchPatient(String id) => _call('Patient/$id', 'GET', null);

  @override
  Future<String> createObservation(Json json) async {
    final id = (await _call('Observation', 'POST', json))['id'];
    if (id is! String) throw const FhirDecodingException();
    return id;
  }

  @override
  Future<List<Json>> fetchObservations(String patientId) async {
    final bundle = await _call(
      'Observation?patient=$patientId&category=vital-signs&_sort=-date&_count=100',
      'GET',
      null,
    );
    final entries = bundle['entry'];
    if (entries is! List) return [];
    return [
      for (final e in entries)
        if (e is Map && e['resource'] is Map)
          Map<String, dynamic>.from(e['resource'] as Map),
    ];
  }

  Future<Json> _call(String path, String method, Json? body) async {
    final token = await tokenProvider?.call();
    final options = Options(
      method: method,
      contentType: 'application/fhir+json',
      headers: {if (token != null) 'Authorization': 'Bearer $token'},
    );
    var attempt = 0;
    while (true) {
      try {
        final response = await _dio.request<Object>(
          path,
          data: body,
          options: options,
        );
        final code = response.statusCode ?? 0;
        if (code >= 200 && code < 300) {
          final data = response.data;
          if (data == null || (data is String && data.trim().isEmpty))
            return {};
          if (data is Map) return Map<String, dynamic>.from(data);
          throw const FhirDecodingException();
        }
        if (!isRetryable(code) || attempt >= maxRetries)
          throw FhirHttpException(code);
      } on DioException catch (e) {
        if (attempt >= maxRetries) throw FhirNetworkException(e);
      }
      attempt++;
      await Future<void>.delayed(retryDelay * (1 << (attempt - 1)));
    }
  }

  /// Retry only transient failures: timeouts, rate limiting and 5xx.
  static bool isRetryable(int status) =>
      status == 408 || status == 429 || (status >= 500 && status <= 599);
}
