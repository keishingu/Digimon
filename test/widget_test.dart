import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:digimon_v2/main.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const DigimonApp());
  }

  testWidgets('卵から孵化し、ごはんで満腹度が回復する', (tester) async {
    await pumpApp(tester);

    expect(find.text('成長段階'), findsOneWidget);
    expect(find.text('Digitama'), findsOneWidget);

    // デバッグボタンで孵化(10秒)まで時間を進める
    await tester.tap(find.text('+10秒'));
    await tester.pump();
    expect(find.text('Zurumon'), findsOneWidget);

    // 孵化直後は満腹度2
    expect(find.text('♥♥♡♡'), findsNWidgets(2));

    // ごはんをあげる → 食事アニメーション(約2.4秒)後に満腹度3
    await tester.tap(find.text('ごはん（おにく）'));
    await tester.pump();
    expect(find.textContaining('おにくを食べています'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('♥♥♥♡'), findsOneWidget);

    // A→Bボタンのメニュー操作でもう一度ごはん
    await tester.tap(find.text('A'));
    await tester.pump();
    expect(find.text('▶ ごはん'), findsOneWidget);
    await tester.tap(find.text('B'));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('♥♥♥♥'), findsAtLeastNWidgets(1));
  });

  testWidgets('Aでメニューを切り替え、Cでキャンセルできる', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('+10秒'));
    await tester.pump();

    await tester.tap(find.text('A'));
    await tester.pump();
    expect(find.text('▶ ごはん'), findsOneWidget);

    await tester.tap(find.text('A'));
    await tester.pump();
    expect(find.text('▶ プロテイン'), findsOneWidget);

    await tester.tap(find.text('C'));
    await tester.pump();
    expect(find.text('▶ プロテイン'), findsNothing);
  });
}
