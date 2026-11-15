// Helpers to display numbers on screen.

/// Rounds a non-negative value to 2 decimal places (half-up).
///
/// The tiny 0.000001 nudge fixes binary floating-point errors,
/// e.g. 1.005 is stored as 1.00499999... and would otherwise round down.
double roundTo2(double value) => (value * 100 + 0.000001).round() / 100;

/// 2 decimal places with trailing zeros removed: 5.00 -> "5", 2.50 -> "2.5".
String formatNumber(double value) {
  final String fixed = roundTo2(value).toStringAsFixed(2);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}

/// Weight, e.g. "2.5 kg".
String formatKg(double kg) => '${formatNumber(kg)} kg';

/// Money in Ringgit, e.g. "RM194.40".
String formatRM(double amount) => 'RM${roundTo2(amount).toStringAsFixed(2)}';
