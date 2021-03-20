import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Click to enter Reaction Lab",
          ),
          ElevatedButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder : (context) => PraticeGameScreen()
                //   ),
                // );
              },
              child: Text('Practise Lab')),
          ElevatedButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder : (context) => MultiplayerScreen()
                //   ),
                // );
              },
              child: Text('Enter Reaction Lab')),
        ],
      ),
    );
  }
}
