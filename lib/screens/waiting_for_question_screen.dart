import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:reaction_lab/res/custom_colors.dart';
import 'package:reaction_lab/res/strings.dart';
import 'package:reaction_lab/screens/game_screen.dart';
import 'package:reaction_lab/utils/database.dart';

class WaitingForQuestionScreen extends StatefulWidget {
  final Map<String, dynamic> roomData;

  const WaitingForQuestionScreen({
    Key? key,
    required this.roomData,
  }) : super(key: key);

  @override
  _WaitingForQuestionScreenState createState() =>
      _WaitingForQuestionScreenState();
}

class _WaitingForQuestionScreenState extends State<WaitingForQuestionScreen> {
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

    Future.delayed(
      Duration(seconds: 2),
      () => Database.generateProblem(
        difficulty: Difficulty.easy,
        roomDocumentId: roomId,
        // questionIndex: '0',
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: Database.retrieveSingleRoomData(
          roomId: roomId,
          difficulty: Difficulty.easy,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> roomData = snapshot.data!.data()!;
            int? questionNumber = roomData['question_number'];

            if (questionNumber != null) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      roomId: roomId,
                      roomData: roomData,
                      // questionNumber: 0,
                    ),
                  ),
                );
              });
            }
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
