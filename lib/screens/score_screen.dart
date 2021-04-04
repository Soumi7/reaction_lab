import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'package:reaction_lab/res/custom_colors.dart';
import 'package:reaction_lab/res/strings.dart';
import 'package:reaction_lab/screens/dashboard_screen.dart';
import 'package:reaction_lab/screens/waiting_for_question_screen.dart';
import 'package:reaction_lab/utils/database.dart';

class ScoreScreen extends StatefulWidget {
  final Difficulty difficulty;
  final String roomId;

  const ScoreScreen({
    Key? key,
    required this.difficulty,
    required this.roomId,
  }) : super(key: key);
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score board',
                    style: TextStyle(
                      fontSize: 32.0,
                      color: CustomColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Room id: ${widget.roomId}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: CustomColors.primaryDark.withOpacity(0.2),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: Database.retrieveSingleRoomData(
                roomId: widget.roomId,
                difficulty: widget.difficulty,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> roomData = snapshot.data!.data()!;
                  String uid1 = roomData['uid1'];
                  String uid2 = roomData['uid2'];

                  String username1 = roomData['username1'];
                  String username2 = roomData['username2'];

                  int score1 = roomData['score1'];
                  int score2 = roomData['score2'];

                  int winner = 0;

                  if (score1 > score2) {
                    winner = 1;
                  } else if (score1 == score2) {
                    winner = 0;
                  } else {
                    winner = 2;
                  }

                  bool? canGenerateNextQ = roomData['canGenerateNextQ'];

                  // if (canGenerateNextQ != null) {
                  //   if (canGenerateNextQ) {
                  //     WidgetsBinding.instance!.addPostFrameCallback((_) {
                  //       Navigator.of(context).pushReplacement(
                  //         MaterialPageRoute(
                  //           builder: (context) => WaitingForQuestionScreen(
                  //             roomData: roomData,
                  //             roundNumber: 1,
                  //           ),
                  //         ),
                  //       );
                  //     });
                  //   }
                  // }

                  print(uid1);
                  print(uid2);

                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                [1, 0].contains(winner) ? 'Winner' : 'Lost',
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: [1, 0].contains(winner)
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '@$username1',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: CustomColors.orangeLight,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '$score1 t',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: CustomColors.orangeLight,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'vs',
                              style: TextStyle(
                                fontSize: 40.0,
                                color: CustomColors.primaryAccent,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                [2, 0].contains(winner) ? 'Winner' : 'Lost',
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: [2, 0].contains(winner)
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '@$username2',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: CustomColors.orangeLight,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '$score2 t',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: CustomColors.orangeLight,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container();
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Container(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: CustomColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // color: CustomColors.primaryDark,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    );
                  },

                  child: Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(
                        // fontFamily: 'Raleway',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primaryAccent,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
