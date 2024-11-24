import 'package:app/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:app/services/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:app/pages/home_page.dart';
import 'package:pocketbase/pocketbase.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  final PocketBase pb = GetIt.instance<PocketBase>();
  final AuthService authService = GetIt.instance<AuthService>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage = "";

  void _tryRefreshAuth() {
    authService.authFromToken().then((result) {
      if (result.isFailure) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'LiveJam',),
        ),
      );
    });
  }

  void _login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    final AuthResult result = await authService.authWithPassword(email, password);
    if (result.isFailure)
    {
      setState(() {
        errorMessage = "Login failed: ${result.data}";
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'LiveJam',),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _tryRefreshAuth();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _login,
                    icon: const Icon(Icons.login),
                    label: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    ),
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