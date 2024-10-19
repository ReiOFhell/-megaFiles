import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PasswordManagerScreen extends StatefulWidget {
  @override
  _PasswordManagerScreenState createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  List<Map<String, String>> _passwords = [];
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? passwordsString = prefs.getString('passwords');

    if (passwordsString != null) {
      List<dynamic> passwordsList = json.decode(passwordsString);
      setState(() {
        _passwords = passwordsList.map((password) => Map<String, String>.from(password)).toList();
      });
    }
  }

  Future<void> _savePasswords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('passwords', json.encode(_passwords));
  }

  void _addPassword() {
    if (_siteController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      setState(() {
        _passwords.add({
          'site': _siteController.text,
          'password': _passwordController.text,
          'note': _noteController.text,
          'date': DateTime.now().toString(),
        });
      });
      _siteController.clear();
      _passwordController.clear();
      _noteController.clear();
      _savePasswords();
    }
  }

  void _removePassword(int index) {
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
                setState(() {
                  _passwords.removeAt(index);
                });
                _savePasswords();
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _editPassword(int index) {
    _siteController.text = _passwords[index]['site']!;
    _passwordController.text = _passwords[index]['password']!;
    _noteController.text = _passwords[index]['note']!;

    bool _isEditingPasswordVisible = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Senha'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(_siteController, 'Site'),
                  _buildPasswordField(
                    isEditing: true,
                    isPasswordVisible: _isEditingPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isEditingPasswordVisible = !_isEditingPasswordVisible;
                      });
                    },
                  ),
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
                    setState(() {
                      _passwords[index] = {
                        'site': _siteController.text,
                        'password': _passwordController.text,
                        'note': _noteController.text,
                        'date': DateTime.now().toString(),
                      };
                    });
                    _siteController.clear();
                    _passwordController.clear();
                    _noteController.clear();
                    _savePasswords();
                    Navigator.of(context).pop();
                  },
                  child: Text('Salvar'),
                ),
              ],
            );
          },
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
  }

  Widget _buildPasswordField({
    bool isEditing = false,
    required bool isPasswordVisible,
    required VoidCallback toggleVisibility,
  }) {
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
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: toggleVisibility,
          ),
        ),
        obscureText: !isPasswordVisible,
      ),
    );
  }

  Widget _buildPasswordCard(Map<String, String> passwordData, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text('Login: ${passwordData['site']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Senha: ${passwordData['password']}'),
            Text('Nota: ${passwordData['note']}'),
            Text('Criado em: ${passwordData['date']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editPassword(index),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removePassword(index),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Senhas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_siteController, 'Login'),
            _buildPasswordField(
              isPasswordVisible: _isPasswordVisible,
              toggleVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            _buildTextField(_noteController, 'Nota', maxLines: 3),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addPassword,
              child: Text('Adicionar Senha'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _passwords.isEmpty
                  ? Center(child: Text('Nenhuma senha salva'))
                  : ListView.builder(
                itemCount: _passwords.length,
                itemBuilder: (context, index) {
                  return _buildPasswordCard(_passwords[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}