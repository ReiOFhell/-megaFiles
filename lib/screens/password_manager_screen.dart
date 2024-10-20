import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordManagerScreen extends StatefulWidget {
  @override
  _PasswordManagerScreenState createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  List<Map<String, dynamic>> _passwords = [];
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  void _checkUser() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _currentUser = user;
        });
        _loadPasswords();
      }
    });
  }

  Future<void> _loadPasswords() async {
    if (_currentUser == null) return;

    final snapshot = await _firestore
        .collection('passwords')
        .doc(_currentUser!.uid)
        .collection('userPasswords')
        .get();

    setState(() {
      _passwords = snapshot.docs
          .map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>
      })
          .toList();
    });
  }

  Future<void> _savePassword(Map<String, dynamic> passwordData) async {
    if (_currentUser == null) return;

    await _firestore
        .collection('passwords')
        .doc(_currentUser!.uid)
        .collection('userPasswords')
        .add(passwordData);

    _loadPasswords();
  }

  Future<void> _removePassword(String id) async {
    if (_currentUser == null) return;

    await _firestore
        .collection('passwords')
        .doc(_currentUser!.uid)
        .collection('userPasswords')
        .doc(id)
        .delete();

    _loadPasswords();
  }

  Future<void> _editPassword(String id, Map<String, dynamic> updatedData) async {
    if (_currentUser == null) return;

    await _firestore
        .collection('passwords')
        .doc(_currentUser!.uid)
        .collection('userPasswords')
        .doc(id)
        .update(updatedData);

    _loadPasswords();
  }

  void _addPassword() {
    if (_loginController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _noteController.text.isNotEmpty) {
      final passwordData = {
        'login': _loginController.text,
        'password': _passwordController.text,
        'note': _noteController.text,
        'date': DateTime.now().toString(),
      };
      _savePassword(passwordData);
      _loginController.clear();
      _passwordController.clear();
      _noteController.clear();
    }
  }

  void _removePasswordDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir esta senha?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _removePassword(id);
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _editPasswordDialog(String id, Map<String, dynamic> passwordData) {
    _loginController.text = passwordData['login'];
    _passwordController.text = passwordData['password'];
    _noteController.text = passwordData['note'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_loginController, 'Login'),
              _buildPasswordField(),
              _buildTextField(_noteController, 'Nota', maxLines: 3),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _editPassword(id, {
                  'login': _loginController.text,
                  'password': _passwordController.text,
                  'note': _noteController.text,
                  'date': DateTime.now().toString(),
                });
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        maxLines: maxLines,
      ),
    );
  }Widget _buildPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Senha',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        obscureText: !_isPasswordVisible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Senhas'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _passwords.length,
              itemBuilder: (context, index) {
                final passwordData = _passwords[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(passwordData['login']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Senha: ${passwordData['password']}'),
                        Text('Nota: ${passwordData['note']}'),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editPasswordDialog(passwordData['id'], passwordData);
                        } else if (value == 'delete') {
                          _removePasswordDialog(passwordData['id']);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Editar'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildTextField(_loginController, 'Login'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildPasswordField(),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(_noteController, 'Nota'),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addPassword,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}