import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'package:reaction_lab/res/custom_colors.dart';
import 'package:reaction_lab/res/strings.dart';
import 'package:reaction_lab/screens/waiting_for_question_screen.dart';
import 'package:reaction_lab/utils/database.dart';

class FindingPlayersScreen extends StatefulWidget {
  final Difficulty difficulty;
  final String roomId;
  final String userName;
  final int token;

  const FindingPlayersScreen({
    Key? key,
    required this.difficulty,
    required this.roomId,
    required this.userName,
    required this.token,
  }) : super(key: key);
  @override
  _FindingPlayersScreenState createState() => _FindingPlayersScreenState();
}

class _FindingPlayersScreenState extends State<FindingPlayersScreen> {
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Searching...',
                        style: TextStyle(
                          fontSize: 32.0,
                          color: CustomColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: CustomColors.orangeDark,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Time elapsed: ',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                  String? uid1 = roomData['uid1'];
                  String? uid2 = roomData['uid2'];
                  bool? canGenerateNextQ = roomData['canGenerateNextQ'];

                  if (canGenerateNextQ != null) {
                    if (canGenerateNextQ) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => WaitingForQuestionScreen(
                              roomData: roomData,
                              roundNumber: 1,
                            ),
                          ),
                        );
                      });
                    }
                  }

                  print(uid1);
                  print(uid2);

                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: uid1 != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'You',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        color: CustomColors.primaryDark,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      '@${widget.userName}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: CustomColors.orangeDark,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      '${widget.token} t',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        color: CustomColors.orangeLight,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
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
                          child: uid2 != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'You',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        color: CustomColors.primaryDark,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      '@souvikbiswas',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: CustomColors.orangeDark,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      '103 t',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        color: CustomColors.orangeLight,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Waiting for a player to join',
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
                      ],
                    ),
                  );
                }

                return Container();
              },
            ),
            Container(
              height: 50,
              width: double.maxFinite,
            )
          ],
        ),
      ),
    );
  }
}
