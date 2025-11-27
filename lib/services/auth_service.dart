import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService {
  // Necesitamos estas dos cosas para que funcione el login
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Función simple para ver si ya hay alguien logeado
  Future<User?> currentUser() async {
    return _auth.currentUser;
  }
  // Esto avisa a toda la app si el usuario entró o salió
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Abrimos la ventanita típica de Google para elegir correo
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // Si el usuario se arrepiente y cierra la ventana, no hacemos nada
      if (googleUser == null) return null;
      // Sacamos los permisos tokens de la cuenta que eligió
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Creamos una credencial con esos datos para que Firebase la acepte
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // finalmente iniciamos sesión en firebase con esa credencial
      return await _auth.signInWithCredential(credential);
    } 
    catch (e) {
      // Si falla retornamos null para que la app no se cierre
      return null;
    }
  }
  // Para salir, hay que cerrar sesión en los dos lados
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Cerramos la de google para que pida cuenta la próxima vez
    await _auth.signOut();         // Cerramos la de firebase
  }
}