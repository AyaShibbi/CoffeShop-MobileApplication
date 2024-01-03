import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String _baseURL = 'ayashibbi-dailydrip.000webhostapp.com';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Form(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Username',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Password',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () {
                  setState(() {
                    _loading = true;
                  });
                  registerUser(
                    update,
                    _usernameController.text.toString(),
                    _passwordController.text.toString(),
                  );
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void registerUser(Function(String text) update, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://$_baseURL/register.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'Username': '$username',
          'Password': '$password',
        }),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        update(response.body);
        // After successful registration, navigate back to login
        Navigator.of(context).pop();
      }
    } catch (e) {
      update("Connection error");
    }
  }
}

