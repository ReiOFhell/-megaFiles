import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Importa a tela de login
import 'register_screen.dart'; // Importa a tela de registro
import 'home_screen.dart'; // Importa a tela inicial

class WelcomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Faz login com o Google
      await _auth.signInWithCredential(credential);

      // Armazenar o estado de login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      // Navegar para a tela inicial
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen())); // Redireciona para a HomeScreen
    } catch (error) {
      print("Erro ao fazer login com o Google: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo ao ÔmegaFiles'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Removido 'isEmail'
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[700], // Cor de fundo do botão
                foregroundColor: Colors.white, // Cor do texto
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Tamanho do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                ),
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[700], // Cor de fundo do botão
                foregroundColor: Colors.white, // Cor do texto
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Tamanho do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                ),
              ),
              child: Text('Registrar'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _signInWithGoogle(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[700], // Cor de fundo do botão
                foregroundColor: Colors.white, // Cor do texto
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Tamanho do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                ),
              ),
              child: Text('Entrar com Google'),
            ),
          ],
        ),
      ),
    );
  }
}