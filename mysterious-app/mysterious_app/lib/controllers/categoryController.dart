import 'package:mysterious_app/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryController {
  Future<List<CategoryProduct>> fetchCategories() async {
    final categoryResponse = await Supabase.instance.client
        .from('categoriaproduto')
        .select('id_categoria, descricao, preco, quantidade_disponivel, imagem_url') 
        .execute();

    if (categoryResponse.error == null) {
      return (categoryResponse.data as List)
          .map((e) => CategoryProduct(
                id_categoria: e['id_categoria'] as int,
                descricao: e['descricao'] as String,
                imagem_url: e['imagem_url'] as String,
                quantidade: e['quantidade_disponivel'] as int, 
                preco: e['preco'] as double, 
              ))
          .toList();
    } else {
      print('Category fetch error: ${categoryResponse.error?.message}');
      print('Category fetch response: ${categoryResponse.data}');
      return [];
    }
  }

  List<CategoryProduct> filterCategories(String query) {
    // Implement your filtering logic here
    return [];
  }
}
