import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService {
  // hacemos referencia a la base de datos
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // lenamos dropdown
  Stream<QuerySnapshot> categorias() {
    return _db.collection('categorias').snapshots();
  }
  // usamos future tambien porque agregar se hace una sola vez
  // guarda eventos en la coleccion y firestore genera un id automaticamente
  Future<void> agregarEvento(Map<String, dynamic> data) {
    return _db.collection('eventos').add(data);
  }
  // aca usamoms stream para que se actualice los eventos en tiempo real
  // llama los eventos ordenados por fecha del mas antiguo al mas nuevo
  Stream<QuerySnapshot> eventos() {
    return _db.collection('eventos').orderBy('fecha_ts', descending: false) .snapshots();
  }
  // elimina un evento usando su id 
  Future<void> borrarEvento(String id) {
    return _db.collection('eventos').doc(id).delete();
  }
  // es un filtro para que traiga los eventos donde el campo autor
  // coincida con el email actual
  Stream<QuerySnapshot> misEventos(String email) {
    return _db.collection('eventos').where('autor', isEqualTo: email).snapshots();
  }
}