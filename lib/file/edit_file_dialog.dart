import 'package:flutter/material.dart';

class EditFileDialog extends StatelessWidget {
  final String fileName;
  final Function(String) onFileNameChanged;

  const EditFileDialog({
    Key? key,
    required this.fileName,
    required this.onFileNameChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: fileName);

    return AlertDialog(
      title: Text('Editar Arquivo'),
      content: TextField(
        controller: nameController,
        decoration: InputDecoration(labelText: 'Nome do Arquivo'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onFileNameChanged(nameController.text);
            Navigator.pop(context);
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }
}