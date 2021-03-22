import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reaction_lab/utils/database.dart';

class DebugScreen extends StatefulWidget {
  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reaca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tap the button below to upload the problem data to Firestore',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            FutureBuilder(
                future: Firebase.initializeApp(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _isUploading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isUploading = true;
                              });
                              await Database.uploadProblemData();
                              setState(() {
                                _isUploading = false;
                              });
                            },
                            child: Text('Upload data'),
                          );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}
