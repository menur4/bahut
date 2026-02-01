// Test widget de base pour l'application Bahut
//
// Ce fichier contient un test de fumée simple pour vérifier
// que l'application peut démarrer sans erreur.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calcul_moyenne/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CalculMoyenneApp(),
      ),
    );

    // Verify that the app renders without crashing
    expect(find.byType(CalculMoyenneApp), findsOneWidget);
  });
}
