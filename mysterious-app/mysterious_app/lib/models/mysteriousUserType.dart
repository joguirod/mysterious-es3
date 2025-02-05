class MysteriousUserType {
  final int id_mysterious_user_type;
  final String descricao;

  MysteriousUserType({
    required this.id_mysterious_user_type,
    required this.descricao,
  });

  factory MysteriousUserType.fromJson(Map<String, dynamic> json) {
    return MysteriousUserType(
      id_mysterious_user_type: json['id_mysterious_user_type'],
      descricao: json['descricao'],
    );
  }
}