import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:taartu_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Taartu App Integration Tests', () {
    testWidgets('App starts successfully', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the app loads without errors
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);

      // Verify no exceptions occurred
      expect(tester.takeException(), isNull);
    });

    testWidgets('App has basic navigation structure', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the app has a body
      expect(find.byType(Scaffold), findsOneWidget);

      // Verify the app can handle user interactions
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();

      // Verify no exceptions occurred
      expect(tester.takeException(), isNull);
    });

    testWidgets('App handles different screen sizes', (tester) async {
      // Test on a smaller screen
      tester.binding.window.physicalSizeTestValue = const Size(375, 667);
      tester.binding.window.devicePixelRatioTestValue = 2.0;

      app.main();
      await tester.pumpAndSettle();

      // Verify the app loads without layout errors
      expect(find.byType(Scaffold), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Reset to default size
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    testWidgets('App can be restarted multiple times', (tester) async {
      for (int i = 0; i < 3; i++) {
        app.main();
        await tester.pumpAndSettle();

        // Verify the app loads each time
        expect(find.byType(Scaffold), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Clean up for next iteration
        await tester.pumpAndSettle();
      }
    });
  });
} 