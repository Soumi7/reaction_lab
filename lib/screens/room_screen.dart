import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'package:reaction_lab/res/custom_colors.dart';
import 'package:reaction_lab/res/strings.dart';
import 'package:reaction_lab/screens/finding_players_screen.dart';
import 'package:reaction_lab/screens/waiting_for_question_screen.dart';
import 'package:reaction_lab/utils/database.dart';

class RoomScreen extends StatefulWidget {
  final String userName;
  final int token;

  const RoomScreen({
    Key? key,
    required this.userName,
    required this.token,
  }) : super(key: key);
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  bool _isCreatingRoom = false;
  bool _isJoinningRoom = false;

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
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }

    return WillPopScope(
      onWillPop: () async {
        // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        // await SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.portraitUp,
        //   DeviceOrientation.portraitDown,
        // ]);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'Rooms',
                        style: TextStyle(
                          fontSize: 32.0,
                          color: CustomColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      _isCreatingRoom
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.primaryDark,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () async {
                                setState(() {
                                  _isCreatingRoom = true;
                                });
                                String? roomId = await Database.createNewRoom(
                                  difficulty: Difficulty.easy,
                                  userName: widget.userName,
                                );
                                setState(() {
                                  _isCreatingRoom = false;
                                });

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FindingPlayersScreen(
                                      difficulty: Difficulty.easy,
                                      roomId: roomId!,
                                      userName: widget.userName,
                                      token: widget.token,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CustomColors.orangeDark,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Create room',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream:
                      Database.retrieveRoomData(difficulty: Difficulty.easy),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> roomData =
                                snapshot.data!.docs[index].data()!;

                            String id = roomData['id'];
                            String type = roomData['type'];
                            String difficulty = roomData['difficulty'];

                            return Card(
                              color: CustomColors.primaryAccent,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            id,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: CustomColors.primaryDark,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            type,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: CustomColors.primaryDark,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            difficulty,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: CustomColors.primaryDark,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _isJoinningRoom
                                        ? CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              CustomColors.primaryDark,
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                _isJoinningRoom = true;
                                              });
                                              await Database.joinRoom(
                                                difficulty: Difficulty.easy,
                                                roomDocumentId: id,
                                                userName: widget.userName,
                                              );
                                              setState(() {
                                                _isJoinningRoom = false;
                                              });
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WaitingForQuestionScreen(
                                                    roomData: roomData,
                                                    roundNumber: 0,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: CustomColors.primaryDark,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0,
                                                top: 8.0,
                                                bottom: 8.0,
                                              ),
                                              child: Text(
                                                'JOIN',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8.0,
                          ),
                          itemCount: snapshot.data!.docs.length,
                        ),
                      );
                    }

                    return Container();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
