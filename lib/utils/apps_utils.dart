import 'package:flutter/material.dart';

class AppUtils {
  static Future<bool> mostrarConfirmacion(
    BuildContext context,
    String titulo,
    String mensaje,
  ) 
  async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, 
          surfaceTintColor: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded, size: 40),
          iconColor: Colors.red, 
          title: Text(titulo, textAlign: TextAlign.center),
          content: Text(mensaje, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Aceptar'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    return resultado ?? false;
  }
}