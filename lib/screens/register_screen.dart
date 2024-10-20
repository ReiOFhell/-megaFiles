import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart'; // Importa a tela inicial após o registro

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true; // Controla a visibilidade da senha

  void _register() async {
    try {
      // Registro com e-mail e senha
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navega para a tela inicial após o registro bem-sucedido
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      // Exibir mensagem de erro se houver falha no registro
      _showErrorDialog('Erro: ${e.message}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erro de Registro'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(_emailController, 'E-mail'),
            _buildTextField(_passwordController, 'Senha', obscureText: _obscurePassword),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[850], // Cor de fundo do campo
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Borda arredondada
            borderSide: BorderSide(color: Colors.white, width: 1), // Borda branca
          ),
          suffixIcon: label == 'Senha' // Adiciona o ícone apenas no campo de senha
              ? IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.white, // Cor do ícone
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword; // Alterna a visibilidade da senha
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}