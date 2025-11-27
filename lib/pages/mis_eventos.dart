import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import 'detalle_eventos.dart';
class MisEventosPage extends StatelessWidget {
  const MisEventosPage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Publicaciones'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().misEventos(email),
        builder: (context, snapshot) {
          // Si no hay datos O está cargando mostramos el circulo
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Si la lista está vacía (pero cargó bien)
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text('No has publicado eventos aún.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var evento = snapshot.data!.docs[index];
              var data = evento.data() as Map<String, dynamic>;
              data['id'] = evento.id;
              return ListTile(
                leading: const Icon(Icons.bookmark, color: Colors.indigo),
                title: Text(data['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(data['fecha']),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventosDetalle(datosEvento: data),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}