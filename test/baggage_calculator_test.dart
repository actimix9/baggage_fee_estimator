import 'package:baggage_fee_estimator/baggage_calculator.dart';
import 'package:baggage_fee_estimator/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sample calculations from the assignment brief', () {
    test('25 kg, economy, RM15/kg -> 5 kg, RM75.00, RM81.00', () {
      final BaggageResult r = BaggageCalculator.calculate(
        weightKg: 25,
        ticketClass: TicketClass.economy,
        ratePerKg: 15,
      );
      expect(formatKg(r.excessWeightKg), '5 kg');
      expect(formatRM(r.excessCharge), 'RM75.00');
      expect(formatRM(r.totalPayable), 'RM81.00');
    });

    test('18 kg, economy, RM15/kg -> 0 kg (never negative), RM0.00', () {
      final BaggageResult r = BaggageCalculator.calculate(
        weightKg: 18,
        ticketClass: TicketClass.economy,
        ratePerKg: 15,
      );
      expect(r.excessWeightKg, 0);
      expect(formatKg(r.excessWeightKg), '0 kg');
      expect(formatRM(r.excessCharge), 'RM0.00');
      expect(formatRM(r.totalPayable), 'RM0.00');
    });

    test('55 kg, business, RM12/kg -> 15 kg, RM180.00, RM194.40', () {
      final BaggageResult r = BaggageCalculator.calculate(
        weightKg: 55,
        ticketClass: TicketClass.business,
        ratePerKg: 12,
      );
      expect(formatKg(r.excessWeightKg), '15 kg');
      expect(formatRM(r.excessCharge), 'RM180.00');
      expect(formatRM(r.totalPayable), 'RM194.40');
    });

    test('42.5 kg, business, RM12/kg -> 2.5 kg, RM30.00, RM32.40', () {
      final BaggageResult r = BaggageCalculator.calculate(
        weightKg: 42.5,
        ticketClass: TicketClass.business,
        ratePerKg: 12,
      );
      expect(formatKg(r.excessWeightKg), '2.5 kg');
      expect(formatRM(r.excessCharge), 'RM30.00');
      expect(formatRM(r.totalPayable), 'RM32.40');
    });
  });

  group('Edge cases', () {
    test('weight exactly at the allowance gives 0 excess', () {
      final BaggageResult r = BaggageCalculator.calculate(
        weightKg: 40,
        ticketClass: TicketClass.business,
        ratePerKg: 12,
      );
      expect(r.excessWeightKg, 0);
      expect(r.totalPayable, 0);
    });

    test('negative input throws ArgumentError', () {
      expect(
        () => BaggageCalculator.calculate(
          weightKg: -1,
          ticketClass: TicketClass.economy,
          ratePerKg: 15,
        ),
        throwsArgumentError,
      );
    });

    test('money rounds half-up correctly despite floating point', () {
      expect(formatRM(1.005), 'RM1.01');
      expect(formatRM(0.125), 'RM0.13');
      expect(formatKg(20.1 - 20), '0.1 kg');
    });
  });
}
