class CategoryProduct {
  final int id_categoria;
  final String descricao;
  final int quantidade;
  final double preco;
  final String imagem_url;

  CategoryProduct({
    required this.id_categoria,
    required this.descricao,
    required this.quantidade,
    required this.preco,
    required this.imagem_url,
  });

  CategoryProduct.withId({
    required this.id_categoria,
    required this.preco
  }) : descricao = '', quantidade = 0, imagem_url = '';

  CategoryProduct.onlyId({
    required this.id_categoria
  }) : descricao = '', quantidade = 0, preco = 0, imagem_url = '';

  CategoryProduct.withDescricao({
    required this.descricao,
    required this.id_categoria,
  }) : quantidade = 0, preco = 0, imagem_url = '';

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id_categoria: json['id_categoria'],
      descricao: json['descricao'],
      quantidade: json['quantidade'],
      preco: json['preco'],
      imagem_url: json['imagem_url'],
    );
  }


}