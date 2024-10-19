import 'package:flutter/material.dart';
import 'dart:io';

class FullScreenImageView extends StatelessWidget {
  final File imageFile;

  FullScreenImageView({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Fecha a visualização ao tocar na imagem
          },
          child: Image.file(imageFile),
        ),
      ),
    );
  }
}