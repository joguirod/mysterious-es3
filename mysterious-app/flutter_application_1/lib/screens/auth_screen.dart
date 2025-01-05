import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    try {
      if (_isLogin) {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(_email, _password);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signup(_email, _password);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Email Invalido';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value ?? '',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password tem que ter no máximo 6 caracteres';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value ?? '',
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(_isLogin ? 'Login' : 'Registrar-se'),
                    onPressed: _submit,
                  ),
                  TextButton(
                    child: Text(_isLogin
                        ? 'Criar nova conta'
                        : 'Eu já possuo uma conta.'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                  if (_isLogin)
                    TextButton(
                      child: Text('Esqueceu sua senha?'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/reset-password');
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}