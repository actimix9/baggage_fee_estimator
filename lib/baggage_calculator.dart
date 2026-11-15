// Calculation logic for the excess baggage fee.
// This file has no Flutter imports, so it can be unit-tested on its own.

/// Ticket class and its free baggage allowance (X).
enum TicketClass {
  economy('Economy', 20),
  business('Business', 40);

  const TicketClass(this.label, this.freeAllowanceKg);

  final String label;
  final double freeAllowanceKg;
}

/// The inputs and the three outputs of one calculation.
class BaggageResult {
  const BaggageResult({
    required this.weightKg,
    required this.ticketClass,
    required this.ratePerKg,
    required this.excessWeightKg,
    required this.excessCharge,
    required this.totalPayable,
  });

  // Inputs
  final double weightKg;
  final TicketClass ticketClass;
  final double ratePerKg;

  // Outputs
  final double excessWeightKg;
  final double excessCharge;
  final double totalPayable;
}

class BaggageCalculator {
  BaggageCalculator._(); // Only static members, never instantiated.

  /// 8% service tax.
  static const int serviceTaxPercent = 8;

  /// Excess weight = weight - X (never negative)
  /// Excess charge = excess weight * rate per kg
  /// Total payable = excess charge + (8% * excess charge)
  ///
  /// The maths is done with whole numbers (int) instead of double.
  /// A double cannot store values like 0.1 exactly, so money worked out
  /// with doubles can be one sen off after rounding. Inputs have at most
  /// 2 decimal places (the input fields only allow that).
  static BaggageResult calculate({
    required double weightKg,
    required TicketClass ticketClass,
    required double ratePerKg,
  }) {
    if (weightKg < 0 || ratePerKg < 0) {
      throw ArgumentError('Weight and rate cannot be negative.');
    }

    // Convert to hundredths: 42.5 kg -> 4250, RM12 -> 1200 sen.
    final int weight100 = (weightKg * 100).round();
    final int allowance100 = (ticketClass.freeAllowanceKg * 100).round();
    final int rateSen = (ratePerKg * 100).round();

    // Excess weight (hundredths of a kg). Never negative.
    final int difference100 = weight100 - allowance100;
    final int excess100 = difference100 > 0 ? difference100 : 0;

    // Excess charge in units of RM 0.0001 (exact).
    final int charge10k = excess100 * rateSen;

    // Total = charge + 8% of charge = charge * 108%, in units of RM 0.000001.
    final int total1m = charge10k * (100 + serviceTaxPercent);

    // Round both to the nearest sen (half-up).
    final int chargeSen = (charge10k + 50) ~/ 100;
    final int totalSen = (total1m + 5000) ~/ 10000;

    return BaggageResult(
      weightKg: weightKg,
      ticketClass: ticketClass,
      ratePerKg: ratePerKg,
      excessWeightKg: excess100 / 100,
      excessCharge: chargeSen / 100,
      totalPayable: totalSen / 100,
    );
  }
}
