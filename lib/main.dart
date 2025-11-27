import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'auth_wrapper.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proyecto Eventos',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo ),
      localizationsDelegates: const[ // esta configuracion sirve para poner en español el calendario y el menu del sistema
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const[
        Locale('es', 'ES'), //ponemo el idioma en español
      ],
      home: const AuthWrapper(), //esto decide si mostramos el login o el home de la app
    );
  }
}