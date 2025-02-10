import 'package:mysterious_app/models/genre.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GenreController {
  Future<List<Genre>> fetchGenres(int categoryId) async {
    final genreResponse = await Supabase.instance.client
        .from('genero')
        .select('id_genero, quantidade_disponivel, descricao, imagem_url') 
        .eq('id_categoria', categoryId) 
        .limit(10)
        .execute();

    if (genreResponse.error == null) {
      return (genreResponse.data as List)
          .map((e) => Genre(
                id_genero: e['id_genero'] as int,
                quantidade_disponivel: e['quantidade_disponivel'] as int,
                descricao: e['descricao'] as String,
                imagem_url: e['imagem_url'] as String,
              ))
          .toList();
    } else {
      print('Genre fetch error: ${genreResponse.error?.message}');
      print('Genre fetch response: ${genreResponse.data}');
      return [];
    }
  }
}