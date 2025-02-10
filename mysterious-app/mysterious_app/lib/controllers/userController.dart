import 'package:supabase_flutter/supabase_flutter.dart';

class UserController {
  Future<Map<String, String>> fetchUserName() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final userId = session.user!.id;
      final response = await Supabase.instance.client
          .from('mysterioususer')
          .select('username, email')
          .eq('id_mysterious_user', userId)
          .single()
          .execute();

      if (response.error == null && response.data != null) {
        return {
          'username': response.data['username'],
          'email': response.data['email'],
        };
      } else {
        print('Erro ao buscar nome do usuário: ${response.error?.message}');
        return {};
      }
    }
    return {};
  }

  Future<Session?> login(email, password) async {
    try {
      final response = await Supabase.instance.client.auth.signIn(
        email: email,
        password: password,
      );

      if (response.error != null) {
        print("erro: ${response.error!.message}");
      } else {
        // Verificar se o usuário está autenticado
        return Supabase.instance.client.auth.currentSession!;
      }
    } catch (e) {
      print('Erro ao realizar login: $e');
    }
    return null;
  }
}