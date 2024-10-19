import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FileManagerScreen extends StatefulWidget {
  @override
  _FileManagerScreenState createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  List<File> _files = [];
  List<String> _fileTitles = [];
  List<String> _fileSizes = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFiles = prefs.getStringList('files');
    List<String>? savedTitles = prefs.getStringList('titles');
    List<String>? savedSizes = prefs.getStringList('sizes');

    if (savedFiles != null && savedTitles != null && savedSizes != null) {
      setState(() {
        _files = savedFiles.map((path) => File(path)).toList();
        _fileTitles = savedTitles;
        _fileSizes = savedSizes;
      });
    }
  }

  Future<void> _saveFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedFiles = _files.map((file) => file.path).toList();
    await prefs.setStringList('files', savedFiles);
    await prefs.setStringList('titles', _fileTitles);
    await prefs.setStringList('sizes', savedFiles);
  }

  void _addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        File file = File(filePath);
        String fileSize = await _getFileSize(file);
        setState(() {
          _files.add(file);
          _fileTitles.add('Título do Arquivo');
          _fileSizes.add(fileSize);
        });
        await _saveFiles();
        await _addToFeed(file);
      }
    }
  }

  Future<String> _getFileSize(File file) async {
    int bytes = await file.length();
    return (bytes / (1024 * 1024)).toStringAsFixed(2) + ' MB';
  }

  Future<void> _addToFeed(File file) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> passwords = [];
    final String? passwordsString = prefs.getString('passwords');
    if (passwordsString != null) {
      passwords = List<Map<String, String>>.from(json.decode(passwordsString));
    }
    passwords.add({
      'date': DateTime.now().toString(),
      'site': file.path.split('/').last,
      'password': 'Não aplicável',
      'note': 'Descrição do arquivo',
    });
    await prefs.setString('passwords', json.encode(passwords));
  }

  void _openFile(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FileViewerScreen(file: file)),
    );
  }

  void _openExternally(File file) async {
    try {
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        throw 'Erro ao abrir o arquivo: ${result.message}';
      }
    } catch (e) {
      print('Erro ao abrir o arquivo externamente: $e');
    }
  }

  void _editTitle(int index) {
    TextEditingController controller = TextEditingController(text: _fileTitles[index]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Título'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Título do Arquivo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _fileTitles[index] = controller.text;
                });
                _saveFiles();
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFile(int index) {
    File fileToDelete = _files[index];
    setState(() {
      _files.removeAt(index);
      _fileTitles.removeAt(index);
      _fileSizes.removeAt(index);
    });
    _saveFiles();
    _removeFromFeed(fileToDelete);
  }

  Future<void> _removeFromFeed(File file) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> passwords = [];
    final String? passwordsString = prefs.getString('passwords');
    if (passwordsString != null) {
      passwords = List<Map<String, String>>.from(json.decode(passwordsString));
    }
    passwords.removeWhere((password) => password['site'] == file.path.split('/').last);
    await prefs.setString('passwords', json.encode(passwords));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerenciador de Arquivos')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _addFile,
            child: Icon(Icons.add),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                File file = _files[index];
                return Card(
                  color: Colors.blueAccent,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                          child: Image.file(file),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_fileTitles[index], style: TextStyle(fontSize: 18)),
                              SizedBox(height: 5),
                              Text(_fileSizes[index], style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () => _openFile(file),
                        ),
                        IconButton(
                          icon: Icon(Icons.open_in_new),
                          onPressed: () => _openExternally(file),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editTitle(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteFile(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FileViewerScreen extends StatefulWidget {
  final File file;

  FileViewerScreen({required this.file});

  @override
  _FileViewerScreenState createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  late VideoPlayerController _controller;
  late bool _isVideo;

  @override
  void initState() {
    super.initState();
    _isVideo = _checkIfVideo(widget.file);
    if (_isVideo) {
      _controller = VideoPlayerController.file(widget.file)
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
    }
  }

  bool _checkIfVideo(File file) {
    final String extension = file.path.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv'].contains(extension);
  }

  @override
  void dispose() {
    if (_isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file.path.split('/').last),
      ),
      body: Center(
        child: _isVideo
            ? AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoPlayer(_controller),
        )
            : Image.file(widget.file),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}