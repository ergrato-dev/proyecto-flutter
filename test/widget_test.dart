import 'package:cosmos_flutter/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CosmosApp arranca sin excepciones', (WidgetTester tester) async {
    // Envuelve la app en ProviderScope para satisfacer los providers de Riverpod.
    await tester.pumpWidget(
      const ProviderScope(child: CosmosApp()),
    );
    // Espera a que el router complete la navegación inicial.
    await tester.pumpAndSettle();
    // Verifica que el NavigationBar de la shell está presente.
    expect(find.text('Explorar'), findsOneWidget);
  });
}
