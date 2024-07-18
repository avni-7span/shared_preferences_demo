import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  String _userName = '';
  final instance = SharedPreferences.getInstance();

  Future<void> loadData() async {
    final prefInstance = await instance;
    setState(() {
      _rememberMe = prefInstance.getBool('rememberMe') ?? false;
      _userName = prefInstance.getString('userName') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          const Text(
            'Welcome',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.purple),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _userName = value;
                });
              },
              decoration: const InputDecoration(
                  hintText: 'Enter User Name', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
              title: const Text('Remember me'),
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final prefInstance = await instance;
              prefInstance.setBool('rememberMe', _rememberMe);
              prefInstance.setString('userName', _userName);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
