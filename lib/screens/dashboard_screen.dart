import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final User user;

  // named constructors are defined inside { }, otherwise
  // can also be defined without them (But named easy to use).
  const DashboardScreen({required this.user});

  /// TODO: Define the following inside a column:
  /// * an Info area showing player stats
  /// * then two buttons leading to:
  ///   * PraticeGameScreen and,
  ///   * MultiplayerScreen
  ///
  /// TIPS: you can define widgets as spearate files to keep
  /// the code clean, like I have done inside `widgets --> login_screeen` folder
  /// defined a file called `google_sign_in_button.dart`.
  ///
  /// `widgets` then the folder inside it is the `name of the screen` file.
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryAccent,
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: 
      
      Column( crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.center,
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
            child: Text('Practise Lab'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder : (context) => MultiplayerScreen()
              //   ),
              // );
            },
            child: Text('Enter Reaction Lab'),
          ),
        ],
      ),
    );
  }
}
