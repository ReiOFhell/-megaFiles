import 'package:flutter/material.dart';
import 'screens/password_manager_screen.dart'; // Importa a tela de gerenciamento de senhas
import 'screens/feed_screen.dart'; // Importa a tela do Feed
import 'file/file_manager_screen.dart'; // Importa a tela de gerenciamento de arquivos

void main() {
  runApp(OmegaFilesApp());
}

class OmegaFilesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ÔmegaFiles',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.blueGrey[900]!, // Cor primária
          secondary: Colors.cyan[700]!, // Cor secundária (destaque)
          surface: Colors.grey[900]!, // Cor de superfícies
          background: Colors.grey[800]!, // Cor de fundo
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark, // Tema escuro
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // HomeScreen como tela inicial
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de telas
  final List<Widget> _screens = [
    FeedScreen(), // Tela do Feed com senhas salvas
    FileManagerScreen(), // Tela de gerenciamento de arquivos
    PasswordManagerScreen(), // Tela de gerenciamento de senhas
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
                icon: Icon(Icons.feed),
                label: 'Feed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder),
                label: 'Gerenciador de Arquivos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lock),
                label: 'Gerenciador de Senhas',
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