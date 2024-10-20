class PasswordModel {
  String id; // ID único para a senha
  String title; // Título da senha
  String username; // Nome de usuário associado
  String password; // A senha em si
  String notes; // Notas adicionais sobre a senha

  // Construtor da classe
  PasswordModel({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.notes,
  });

  // Método para converter o modelo em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'notes': notes,
    };
  }

  // Método para criar uma instância do modelo a partir de um mapa
  static PasswordModel fromMap(Map<String, dynamic> map) {
    return PasswordModel(
      id: map['id'] as String,
      title: map['title'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      notes: map['notes'] as String,
    );
  }
}