import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reaction_lab/res/strings.dart';
import 'dart:math';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _usersCollection = _firestore.collection('users');
final CollectionReference _problemsCollection =
    _firestore.collection('problems');
final CollectionReference _roomsCollection = _firestore.collection('rooms');

class Database {
  static late User user;

  static List<String> _levels = [
    'easy',
    'medium',
    'hard',
  ];

  static Map<String, List<Set<dynamic>>> _problemMap = {
    'easy': [
      {
        '#Fe + #Cl2 -> #FeCl3',
        [2, 3, 2],
        [2, 5, 4, 3, 6, 2, 1, 2, 4],
      },
      {
        '#Fe + #O2 -> #Fe2O3',
        [4, 3, 2],
        [1, 7, 4, 4, 6, 1, 1, 2, 3],
      },
      {
        '#Al + #O2 -> #Al2O3',
        [4, 3, 2],
        [3, 5, 4, 3, 6, 2, 5, 2, 1],
      },
    ],
  };

  static uploadUserData({required String userName}) async {
    DocumentReference documentReferencer = _usersCollection.doc(user.uid);

    Map<String, dynamic> userData = <String, dynamic>{
      "uid": user.uid,
      "imageUrl": user.photoURL,
      "userName": userName,
      "email": user.email,
      "token": 0,
      "solved": 0,
      "accuracy": 0.0,
    };
    print('USER DATA:\n$userData');

    await documentReferencer.set(userData).whenComplete(() {
      print('User data stored successfully!');
    }).catchError((e) => print(e));
  }

  static Future<void> uploadProblemData() async {
    _problemMap.forEach((level, levelDataList) {
      int index = -1;

      levelDataList.forEach((data) async {
        index++;
        DocumentReference problemReference = _problemsCollection
            .doc(level)
            .collection('statements')
            .doc('$index');

        Map<String, dynamic> problemInfo = {
          'formula': data.elementAt(0),
          'correct_options': data.elementAt(1),
          'options': data.elementAt(2),
        };

        await problemReference.set(problemInfo).whenComplete(() {
          print('Data added -> $level - $index');
        }).catchError((_) => print('Failed to added -> $level - $index'));
      });
    });
  }

  static retrieveUserData() {}

  static scanForAvialablePlayers({required Difficulty difficulty}) {
    String difficultyLevel = difficulty.parseToString();
  }

  static Future<String?> createNewRoom({required Difficulty difficulty}) async {
    String? roomId;
    DocumentReference documentReference = _roomsCollection
        .doc(difficulty.parseToString())
        .collection('breakouts')
        .doc();

    int currentDateTimeEpoch = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> roomInfo = {
      'id': documentReference.id,
      'epoch': currentDateTimeEpoch,
      'type': '2 players',
      'difficulty': difficulty.parseToString(),
      'canGenerateNextQ': false,
      'uid1': user.uid,
      'username1': user.displayName,
      'score1': 0,
      'isSolved1': false,
      'isAvailable': true,
    };

    await documentReference.set(roomInfo).whenComplete(() {
      print('Created a new room, ID: ${documentReference.id}');
      roomId = documentReference.id;
    }).catchError((e) => print(e));

    return roomId;
  }

  static Stream<QuerySnapshot> retrieveRoomData({
    required Difficulty difficulty,
  }) {
    Stream<QuerySnapshot> roomsQuery = _roomsCollection
        .doc(difficulty.parseToString())
        .collection('breakouts')
        .where('isAvailable', isEqualTo: true)
        .snapshots();

    return roomsQuery;
  }

  static Stream<DocumentSnapshot> retrieveSingleRoomData({
    required Difficulty difficulty,
    required String roomId,
  }) {
    Stream<DocumentSnapshot> singleRoomSnapshot = _roomsCollection
        .doc(difficulty.parseToString())
        .collection('breakouts')
        .doc(roomId)
        .snapshots();

    return singleRoomSnapshot;
  }

  static joinRoom({
    required Difficulty difficulty,
    required String roomDocumentId,
  }) {
    DocumentReference documentReference = _roomsCollection
        .doc(difficulty.parseToString())
        .collection('breakouts')
        .doc(roomDocumentId);

    Map<String, dynamic> secondUserInfo = {
      'canGenerateNextQ': true,
      'uid2': user.uid,
      'username2': user.displayName,
      'score2': 0,
      'isSolved2': false,
      'isAvailable': false,
    };

    documentReference.update(secondUserInfo).whenComplete(() {
      print('Room joining successful, ID: ${documentReference.id}');
    }).catchError((e) => print(e));
  }

  static generateProblem({
    // required String uid1,
    // required String uid2,
    required Difficulty difficulty,
    required String roomDocumentId,
    required String questionIndex,
  }) async {
    DocumentSnapshot roomSnapshot = await _roomsCollection
        .doc(difficulty.parseToString())
        .collection('breakouts')
        .doc(roomDocumentId)
        .get();

    Map<String, dynamic> roomData = roomSnapshot.data()!;

    bool canGenerateNextQ = roomData['canGenerateNextQ'];
    String roomCreatorUid = roomData['uid1'];

    if (canGenerateNextQ && roomCreatorUid == user.uid) {
      QuerySnapshot statementsSnapshot = await _problemsCollection
          .doc(difficulty.parseToString())
          .collection('statements')
          .get();

      int totalNumberOfProblems = statementsSnapshot.docs.length;

      Random random = Random();
      int randomNumber = random.nextInt(totalNumberOfProblems);

      // Map<String, dynamic> statementData =
      //     statementsSnapshot.docs.elementAt(randomNumber).data()!;

      // String formula = statementData['formula'];
      // List<int> correctOptions = statementData['correct_options'];
      // List<int> options = statementData['options'];

      DocumentReference roomReference = _roomsCollection
          .doc(difficulty.parseToString())
          .collection('breakouts')
          .doc(roomDocumentId);

      Map<String, dynamic> questionNumberData = {
        'question_number': randomNumber
      };

      await roomReference.update(questionNumberData).whenComplete(() {
        print('Updated question number to: $randomNumber');
      }).catchError((e) => print(e));
    }
  }

  static Future<Map<String, dynamic>> retrieveProblem({
    required Difficulty difficulty,
    required String roomDocumentId,
    required String questionIndex,
  }) async {
    DocumentSnapshot roomSnapshot = await _roomsCollection
        .doc(difficulty.parseToString())
        .collection('breakouts')
        .doc(roomDocumentId)
        .get();

    int questionNumber = roomSnapshot.data()!['question_number'];

    DocumentSnapshot statementSnapshot = await _problemsCollection
        .doc(difficulty.parseToString())
        .collection('statements')
        .doc('$questionNumber')
        .get();

    Map<String, dynamic> statementData = statementSnapshot.data()!;

    // String formula = statementData['formula'];
    // List<int> correctOptions = statementData['correct_options'];
    // List<int> options = statementData['options'];

    return statementData;
  }

  static checkIfAccountExists() {}
}

/// The person who creates the room, manages the random number generation,
/// and new question selection, checks for if a question is solved
/// and move on to the next.
