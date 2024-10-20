import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart'; // Importa a tela de registro
import 'home_screen.dart'; // Importa a tela inicial após login

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _obscurePassword = true; // Controla a visibilidade da senha

  void _login() async {
    setState(() {
      _errorMessage = ''; // Limpa a mensagem de erro ao iniciar o login
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao fazer login. Verifique suas credenciais.'; // Mensagem de erro
      });
    }
  }

  void _resetPassword(String email) async {
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, insira seu e-mail para recuperar a senha.'; // Mensagem de erro
      });
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      setState(() {
        _errorMessage = 'Email de recuperação enviado! Verifique sua caixa de entrada.'; // Mensagem de sucesso
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao enviar o email de recuperação. Verifique seu e-mail.'; // Mensagem de erro
      });
    }
  }

  void _showResetPasswordDialog() {
    String email = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recuperar Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  email = value; // Captura o e-mail digitado
                },
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Formato de pílula
                    borderSide: BorderSide(color: Colors.white, width: 2), // Bordas brancas
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _resetPassword(email); // Chama a função para resetar a senha
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Enviar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Formato de pílula
                  borderSide: BorderSide(color: Colors.white, width: 2), // Bordas brancas
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword, // Controla a visibilidade da senha
              decoration: InputDecoration(
                labelText: 'Senha',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Formato de pílula
                  borderSide: BorderSide(color: Colors.white, width: 2), // Bordas brancas
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white, // Cor do ícone
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword; // Alterna a visibilidade da senha
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: _showResetPasswordDialog, // Abre a caixa de diálogo de recuperação de senha
              child: Text('Esqueceu a senha?'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Não tem uma conta?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text('Registrar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}