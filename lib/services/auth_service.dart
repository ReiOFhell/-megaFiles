import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Registro com e-mail e senha
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Erro ao registrar: ${e.toString()}');
    }
  }

  // Login com e-mail e senha
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }

  // Login com telefone
  Future<User?> signInWithPhone(String smsCode, String verificationId) async {
    try {
      // Cria credencial a partir do código SMS e ID de verificação
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Erro ao fazer login com telefone: ${e.toString()}');
    }
  }

  // Login com Google
  Future<User?> signInWithGoogle() async {
    try {
      // Realiza o login com o Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Cria credenciais do Firebase a partir do token do Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Erro ao fazer login com Google: ${e.toString()}');
    }
  }

  // Registro com telefone e senha (apenas para referência)
  Future<User?> registerWithPhone(String phoneNumber, String password) async {
    try {
      // Simulação de registro via telefone
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception('Falha na verificação do telefone: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Lógica para lidar com o envio de código
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw Exception('Erro ao registrar: ${e.toString()}');
    }
  }
}