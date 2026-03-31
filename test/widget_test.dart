import 'package:flutter_test/flutter_test.dart';
import 'package:waqt/main.dart';

void main() {
  testWidgets('App loads and shows greeting', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WaqtApp());

    // Verify that our app shows the dynamic greeting (default is User)
    expect(find.textContaining('User'), findsWidgets);
  });
}
