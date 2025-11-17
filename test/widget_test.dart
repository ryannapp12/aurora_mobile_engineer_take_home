import 'package:flutter_test/flutter_test.dart';

import 'package:aurora_mobile_engineer_take_home/app/app.dart';
import 'dart:io';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hydrated_tests');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  });
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(App), findsOneWidget);
  });
}
