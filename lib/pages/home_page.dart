import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../baggage_calculator.dart';
import '../formatters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  TicketClass _ticketClass = TicketClass.economy;
  BaggageResult? _result; // null = nothing calculated yet

  // Only digits, one optional decimal point, max 2 decimals (e.g. 9999.99).
  // Any other key press (letters, "-", a second ".") is ignored.
  static final RegExp _decimalPattern = RegExp(r'^\d{0,4}(\.\d{0,2})?$');
  static final TextInputFormatter _decimalFormatter =
      TextInputFormatter.withFunction((oldValue, newValue) {
    return _decimalPattern.hasMatch(newValue.text) ? newValue : oldValue;
  });

  @override
  void dispose() {
    _weightController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  /// Returns an error message, or null if the value is valid.
  String? _validatePositiveNumber(String? value, String fieldName) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Please enter the $fieldName';
    }
    final double? number = double.tryParse(text);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number <= 0) {
      return 'The $fieldName must be more than 0';
    }
    return null;
  }

  /// Hides an old result as soon as any input changes,
  /// so the screen never shows a result for different inputs.
  void _clearResult() {
    if (_result != null) {
      setState(() => _result = null);
    }
  }

  void _onTicketClassChanged(TicketClass? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _ticketClass = value;
      _result = null;
    });
  }

  void _calculate() {
    FocusScope.of(context).unfocus(); // hide the keyboard

    if (!_formKey.currentState!.validate()) {
      setState(() => _result = null);
      return;
    }

    // Safe to parse: the validator has already checked both values.
    final double weight = double.parse(_weightController.text.trim());
    final double rate = double.parse(_rateController.text.trim());

    setState(() {
      _result = BaggageCalculator.calculate(
        weightKg: weight,
        ticketClass: _ticketClass,
        ratePerKg: rate,
      );
    });
  }

  void _reset() {
    FocusScope.of(context).unfocus();
    _weightController.clear();
    _rateController.clear();
    _formKey.currentState?.reset(); // also removes error messages
    setState(() {
      _ticketClass = TicketClass.economy;
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Estimate your excess baggage fee',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),

                  // 1. Baggage weight
                  TextFormField(
                    key: const Key('weightField'),
                    controller: _weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [_decimalFormatter],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Checked baggage weight',
                      suffixText: 'kg',
                      prefixIcon: Icon(Icons.luggage),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        _validatePositiveNumber(value, 'baggage weight'),
                    onChanged: (_) => _clearResult(),
                  ),
                  const SizedBox(height: 16),

                  // 2. Ticket class
                  Text('Ticket class', style: textTheme.titleSmall),
                  RadioGroup<TicketClass>(
                    groupValue: _ticketClass,
                    onChanged: _onTicketClassChanged,
                    child: Column(
                      children: [
                        for (final TicketClass ticketClass
                            in TicketClass.values)
                          RadioListTile<TicketClass>(
                            key: Key('class_${ticketClass.name}'),
                            value: ticketClass,
                            title: Text(ticketClass.label),
                            subtitle: Text(
                              'Free allowance: '
                              '${formatKg(ticketClass.freeAllowanceKg)}',
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 3. Rate per kg
                  TextFormField(
                    key: const Key('rateField'),
                    controller: _rateController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [_decimalFormatter],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _calculate(),
                    decoration: const InputDecoration(
                      labelText: 'Excess baggage rate per kg',
                      prefixText: 'RM ',
                      prefixIcon: Icon(Icons.payments),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        _validatePositiveNumber(value, 'rate per kg'),
                    onChanged: (_) => _clearResult(),
                  ),
                  const SizedBox(height: 24),

                  FilledButton.icon(
                    key: const Key('calculateButton'),
                    onPressed: _calculate,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    key: const Key('resetButton'),
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),

                  if (_result != null) ...[
                    const SizedBox(height: 24),
                    _ResultCard(result: _result!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the three outputs and how each one was worked out.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final BaggageResult result;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TicketClass ticketClass = result.ticketClass;
    final String allowance = formatKg(ticketClass.freeAllowanceKg);
    final bool hasExcess = result.excessWeightKg > 0;

    final String excessWorking = hasExcess
        ? '${formatKg(result.weightKg)} - $allowance'
        : '${formatKg(result.weightKg)} is within the $allowance allowance';

    return Card(
      key: const Key('resultCard'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Result', style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '${ticketClass.label} class, '
              'rate ${formatRM(result.ratePerKg)} per kg',
              style: textTheme.bodySmall,
            ),
            const Divider(height: 24),
            _ResultRow(
              label: 'Excess baggage weight',
              working: excessWorking,
              value: formatKg(result.excessWeightKg),
            ),
            _ResultRow(
              label: 'Excess baggage charge',
              working: '${formatKg(result.excessWeightKg)} x '
                  '${formatRM(result.ratePerKg)}',
              value: formatRM(result.excessCharge),
            ),
            const Divider(height: 24),
            _ResultRow(
              label: 'Total amount payable',
              working: 'Excess charge + 8% service tax',
              value: formatRM(result.totalPayable),
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.working,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String working;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodyLarge),
                Text(
                  working,
                  style: textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: highlight
                ? textTheme.titleLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  )
                : textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
