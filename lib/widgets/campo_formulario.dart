import 'package:flutter/material.dart';
class CampoFormulario extends StatelessWidget {
  final Widget child;
  const CampoFormulario({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.grey[50], // Color suave
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: child,
      ),
    );
  }
}