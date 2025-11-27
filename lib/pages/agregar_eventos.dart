import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import '../services/firestore_service.dart'; 
import '../widgets/campo_formulario.dart';
class EventosAgregar extends StatefulWidget {
  const EventosAgregar({super.key});
  @override
  State<EventosAgregar> createState() => _EventosAgregarState();
}
class _EventosAgregarState extends State<EventosAgregar> {
  // Llave global para identificar y para validar los camposs
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloCtrl = TextEditingController();
  final TextEditingController _lugarCtrl = TextEditingController();
  final TextEditingController _fechaCtrl = TextEditingController(); 
  DateTime? _fechaSeleccionada;
  String? _categoriaId; 
  // Muestra el selector de fecha 
  Future<void> _seleccionarFecha() async {
    DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (fecha != null) {
      TimeOfDay? hora = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (hora != null) {
        setState(() {
          _fechaSeleccionada = DateTime(
            fecha.year, fecha.month, fecha.day, hora.hour, hora.minute,
          );
          _fechaCtrl.text = DateFormat('dd/MM/yyyy HH:mm').format(_fechaSeleccionada!);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Nuevo Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CampoFormulario(
                child: TextFormField(
                  //validaciones
                  controller: _tituloCtrl,
                  decoration: const InputDecoration(labelText: 'Título del Evento', border: InputBorder.none),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'El título es obligatorio';
                    return null;
                  },
                ),
              ),
              CampoFormulario(
                child: TextFormField(
                  controller: _lugarCtrl,
                  decoration: const InputDecoration(labelText: 'Lugar', border: InputBorder.none),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'El lugar es obligatorio';
                    return null;
                  },
                ),
              ),
              CampoFormulario(
                child: TextFormField(
                  controller: _fechaCtrl,
                  readOnly: true, 
                  decoration: const InputDecoration(
                    labelText: 'Fecha y Hora',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: InputBorder.none,
                  ),
                  onTap: _seleccionarFecha, 
                  validator: (value) => value == null || value.isEmpty ? 'Seleccione una fecha' : null,
                ),
              ),
              // Lista desplegable de categorías desde Firebase
              CampoFormulario(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirestoreService().categorias(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const LinearProgressIndicator();
                    }
                    List<DropdownMenuItem<String>> listaCategorias =
                        snapshot.data!.docs.map((DocumentSnapshot documento) {
                      Map<String, dynamic> data = documento.data()! as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: data['nombre'], 
                        child: Text(data['nombre']), 
                      );
                    }).toList();
                    return DropdownButtonFormField<String>(
                      value: _categoriaId,
                      decoration: const InputDecoration(labelText: 'Categoría', border: InputBorder.none),
                      items: listaCategorias,
                      onChanged: (valor) {
                        setState(() {
                          _categoriaId = valor;
                        });
                      },
                      validator: (value) => value == null ? 'Seleccione una categoría' : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  // si el formulario es valido guardamos
                  if (_formKey.currentState!.validate()) {
                    User? user = FirebaseAuth.instance.currentUser;
                    Map<String, dynamic> eventoData = {
                      'titulo': _tituloCtrl.text,
                      'lugar': _lugarCtrl.text,
                      'fecha': _fechaCtrl.text, 
                      'fecha_ts': _fechaSeleccionada, 
                      'categoria': _categoriaId,
                      'autor': user?.email, 
                      'user_id': user?.uid,
                    };
                    await FirestoreService().agregarEvento(eventoData);   
                    if (context.mounted) {
                      Navigator.pop(context); // Volver a la lista
                    }
                  }
                },
                child: const Text('Publicar Evento', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}