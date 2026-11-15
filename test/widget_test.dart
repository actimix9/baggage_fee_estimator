import 'package:baggage_fee_estimator/app_info.dart';
import 'package:baggage_fee_estimator/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// Types the inputs, picks the ticket class, and taps Calculate.
Future<void> fillAndCalculate(
  WidgetTester tester, {
  required String weight,
  required String rate,
  bool business = false,
}) async {
  await tester.enterText(find.byKey(const Key('weightField')), weight);

  if (business) {
    final Finder businessTile = find.byKey(const Key('class_business'));
    await tester.ensureVisible(businessTile);
    await tester.pumpAndSettle();
    await tester.tap(businessTile);
    await tester.pumpAndSettle();
  }

  await tester.enterText(find.byKey(const Key('rateField')), rate);

  final Finder calculateButton = find.byKey(const Key('calculateButton'));
  await tester.ensureVisible(calculateButton);
  await tester.pumpAndSettle();
  await tester.tap(calculateButton);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('App title is shown in the app bar', (tester) async {
    await tester.pumpWidget(const BaggageFeeApp());

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text(AppInfo.appTitle),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Economy 25 kg at RM15/kg gives RM81.00', (tester) async {
    await tester.pumpWidget(const BaggageFeeApp());
    await fillAndCalculate(tester, weight: '25', rate: '15');

    expect(find.byKey(const Key('resultCard')), findsOneWidget);
    expect(find.text('5 kg'), findsOneWidget);
    expect(find.text('RM75.00'), findsOneWidget);
    expect(find.text('RM81.00'), findsOneWidget);
  });

  testWidgets('Economy 18 kg at RM15/kg gives RM0.00', (tester) async {
    await tester.pumpWidget(const BaggageFeeApp());
    await fillAndCalculate(tester, weight: '18', rate: '15');

    expect(find.text('0 kg'), findsOneWidget);
    expect(find.text('RM0.00'), findsNWidgets(2)); // charge and total
  });

  testWidgets('Business 55 kg at RM12/kg gives RM194.40', (tester) async {
    await tester.pumpWidget(const BaggageFeeApp());
    await fillAndCalculate(tester, weight: '55', rate: '12', business: true);

    expect(find.text('15 kg'), findsOneWidget);
    expect(find.text('RM180.00'), findsOneWidget);
    expect(find.text('RM194.40'), findsOneWidget);
  });

  testWidgets('Business 42.5 kg at RM12/kg gives RM32.40', (tester) async {
    await tester.pumpWidget(const BaggageFeeApp());
    await fillAndCalculate(tester, weight: '42.5', rate: '12', business: true);

    expect(find.text('2.5 kg'), findsOneWidget);
    expect(find.text('RM30.00'), findsOneWidget);
    expect(find.text('RM32.40'), findsOneWidget);
  });

  testWidgets('Empty inputs show errors and no result', (tester) async {
    await tester.pumpWidget(const BaggageFeeApp());

    final Finder calculateButton = find.byKey(const Key('calculateButton'));
    await tester.ensureVisible(calculateButton);
    await tester.pumpAndSettle();
    await tester.tap(calculateButton);
    await tester.pumpAndSettle();

    expect(find.text('Please enter the baggage weight'), findsOneWidget);
    expect(find.text('Please enter the rate per kg'), findsOneWidget);
    expect(find.byKey(const Key('resultCard')), findsNothing);
  });

  testWidgets('Letters cannot be typed into the weight field', (tester) async {
    await tester.pumpWidget(const BaggageFeeApp());
    await tester.enterText(find.byKey(const Key('weightField')), 'abc');
    await tester.pump();

    expect(find.text('abc'), findsNothing);
  });

  testWidgets('Navigation menu opens the About page', (tester) async {
    await tester.pumpWidget(const BaggageFeeApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('navHome')), findsOneWidget);
    expect(find.byKey(const Key('navAbout')), findsOneWidget);

    await tester.tap(find.byKey(const Key('navAbout')));
    await tester.pumpAndSettle();

    final IndexedStack pages =
        tester.widget<IndexedStack>(find.byKey(const Key('pageStack')));
    expect(pages.index, 1);
    expect(find.text(AppInfo.authorName), findsOneWidget);
    expect(find.text(AppInfo.matricNo), findsOneWidget);
    expect(find.text(AppInfo.course), findsOneWidget);
    expect(find.text(AppInfo.githubUrl), findsOneWidget);
    expect(find.text(AppInfo.copyright), findsOneWidget);
    expect(find.byKey(const Key('appIcon')), findsOneWidget);
  });
}
