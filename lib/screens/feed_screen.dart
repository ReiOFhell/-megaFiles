import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Map<String, String>> _passwords = [];
  List<Map<String, String>> _files = []; // Lista para arquivos

  @override
  void initState() {
    super.initState();
    _loadPasswords(); // Carrega as senhas ao iniciar
    _loadFiles(); // Carrega os arquivos ao iniciar
  }

  // Carrega senhas salvas
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

  // Carrega arquivos salvos
  Future<void> _loadFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final filesDir = Directory('${directory.path}/files');
    List<Map<String, String>> fileList = [];

    if (await filesDir.exists()) {
      final files = filesDir.listSync();
      for (var file in files) {
        fileList.add({
          'name': file.uri.pathSegments.last,
          'path': file.path,
          'type': file.path.endsWith('.mp4') ? 'video' : 'image', // Determina o tipo de arquivo
        });
      }
    }

    setState(() {
      _files = fileList; // Atualiza a lista de arquivos
    });
  }

  // Função para construir o bloco de senhas para o feed
  Widget _buildPasswordCard(Map<String, String> passwordData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciador de Senhas',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            'Criado em: ${passwordData['date']}',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Login: ${passwordData['site']}',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Senha: ${passwordData['password']}',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Nota: ${passwordData['note']}',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Função para construir o bloco de arquivos para o feed
  Widget _buildFileCard(Map<String, String> fileData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Arquivo: ${fileData['name']}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 8),
          fileData['type'] == 'video'
              ? Icon(Icons.videocam, size: 48, color: Colors.white) // Ícone para vídeos
              : Icon(Icons.image, size: 48, color: Colors.white), // Ícone para imagens
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tipo: ${fileData['type']}', style: TextStyle(color: Colors.white)),
              ElevatedButton(
                onPressed: () {
                  // Implementar a lógica para visualizar o arquivo
                },
                child: Text('Visualizar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed de Senhas e Arquivos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _passwords.isEmpty && _files.isEmpty
            ? Center(child: Text('Nenhuma senha ou arquivo salvo', style: TextStyle(color: Colors.white)))
            : ListView.builder(
          itemCount: _passwords.length + _files.length,
          itemBuilder: (context, index) {
            if (index < _passwords.length) {
              return _buildPasswordCard(_passwords[index]); // Exibe cada senha como um cartão
            } else {
              return _buildFileCard(_files[index - _passwords.length]); // Exibe cada arquivo como um cartão
            }
          },
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}