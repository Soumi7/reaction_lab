import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter hello'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'helloo1',
          ),
          Text(
            'helloo2',
          ),
          TextField(
            controller: _emailController,
          ),
          ElevatedButton(
            onPressed: () {
              print("");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
              );
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
