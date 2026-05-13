import 'package:flutter_test/flutter_test.dart';
import 'package:chemai_2/main.dart';
import 'package:chemai_2/app/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Initialize dependencies
    bootstrap();

    // Build the app
    await tester.pumpWidget(const ChemAIApp());

    // Let UI settle
    await tester.pumpAndSettle();

    // Basic check (you can customize this)
    expect(find.byType(ChemAIApp), findsOneWidget);
  });
}