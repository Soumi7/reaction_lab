import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:reaction_lab/res/custom_colors.dart';
import 'package:reaction_lab/res/strings.dart';
import 'package:reaction_lab/screens/upload_data_screen.dart';
import 'package:reaction_lab/screens/waiting_for_next_question_screen.dart';
import 'package:reaction_lab/screens/waiting_for_question_screen.dart';
import 'package:reaction_lab/utils/database.dart';

class GameScreen extends StatefulWidget {
  final String roomId;
  final Map<String, dynamic> roomData;

  const GameScreen({
    Key? key,
    required this.roomId,
    required this.roomData,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // List<int> correctOptions = [2, 3, 2];
  // List<int> optionChoices = [2, 5, 4, 3, 6, 2, 1, 2, 4];
  // String formula = '#Fe + #Cl2 -> #FeCl3';
  // String solvedFormula = '2Fe + 3Cl2 -> 2FeCl3';

  bool setOnce = false;
  String mySelection = '';

  late Map<int, bool> scoreMap = {};

  double blockHeight = 60;

  List<Widget> formulaWidget = [];

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

    // for (var i = 0; i < formula.length; i++) {
    //   mySelection.add(0);
    // }

    // mySelection = formula;

    // correctOptions.forEach((element) {
    //   scoreMap[element] = false;
    //   mySelection.add(0);
    // });
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

    double width = MediaQuery.of(context).size.width;

    // if (mySelection == solvedFormula) {
    //   print('true');
    // }

    return Scaffold(
      backgroundColor: CustomColors.primaryAccent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: CustomColors.primaryDark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'You 1 - 2 Other',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
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
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'Time remaining: ',
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
            ),
            // Expanded(
            //   child: Column(
            //     children: [
            //       Expanded(
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: formulaWidget,
            //         ),
            //       ),
            //       Column(
            //         children: [
            //           Container(
            //             // height: 60,
            //             width: double.maxFinite,
            //             // color: Colors.transparent,
            //             color: CustomColors.orangeLight,
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: [
            //                 for (int i = 4; i < 7; i++) draggableList[i],
            //               ],
            //             ),
            //           ),
            //           Container(
            //             // height: 60,
            //             width: double.maxFinite,
            //             color: CustomColors.orangeDark,
            //             child: Padding(
            //               padding: const EdgeInsets.only(bottom: 16.0),
            //               child: Row(
            //                 mainAxisAlignment:
            //                     MainAxisAlignment.spaceAround,
            //                 children: [
            //                   for (int i = 0; i < 4; i++) draggableList[i],
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            FutureBuilder<Map<String, dynamic>>(
              future: Database.retrieveProblem(
                difficulty: Difficulty.easy,
                roomDocumentId: widget.roomId,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data!;
                  // List<dynamic> correctOptions = data['correct_options'];

                  List<dynamic> optionChoices = data['options'];
                  String formula = data['formula'];
                  String solvedFormula = data['solvedFormula'];

                  print('$mySelection');

                  if (!setOnce) {
                    mySelection = formula;
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      setState(() {
                        setOnce = true;
                      });
                    });
                  }

                  double sizeOfEachBlock = width / (formula.length);

                  if (!mySelection.contains('#')) {
                    // int roundScore = 0;
                    // if (mySelection == solvedFormula) {
                    //   roundScore = 10;
                    // }

                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => UploadDataScreen(
                          correctEq: solvedFormula,
                          yourEq: mySelection,
                          roomData: widget.roomData,
                          roundScore: mySelection == solvedFormula ? 10 : 0,
                        ),
                      ));
                    });
                  }

                  formulaWidget = [];

                  for (int i = 0; i < formula.length; i++) {
                    Widget newWidget;

                    if (formula[i] == '#') {
                      newWidget = DragTarget<int>(
                        builder: (context, candidateData, rejectedData) {
                          return mySelection[i] != '#'
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    height: sizeOfEachBlock * 1.5,
                                    width: sizeOfEachBlock * 1.5,
                                    color: Colors.black12,
                                    child: Center(
                                      child: Text(
                                        mySelection[i].toString(),
                                        style: TextStyle(
                                          color: CustomColors.primaryDark,
                                          fontSize: sizeOfEachBlock,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    height: sizeOfEachBlock * 1.5,
                                    width: sizeOfEachBlock * 1.5,
                                    color: Colors.black12,
                                  ),
                                );
                        },
                        onWillAccept: (data) => true,
                        onLeave: (data) => false,
                        onAccept: (data) {
                          setState(() {
                            mySelection = mySelection.substring(0, i) +
                                data.toString() +
                                mySelection.substring(i + 1);
                          });
                        },
                      );
                    } else if (formula[i] == ' ') {
                      newWidget = SizedBox(
                        width: sizeOfEachBlock,
                      );
                    } else {
                      newWidget = Text(
                        formula[i],
                        style: TextStyle(
                          color: CustomColors.primaryDark,
                          fontSize: sizeOfEachBlock,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    formulaWidget.add(newWidget);
                  }

                  List<Widget> draggableList = [];

                  for (int i = 0; i < optionChoices.length; i++) {
                    Widget draggableWidget = Container();

                    if (optionChoices[i] == 0) {
                      Container();
                    } else {
                      Widget textWidgetDraggable = Text(
                        optionChoices[i].toString(),
                        style: TextStyle(
                          color: CustomColors.primaryDark,
                          fontSize: sizeOfEachBlock * 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      );

                      Widget textWidgetFeedback = Material(
                        color: Colors.transparent,
                        child: Text(
                          optionChoices[i].toString(),
                          style: TextStyle(
                            color: CustomColors.primaryDark,
                            fontSize: sizeOfEachBlock * 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );

                      draggableWidget = Draggable<int>(
                        data: optionChoices[i],
                        child: textWidgetDraggable,
                        feedback: textWidgetFeedback,
                        // feedbackOffset: Offset(0, 100),
                        childWhenDragging: Container(),
                        onDragEnd: (details) {
                          if (details.wasAccepted) {
                            optionChoices[i] = 0;
                          }
                        },
                      );
                    }

                    draggableList.add(draggableWidget);
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: formulaWidget,
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              // height: 60,
                              width: double.maxFinite,
                              // color: Colors.transparent,
                              color: CustomColors.orangeLight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (int i = 4; i < 7; i++) draggableList[i],
                                ],
                              ),
                            ),
                            Container(
                              // height: 60,
                              width: double.maxFinite,
                              color: CustomColors.orangeDark,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    for (int i = 0; i < 4; i++)
                                      draggableList[i],
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.maxFinite,
                              color: CustomColors.orangeDark,
                              child: Center(
                                child: Text(
                                  'Room id: ${widget.roomId}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: CustomColors.primaryDark
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.primaryDark,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   body: Center(
    //     child: Text('Game screen'),
    //   ),
    // );
  }
}
