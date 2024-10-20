import 'package:flutter/material.dart';
import 'password_manager_screen.dart'; // Importa a tela de gerenciamento de senhas
import 'profile_screen.dart'; // Importa a tela de perfil

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de telas, agora sem o Feed
  final List<Widget> _screens = [
    PasswordManagerScreen(), // Tela de gerenciamento de senhas
    ProfileScreen(), // Tela de perfil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ÔmegaFiles'),
      ),
      body: _screens[_selectedIndex], // Exibe a tela selecionada
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.cyan[700],
          borderRadius: BorderRadius.circular(40), // Pílula maior
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.lock),
                label: 'Gerenciador de Senhas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil', // Adiciona a opção de Perfil
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: Colors.transparent,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}