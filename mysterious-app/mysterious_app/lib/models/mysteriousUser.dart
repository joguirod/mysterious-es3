import 'package:mysterious_app/models/mysteriousUserType.dart';
import 'package:uuid/uuid.dart';

class MysteriousUser {
  final Uuid id_mysterious_user;
  final String username;
  final String email;
  final String senha;
  final String fone;
  final MysteriousUserType mysteriousUserType;

  MysteriousUser({
    required this.id_mysterious_user,
    required this.username,
    required this.email,
    required this.senha,
    required this.fone,
    required this.mysteriousUserType,
  });

  MysteriousUser.withId({
    required this.id_mysterious_user
  }) : username = '', email = '', senha = '', fone = '', mysteriousUserType = MysteriousUserType(id_mysterious_user_type: 0, descricao: '');

  factory MysteriousUser.fromJson(Map<String, dynamic> json) {
    return MysteriousUser(
      id_mysterious_user: json['id_mysterious_user'],
      username: json['username'],
      email: json['email'],
      senha: json['senha'],
      fone: json['fone'],
      mysteriousUserType: json['mysteriousUserType'],
    );
  }
}