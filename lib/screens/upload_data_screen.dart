import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:reaction_lab/res/custom_colors.dart';
import 'package:reaction_lab/res/strings.dart';
import 'package:reaction_lab/screens/game_screen.dart';
import 'package:reaction_lab/screens/waiting_for_next_question_screen.dart';
import 'package:reaction_lab/utils/database.dart';

class UploadDataScreen extends StatefulWidget {
  final Map<String, dynamic> roomData;
  final int roundScore;

  const UploadDataScreen({
    Key? key,
    required this.roomData,
    required this.roundScore,
  }) : super(key: key);

  @override
  _UploadDataScreenState createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
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

    Database.uploadScore(
      score: widget.roundScore,
      difficulty: Difficulty.easy,
      roomDocumentId: roomId,
    ).whenComplete(
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WaitingForNextQuestionScreen(
            roomData: widget.roomData,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (!kIsWeb) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Waiting for data to get uploaded',
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
      ),
    );
  }
}
