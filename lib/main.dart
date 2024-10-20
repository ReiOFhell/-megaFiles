import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/password_manager_screen.dart'; // Importa a tela de gerenciamento de senhas
import 'screens/login_screen.dart'; // Importa a tela de login
import 'screens/welcome_screen.dart'; // Importa a tela de boas-vindas
import 'screens/register_screen.dart'; // Importa a tela de registro
import 'screens/profile_screen.dart'; // Importa a tela de perfil

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(OmegaFilesApp());
}

class OmegaFilesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ÔmegaFiles',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.blueGrey[900]!,
          secondary: Colors.cyan[700]!,
          surface: Colors.grey[900]!,
          background: Colors.grey[800]!,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(), // Sempre começa na tela de boas-vindas
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              // Ação para sincronizar dados
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()), // Redireciona para a tela de login
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.cyan[700],
          borderRadius: BorderRadius.circular(40),
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
                icon: Icon(Icons.account_circle),
                label: 'Perfil',
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

// Classe da tela de perfil
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Center(child: Text('Tela de Perfil')),
    );
  }
}