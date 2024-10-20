import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Notificações'),
              trailing: Switch(
                value: true, // Altere conforme necessário
                onChanged: (value) {
                  // Adicione a lógica para alterar as configurações de notificações
                },
              ),
            ),
            ListTile(
              title: Text('Privacidade'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navegue para a tela de privacidade se existir
              },
            ),
            ListTile(
              title: Text('Tema'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navegue para a tela de seleção de tema se existir
              },
            ),
            ListTile(
              title: Text('Sobre'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Adicione a lógica para mostrar informações sobre o aplicativo
              },
            ),
          ],
        ),
      ),
    );
  }
}