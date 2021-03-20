import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      appBar: AppBar(
        title: Text('Flutter hello'),
      ),
      body: Padding(  
            padding: EdgeInsets.all(40),  
            child : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
          ),
          SizedBox(
            width: 100.0,
            height: 30.0,
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
      )
    );
  }
}
