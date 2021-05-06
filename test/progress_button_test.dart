import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_indicator_button/button_stagger_animation.dart';
import 'package:progress_indicator_button/progress_button.dart';
import '../example/lib/src/app.dart';

void main() {
  testWidgets('ProgressButton - Start animation on click',
      (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.byType(ProgressButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));

    final widget = tester
        .widget<ButtonStaggerAnimation>(find.byType(ButtonStaggerAnimation));
    expect(widget.controller.isAnimating, true);
  });
}
