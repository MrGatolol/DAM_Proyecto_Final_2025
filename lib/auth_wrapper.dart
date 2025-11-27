import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/home.dart';
import 'pages/login.dart';
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // firebase escucha los cambios en tiempo real
      // y si el usuario se deslogea firebase avisa
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}