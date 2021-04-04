import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:reaction_lab/res/custom_colors.dart';
import 'package:reaction_lab/utils/database.dart';
import 'dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NameScreen extends StatefulWidget {
  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  // Database database = Database();

  late TextEditingController textController;
  late FocusNode textFocusNode;
  bool _isEditing = false;
  bool _isStoring = false;

  String? _validateString(String value) {
    value = value.trim();

    if (textController.text != null) {
      if (value.isEmpty) {
        return 'Name can\'t be empty';
      }
    }

    return null;
  }

  @override
  void initState() {
    textController = TextEditingController();
    textFocusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }

    return GestureDetector(
      onTap: () {
        textFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Reaca',
            style: TextStyle(
              color: CustomColors.primaryDark,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              children: [
                Row(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        focusNode: textFocusNode,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          color: CustomColors.primaryDark,
                          fontSize: 25,
                          letterSpacing: 1.5,
                        ),
                        controller: textController,
                        cursorColor: CustomColors.primaryDark.withOpacity(0.5),
                        autofocus: false,
                        onChanged: (value) {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.primaryDark,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.orangeDark.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: CustomColors.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(
                            color: CustomColors.primaryAccent.withOpacity(0.6),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          errorText: _isEditing
                              ? _validateString(textController.text)
                              : null,
                          errorStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _isStoring
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            CustomColors.primaryDark,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                            onPressed: textController.text.isNotEmpty
                                ? () async {
                                    textFocusNode.unfocus();
                                    setState(() {
                                      _isStoring = true;
                                    });

                                    await Database.uploadUserData(
                                            userName: textController.text)
                                        .whenComplete(() {
                                      // setState(() {
                                      //   _isStoring = false;
                                      // });
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DashboardScreen(),
                                        ),
                                      );
                                    }).catchError(
                                      (e) => print('Error in storing data: $e'),
                                    );

                                    // await database
                                    //     .storeUserData(
                                    //         userName: textController.text)
                                    //     .whenComplete(() =>
                                    //         Navigator.of(context)
                                    //             .pushReplacement(
                                    //           MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 PresencePage(
                                    //               userName: textController.text,
                                    //             ),
                                    //           ),
                                    //         ))
                                    //     .catchError(
                                    //       (e) => print(
                                    //           'Error in storing data: $e'),
                                    //     );
                                  }
                                : null,

                            child: Padding(
                              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                              child: Text(
                                'CONTINUE',
                                style: TextStyle(
                                  // fontFamily: 'Raleway',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textController.text.isNotEmpty
                                      ? CustomColors.primaryAccent
                                      : Colors.white24,
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
        ),
      ),
    );
  }
}
