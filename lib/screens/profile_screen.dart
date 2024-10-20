import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firebaseUser = FirebaseAuth.instance.currentUser;
  final _usernameController = TextEditingController();
  File? _avatarImage;
  String? _avatarUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser?.uid)
          .get();

      if (userData.exists) {
        setState(() {
          _usernameController.text = userData['username'] ?? 'Usuário';
          _avatarUrl = userData['avatarUrl'];
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    try {
      String? avatarUrl = _avatarUrl;

      if (_avatarImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('avatars')
            .child('${_firebaseUser?.uid}.jpg');
        await storageRef.putFile(_avatarImage!);
        avatarUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser?.uid)
          .set({
        'username': _usernameController.text.trim(),
        'avatarUrl': avatarUrl,
      });

      setState(() {
        _avatarUrl = avatarUrl;
      });

      _showSuccessDialog('Perfil atualizado com sucesso!');
    } catch (e) {
      _showErrorDialog('Erro ao atualizar perfil: $e');
    }
  }

  Future<void> _pickAvatarImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _avatarImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildUsernameField(),
            SizedBox(height: 10),
            _buildChangePasswordField(),
            SizedBox(height: 20),
            _buildUpdateProfileButton(),
            SizedBox(height: 20),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickAvatarImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _avatarImage != null
                ? FileImage(_avatarImage!)
                : _avatarUrl != null
                ? NetworkImage(_avatarUrl!) as ImageProvider
                : AssetImage('assets/default_avatar.png'),
          ),
        ),
        SizedBox(height: 10),
        Text(
          _usernameController.text.isNotEmpty
              ? _usernameController.text
              : 'Usuário Anônimo',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Nome de Usuário',
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }

  Widget _buildChangePasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Nova Senha',
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }

  Widget _buildUpdateProfileButton() {
    return ElevatedButton(
      onPressed: _updateProfile,
      child: Text('Atualizar Perfil'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _logout,
      child: Text('Sair'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erro'),
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sucesso'),
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
}