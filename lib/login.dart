import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'menu.dart'; // Import your existing files as needed
import 'registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() {
      _loading = true;
    });

    final response = await http.post(
      Uri.parse('https://ayashibbi-dailydrip.000webhostapp.com/login.php'), // Replace with your API URL
      body: {
        'Username': _usernameController.text,
        'Password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Menu()),
        );
      } else {
        print("COULDNT LOADDDD");
      }
    } else {
      // Handle error in response
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Registration()),
                );
              },
              child: const Text('Register Here'),
            ),
          ],
        ),
      ),
    );
  }
}

