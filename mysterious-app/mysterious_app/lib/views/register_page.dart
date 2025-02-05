import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Uuid uuid = Uuid();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    try {
      // Registrar o usuário com autenticação Supabase
      final response = await Supabase.instance.client.auth.signUp(email, password);

      if (response.error == null) {
   
        final user = response.user;

        final insertResponse = await Supabase.instance.client
            .from('mysterioususer')
            .insert({
              'username': name,
              'email': email,
              'senha': password,
              'id_mysterious_user': user?.id ?? uuid.v4(), // Usar o ID do usuário ou gerar UUID
              'id_mysterious_user_type': 'b3e77b53-8a72-4875-8fdc-92c4df994d9e', // UUID do tipo de usuário
            })
            .execute();

        if (insertResponse.error == null) {
      
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro bem-sucedido!')),
          );
          Navigator.pop(context); 
        } else {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao inserir dados: ${insertResponse.error?.message}')),
          );
        }
      } else {
       
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar usuário: ${response.error?.message}')),
        );
      }
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um nome';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registre-se'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          
                ClipOval(
                  child: Image.asset(
                    'assets/images/mysterious_logo.jpg',
                    width: 100, 
                    height: 100, 
                    fit: BoxFit.cover, 
                  ),
                ),
                const SizedBox(height: 20),
                
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),        
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}