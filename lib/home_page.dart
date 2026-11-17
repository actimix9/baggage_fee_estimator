import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers read what the user types in the text fields
  final TextEditingController weightController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  // Only numbers and a dot can be typed (letters are blocked)
  final List<TextInputFormatter> numbersOnly = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
  ];

  String ticketClass = 'Economy'; // selected radio button

  // Outputs
  bool showResult = false; // true after a successful calculation
  double excessWeight = 0;
  double excessCharge = 0;
  double totalPayable = 0;

  @override
  void dispose() {
    // Free the controllers when the page is removed
    weightController.dispose();
    rateController.dispose();
    super.dispose();
  }

  // CALCULATE button: check the inputs, then work out the fee
  void calculate() {
    FocusScope.of(context).unfocus(); // hide the keyboard

    // tryParse() returns null instead of throwing an error
    // when the text is not a number (Lab 4)
    final double? weight = double.tryParse(weightController.text);
    final double? rate = double.tryParse(rateController.text);

    // Error messages for empty or invalid inputs
    if (weight == null || weight <= 0) {
      showMessage('Please enter the baggage weight (more than 0 kg).');
      return;
    }
    if (rate == null || rate <= 0) {
      showMessage('Please enter the rate per kg (more than RM 0).');
      return;
    }

    // Free allowance (X): Economy = 20 kg, Business = 40 kg
    final double allowance = ticketClass == 'Economy' ? 20 : 40;

    // 1. Excess weight = weight - X (0 if the weight is not more than X)
    double excess = weight - allowance;
    if (excess < 0) {
      excess = 0;
    }

    // 2. Excess charge = excess weight x rate per kg
    final double charge = excess * rate;

    // 3. Total payable = excess charge + 8% service tax
    final double total = charge + (0.08 * charge);

    // Save the outputs and redraw the screen
    setState(() {
      excessWeight = excess;
      excessCharge = charge;
      totalPayable = total;
      showResult = true;
    });
  }

  // RESET button: clear the inputs and hide the result
  void reset() {
    weightController.clear();
    rateController.clear();
    setState(() {
      ticketClass = 'Economy';
      showResult = false;
    });
  }

  // Show a message at the bottom of the screen (SnackBar, Lab 4)
  void showMessage(String text) {
    setState(() => showResult = false); // hide the old result
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  // One line of the result: label on the left, value on the right
  Widget resultRow(String label, String value, {bool bold = false}) {
    final TextStyle style = TextStyle(
      fontSize: bold ? 18 : 16,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: bold ? Theme.of(context).colorScheme.primary : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with instructions (blue card)
            Card(
              color: colors.primary,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Orange circle with a plane icon
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: colors.secondary,
                      foregroundColor: colors.onSecondary,
                      child: const Icon(Icons.flight_takeoff),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Excess Baggage Fee',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fill in your baggage details, then tap CALCULATE.',
                            style: TextStyle(color: colors.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Inputs (white card)
            Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Input 1: baggage weight
                    TextField(
                      controller: weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: numbersOnly,
                      decoration: const InputDecoration(
                        labelText: 'Baggage weight (kg)',
                        hintText: 'e.g. 25.5',
                        prefixIcon: Icon(Icons.luggage),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input 2: ticket class (radio buttons, Lab 4)
                    const Text(
                      'Ticket class',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RadioGroup<String>(
                      groupValue: ticketClass,
                      onChanged: (value) =>
                          setState(() => ticketClass = value!),
                      child: const Column(
                        children: [
                          RadioListTile<String>(
                            title: Text('Economy'),
                            subtitle: Text('Free allowance: 20 kg'),
                            secondary: Icon(Icons.airline_seat_recline_normal),
                            value: 'Economy',
                          ),
                          RadioListTile<String>(
                            title: Text('Business'),
                            subtitle: Text('Free allowance: 40 kg'),
                            secondary: Icon(Icons.airline_seat_flat),
                            value: 'Business',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Input 3: excess baggage rate per kg
                    TextField(
                      controller: rateController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: numbersOnly,
                      decoration: const InputDecoration(
                        labelText: 'Excess baggage rate per kg (RM)',
                        hintText: 'e.g. 15',
                        prefixIcon: Icon(Icons.payments),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Helpful notice about the service tax (orange box)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50, // light orange
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade900),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '8% service tax is added to the excess baggage charge.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Buttons (Lab 3)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: reset,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48), // taller
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('RESET'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: calculate,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48), // taller
                    ),
                    icon: const Icon(Icons.calculate),
                    label: const Text('CALCULATE'),
                  ),
                ),
              ],
            ),

            // Output card, shown after CALCULATE (Lab 7)
            if (showResult) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.white,
                elevation: 2,
                clipBehavior: Clip.antiAlias, // keep the title bar rounded
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Blue title bar of the card
                    Container(
                      color: colors.primary,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.receipt_long, color: colors.onPrimary),
                          const SizedBox(width: 8),
                          Text(
                            'Result',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          resultRow(
                            'Excess baggage weight',
                            '${excessWeight.toStringAsFixed(2)} kg',
                          ),
                          resultRow(
                            'Excess baggage charge',
                            'RM ${excessCharge.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 8),

                          // Total in an orange box so it stands out
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50, // light orange
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: resultRow(
                              'Total amount payable',
                              'RM ${totalPayable.toStringAsFixed(2)}',
                              bold: true,
                            ),
                          ),

                          // Helpful notice when there is no excess baggage
                          if (excessWeight == 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Your baggage is within the free '
                                      'allowance, so there is no excess fee.',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
