import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../services/auth_service.dart';
import '../services/firestore_service.dart'; 
import 'agregar_eventos.dart'; 
import 'detalle_eventos.dart';
import 'mis_eventos.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final emailUsuario = user?.email ?? 'Anónimo';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos USM'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            onSelected: (opcion) {
              if (opcion == 'logout') {
                AuthService().signOut();
              } 
              else if (opcion == 'mis_eventos') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MisEventosPage()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'mis_eventos', child: Text('Mis Publicaciones')),
              const PopupMenuItem(value: 'logout', child: Text('Cerrar Sesión')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.indigo.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bienvenido,', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(emailUsuario, style: const TextStyle(color: Colors.indigo)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().eventos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay eventos publicados aún.'));
                }
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var evento = snapshot.data!.docs[index];
                    var data = evento.data() as Map<String, dynamic>;
                    data['id'] = evento.id; 
                    return ListTile(
                      leading: Image.asset(
                        'assets/images/${data['categoria'].toString().toLowerCase()}.png',
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                      ),
                      //datos de eventossssss
                      title: Text(data['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${data['fecha']} • ${data['lugar']}'),
                          Text('Autor: ${data['autor']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EventosDetalle(datosEvento: data)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EventosAgregar()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}