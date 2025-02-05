import 'package:flutter/material.dart';
import 'package:mysterious_app/models/cart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final Cart cart;

  const LoginPage({Key? key, required this.cart}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final response = await Supabase.instance.client.auth.signIn(
        email: email,
        password: password,
      );

      if (response.error != null) {
        if (response.error!.message.contains('Email not confirmed')) {
          // E-mail não confirmado
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, confirme seu e-mail antes de fazer login.')),
          );
        } else {
          // Outro erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: ${response.error!.message}')),
          );
        }
      } else {
        // Verificar se o usuário está autenticado
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          print('Usuário autenticado: ${session.user!.email}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login bem-sucedido!')),
          );
          Navigator.pushReplacementNamed(context, '/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Falha na autenticação')),
          );
        }
      }
    } catch (e) {
      print('Erro ao realizar login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
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
             
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              ValueListenableBuilder<bool>(
                valueListenable: _isPasswordVisible,
                builder: (context, isPasswordVisible, child) {
                  return TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          _isPasswordVisible.value = !isPasswordVisible;
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () {
                
                },
                child: const Text('Esqueceu sua senha?'),
              ),
              const SizedBox(height: 20),
              // Link para "Não tem conta? Registre-se"
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('Não tem conta? Registre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}