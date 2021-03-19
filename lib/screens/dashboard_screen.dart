import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi!"),
      ),
      body: Row(
        children: [Text("HIII")],
      ),
    );
  }
}
