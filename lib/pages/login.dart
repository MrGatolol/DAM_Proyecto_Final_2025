import 'package:flutter/material.dart';
import '../services/auth_service.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_note, size: 120, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Eventos USM',
              style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Logeate con google', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                foregroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () => AuthService().signInWithGoogle(),
            ),
          ],
        ),
      ),
    );
  }
}