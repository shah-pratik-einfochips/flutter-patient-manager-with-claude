import 'dart:math' as math;

/// Rounds half away from zero (clinical convention, matches the native apps).
extension RoundTo on double {
  double roundTo(int places) {
    final p = math.pow(10, places).toDouble();
    return (abs() * p + 0.5).floorToDouble() * (this < 0 ? -1 : 1) / p;
  }
}

abstract final class UnitConversion {
  static const _cmPerInch = 2.54;
  static const _lbsPerKg = 2.20462262185;

  static double cm(double feet, double inches) =>
      (feet * 12 + inches) * _cmPerInch;

  /// Splits centimetres into whole feet and remaining inches (one decimal),
  /// carrying 12" into the next foot.
  static (int feet, double inches) feetAndInches(double cm) {
    final totalInches = cm / _cmPerInch;
    var feet = totalInches ~/ 12;
    var inches = (totalInches - feet * 12).roundTo(1);
    if (inches >= 12) {
      feet += 1;
      inches = 0;
    }
    return (feet, inches);
  }

  static double kg(double lbs) => lbs / _lbsPerKg;
  static double lbs(double kg) => kg * _lbsPerKg;
  static double celsius(double f) => (f - 32) * 5 / 9;
  static double fahrenheit(double c) => c * 9 / 5 + 32;

  /// Mean arterial pressure: (SBP + 2 x DBP) / 3, rounded to one decimal.
  static double meanArterialPressure(double systolic, double diastolic) =>
      ((systolic + 2 * diastolic) / 3).roundTo(1);
}
