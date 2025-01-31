import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController foneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final userId = session.user!.id;
      final response = await Supabase.instance.client
          .from('mysterioususer')
          .select('username, fone, email')
          .eq('id_mysterious_user', userId)
          .single()
          .execute();

      if (response.error == null && response.data != null) {
        setState(() {
          usernameController.text = response.data['username'];
          foneController.text = response.data['fone'];
          emailController.text = response.data['email'];
        });
      } else {
        print('Erro ao carregar dados do usuário: ${response.error?.message}');
      }
    }
  }

  Future<void> _updateUserData() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final userId = session.user!.id;
      final updates = {
        'username': usernameController.text,
        'fone': foneController.text,
        'email': emailController.text,
      };

      final response = await Supabase.instance.client
          .from('mysterioususer')
          .update(updates)
          .eq('id_mysterious_user', userId)
          .execute();

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
      } else {
        print('Erro ao atualizar dados do usuário: ${response.error?.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${response.error!.message}')),
        );
      }

      // Atualizar senha do usuário
      final password = passwordController.text.trim();
      if (password.isNotEmpty) {
        final passwordResponse = await Supabase.instance.client.auth.update(UserAttributes(
          password: password,
        ));

        if (passwordResponse.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar senha: ${passwordResponse.error!.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha atualizada com sucesso!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: foneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateUserData,
              child: const Text('Atualizar Dados'),
            ),
          ],
        ),
      ),
    );
  }
}