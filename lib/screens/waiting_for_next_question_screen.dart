import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'package:reaction_lab/res/custom_colors.dart';
import 'package:reaction_lab/res/strings.dart';
import 'package:reaction_lab/screens/game_screen.dart';
import 'package:reaction_lab/screens/score_screen.dart';
import 'package:reaction_lab/utils/database.dart';

class WaitingForNextQuestionScreen extends StatefulWidget {
  final Map<String, dynamic> roomData;
  final int score;
  final String correctEq;
  final String yourEq;

  const WaitingForNextQuestionScreen({
    Key? key,
    required this.roomData,
    required this.score,
    required this.correctEq,
    required this.yourEq,
  }) : super(key: key);

  @override
  _WaitingForNextQuestionScreenState createState() =>
      _WaitingForNextQuestionScreenState();
}

class _WaitingForNextQuestionScreenState
    extends State<WaitingForNextQuestionScreen> {
  late String roomId;
  late String difficulty;

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
    roomId = widget.roomData['id'];
    difficulty = widget.roomData['difficulty'];
  }

  @override
  void dispose() {
    super.dispose();
    // if (!kIsWeb) {
    //   SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: Database.retrieveSingleRoomData(
          roomId: roomId,
          difficulty: Difficulty.easy,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> roomData = snapshot.data!.data()!;
            int? questionNumber = roomData['question_number'];

            bool done = roomData['done'];

            bool isSolved1 = roomData['isSolved1'];
            bool isSolved2 = roomData['isSolved2'];

            if (done) {
              //upload score to user
              print('DONE');
              Database.updateUserScore(token: widget.score).whenComplete(
                () => Future.delayed(
                  Duration(seconds: 2),
                  () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ScoreScreen(
                        roomId: roomId,
                        difficulty: Difficulty.easy,
                        // questionNumber: 0,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              if (!done && isSolved1 && isSolved2) {
                Database.generateProblem(
                  difficulty: Difficulty.easy,
                  roomDocumentId: roomId,
                ).whenComplete(
                  () => Future.delayed(
                    Duration(seconds: 5),
                    () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => GameScreen(
                          roomId: roomId,
                          roomData: roomData,
                          // questionNumber: 0,
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.score == 0 ? 'Wrong (+0)' : 'Correct (+10)',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: widget.score == 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Your balancing: ${widget.yourEq}',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: CustomColors.orangeLight,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '( Correct balancing: ${widget.correctEq} )',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: CustomColors.primaryDark.withOpacity(0.6),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  'Waiting for question',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: CustomColors.primaryDark,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 16.0),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    CustomColors.primaryDark,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
