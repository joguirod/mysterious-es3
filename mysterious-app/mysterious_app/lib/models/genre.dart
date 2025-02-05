class Genre {
  final int id_genero;
  final String descricao;
  final int quantidade_disponivel;
  final String imagem_url;

  Genre({
    required this.id_genero,
    required this.descricao,
    required this.quantidade_disponivel,
    required this.imagem_url,
  });

  Genre.withId({
    required this.id_genero,
  }) : descricao = '', quantidade_disponivel = 0, imagem_url = '';

  Genre.withDescricao({
    required this.descricao,
    required this.id_genero,
  }) : quantidade_disponivel = 0, imagem_url = '';

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id_genero: json['id_genero'],
      descricao: json['descricao'],
      quantidade_disponivel: json['quantidade_disponivel'],
      imagem_url: json['imagem_url'],
    );
  }
}