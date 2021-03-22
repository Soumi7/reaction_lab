import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:reaction_lab/res/strings.dart';
import 'package:reaction_lab/utils/database.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Create room'),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Database.retrieveRoomData(difficulty: Difficulty.easy),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    Map<String, dynamic> roomData =
                        snapshot.data!.docs[index].data()!;

                    String id = roomData['id'];
                    String type = roomData['type'];
                    String difficulty = roomData['difficulty'];

                    return Card(
                      child: Row(
                        children: [
                          Text(id),
                          Text(type),
                          Text(difficulty),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('JOIN'),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 8.0,
                  ),
                  itemCount: snapshot.data!.docs.length,
                );
              }

              return Container();
            },
          )
        ],
      ),
    );
  }
}
