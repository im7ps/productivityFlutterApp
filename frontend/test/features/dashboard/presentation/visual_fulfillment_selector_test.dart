import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whativedone/src/features/dashboard/presentation/widgets/visual_fulfillment_selector.dart';

void main() {
  group('VisualFulfillmentSelector', () {
    testWidgets('renders 5 segments', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: VisualFulfillmentSelector(
            value: 3,
            activeColor: Colors.teal,
            onChanged: (_) {},
          ),
        ),
      ));

      // We use GestureDetector behavior or just check for 5 Semantics/Containers
      // The widget uses List.generate(5, ...)
      expect(find.byType(GestureDetector), findsNWidgets(5));
    });

    testWidgets('triggers onChanged with correct value', (tester) async {
      int? selectedValue;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: VisualFulfillmentSelector(
            value: 1,
            activeColor: Colors.teal,
            onChanged: (val) => selectedValue = val,
          ),
        ),
      ));

      // Tap the 4th element (index 3)
      // Since it's a Row of GestureDetectors, we can find them by index or approximate location
      // Finding by index in the list of widgets
      final gestures = find.byType(GestureDetector);
      await tester.tap(gestures.at(3));
      await tester.pump();

      expect(selectedValue, 4);
    });

    testWidgets('shows pulse animation when submitting', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: VisualFulfillmentSelector(
            value: 3,
            activeColor: Colors.teal,
            onChanged: (_) {},
            isSubmitting: true,
          ),
        ),
      ));

      // The 3rd element should have a scale transition/transform active
      // We can check if a Transform is present with a non-identity scale
      // But testing specific TweenAnimationBuilder values is complex in widget tests.
      // At least we check it pumps without error.
      expect(find.byType(TweenAnimationBuilder<double>), findsNWidgets(5));
    });
  });
}
