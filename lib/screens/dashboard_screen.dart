import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reaction_lab/res/custom_colors.dart';

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
        title: Text("Reaca"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 26.0),
                child: Container(
                    color: CustomColors.yellow,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text("Problems solved :"),
                        ),
                        Text("Accuracy :"),
                        SizedBox(
                          height: 23.0,
                        ),
                      ],
                    )),
              ),
              Text(
                "Click to enter Reaction Lab",
              ),
              SizedBox(
                height: 23.0,
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
              SizedBox(
                height: 23.0,
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
        ),
      ),
    );
  }
}
