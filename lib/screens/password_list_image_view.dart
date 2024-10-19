import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordListScreen extends StatefulWidget {
  @override
  _PasswordListScreenState createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  List<String> _passwords = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _passwords = prefs.getStringList('passwords') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Senhas Salvas'),
      ),
      body: ListView.builder(
        itemCount: _passwords.length,
        itemBuilder: (context, index) {
          final passwordData = _passwords[index].split('|');
          return ListTile(
            title: Text(passwordData[0]), // Login
            subtitle: Text('Senha: ${passwordData[1]} - Nota: ${passwordData[2]}'),
          );
        },
      ),
    );
  }
}