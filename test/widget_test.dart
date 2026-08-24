import 'package:flutter_test/flutter_test.dart';

import 'package:fybeca/app.dart';
import 'package:fybeca/core/di/locator.dart';

void main() {
  setUp(() {
    setupLocator();
  });

  tearDown(() {
    sl.reset();
  });

  testWidgets('Muestra la pantalla de login cuando no hay sesión activa', (tester) async {
    await tester.pumpWidget(const FybecaApp());
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
  });
}
