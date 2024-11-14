import 'package:flutter/material.dart';

import 'Vues/onglet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AliKaVoA',
        home: Onglet(),
        routes: {
          '/onglet': (context) => Onglet(),

        },
        initialRoute: '/onglet');
  }
}
