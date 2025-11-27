import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_apps_moviles/utils/apps_utils.dart';
import '../services/firestore_service.dart';
class EventosDetalle extends StatelessWidget {
  final Map<String, dynamic> datosEvento;
  const EventosDetalle({super.key, required this.datosEvento});
  @override
  Widget build(BuildContext context) {
    // aqui verificamos quien esta viendo los detalles para ver si le mostramos el boton de borrar o no
    final usuarioActual = FirebaseAuth.instance.currentUser;
    // el usuarios solo es dueño si esta logeado y su email coincide con el evento
    // solo mostramos el boton si el email coincide
    final esDueno = usuarioActual != null && datosEvento['autor'] == usuarioActual.email;
    return Scaffold(
      appBar: AppBar(
        title: Text(datosEvento['titulo']),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // solo el dueño puede ver y usar el boton de borrado
          if (esDueno)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                bool confirmar = await AppUtils.mostrarConfirmacion(
                  context,'Eliminar evento','estas seguro de borrar "${datosEvento['titulo']}"?',
                );
                // si el usuario dijo que si entonces borramos el evento
                if (confirmar){
                  // esperamos a firebase termine de borrar
                  await FirestoreService().borrarEvento(datosEvento['id']);
                  if(context.mounted){
                    Navigator.pop(context); // cerramos la vista de detalle
                    ScaffoldMessenger.of (context).showSnackBar(
                      const SnackBar(content: Text('Evento eliminado')),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView( 
          children: [
            // se carga basandose en el nombre de la base de gatos
            Center(
              child: Image.asset(
                'assets/images/${datosEvento['categoria'].toString().toLowerCase()}.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
            // Título
            Text(
              datosEvento['titulo'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 20),
            // Detalles eventos
            Card(
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.indigo),
                    title: const Text("Fecha y Hora"),
                    subtitle: Text(datosEvento['fecha']),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.indigo),
                    title: const Text("Lugar"),
                    subtitle: Text(datosEvento['lugar']),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.label, color: Colors.indigo),
                    title: const Text("Categoría"),
                    subtitle: Text(datosEvento['categoria']),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.indigo),
                    title: const Text("Autor"),
                    subtitle: Text(datosEvento['autor']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}