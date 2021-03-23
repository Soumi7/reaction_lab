import 'package:flutter/material.dart';
import 'package:reaction_lab/res/custom_colors.dart';
import 'dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NameScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text("Reaca"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                hintText: 'Username',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))
                  ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                ),
              )
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(padding: const EdgeInsets.all(3.0),
              child: Container(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DashboardScreen())
                    );
                  },
                  child: Text("Go to Dashboard"),),
              ),
              )
            ],
          ),
        ),),
    );
  }
}
