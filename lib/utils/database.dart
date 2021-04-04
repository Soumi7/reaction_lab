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

  // TODO: Add more problems here
  static Map<String, List<Set<dynamic>>> _problemMap = {
    'easy': [
      {
        '#Fe + #Cl2 -> #FeCl3', // formula
        [2, 3, 2], // correct options
        [2, 5, 4, 3, 6, 2, 1, 2, 4], // options to choose from
        '2Fe + 3Cl2 -> 2FeCl3', // solved formula
      },
      {
        '#Fe + #O2 -> #Fe2O3',
        [4, 3, 2],
        [1, 7, 4, 4, 6, 1, 1, 2, 3],
        '4Fe + 3O2 -> 2Fe2O3',
      },
      {
        '#Al + #O2 -> #Al2O3',
        [4, 3, 2],
        [3, 5, 4, 3, 6, 2, 5, 2, 1],
        '4Al + 3O2 -> 2Al2O3',
      },
      {
        '#N2 + #H2 -> #NH3',
        [1, 3, 2],
        [5, 3, 2, 8, 4, 2, 9, 1, 5],
        '1N2 + 3H2 -> 2NH3',
      },
      {
        '#AgI +  #Na2S -> #Ag2S + #NaI',
        [2,1,1,2],
        [3, 2, 4, 2, 5, 1, 3, 1, 2],
        '2AgI +  1Na2S -> 1Ag2S + 2NaI',
      },
      {
        '#NaBr +  #Cl2 -> #NaCl + #Br2',
        [2,1,2,1],
        [3, 2, 4, 2, 5, 1, 3, 1, 2],
        '2NaBr +  1Cl2 -> 2NaCl + 1Br2',
      },
      {
        '#TiCl4 + #H2O -> #TiO2 + #HCL',
        [1,2,1,4],
        [2, 3, 1, 5, 6, 1, 2, 5, 4],
        '1TiCl4 + 2H2O -> 1TiO2 + 4HCL',
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
          'solvedFormula': data.elementAt(3),
        };

        await problemReference.set(problemInfo).whenComplete(() {
          print('Data added -> $level - $index');
        }).catchError((_) => print('Failed to added -> $level - $index'));
      });
    });
  }

  static Future<Map<String, dynamic>> retrieveUserData() async {
    DocumentReference documentReferencer = _usersCollection.doc(user.uid);
    DocumentSnapshot userSnapshot = await documentReferencer.get();

    return userSnapshot.data()!;
  }

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

  // update isSolves to false
  static generateProblem({
    // required String uid1,
    // required String uid2,
    required Difficulty difficulty,
    required String roomDocumentId,
    // required String questionIndex,
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
        'question_number': randomNumber,
        'canGenerateNextQ': false,
        'isSolved1': false,
        'isSolved2': false,
      };

      await roomReference.update(questionNumberData).whenComplete(() {
        print('Updated question number to: $randomNumber');
      }).catchError((e) => print(e));
    }
  }

  static Future<Map<String, dynamic>> retrieveProblem({
    required Difficulty difficulty,
    required String roomDocumentId,
  }) async {
    DocumentSnapshot roomSnapshot = await _roomsCollection
        .doc(difficulty.parseToString())
        .collection('breakouts')
        .doc(roomDocumentId)
        .get();

    int? questionNumber = roomSnapshot.data()!['question_number'];

    DocumentSnapshot statementSnapshot = await _problemsCollection
        .doc(difficulty.parseToString())
        .collection('statements')
        .doc('${questionNumber ?? 0}')
        .get();

    Map<String, dynamic> statementData = statementSnapshot.data()!;

    // String formula = statementData['formula'];
    // List<int> correctOptions = statementData['correct_options'];
    // List<int> options = statementData['options'];

    return statementData;
  }

  static Future<Map<String, dynamic>> retrieveNextProblem({
    required Difficulty difficulty,
    required String roomDocumentId,
    required String questionNumber,
  }) async {
    DocumentSnapshot statementSnapshot = await _problemsCollection
        .doc(difficulty.parseToString())
        .collection('statements')
        .doc('$questionNumber')
        .get();

    Map<String, dynamic> statementData = statementSnapshot.data()!;

    return statementData;
  }

  // set score, update isSolved to true
  static Future<void> uploadScore({
    required int score,
    required Difficulty difficulty,
    required String roomDocumentId,
  }) async {
    DocumentReference roomReference = _roomsCollection
        .doc(difficulty.parseToString())
        .collection('breakouts')
        .doc(roomDocumentId);

    DocumentSnapshot roomSnapshot = await _roomsCollection
        .doc(difficulty.parseToString())
        .collection('breakouts')
        .doc(roomDocumentId)
        .get();

    Map<String, dynamic> roomData = roomSnapshot.data()!;
    String uid1 = roomData['uid1'];
    String uid2 = roomData['uid2'];

    Map<String, dynamic> solvedData;

    print('current uid: ${user.uid}, uid1: $uid1, uid2: $uid2');

    if (uid1 == user.uid) {
      solvedData = {
        // 'question_number': null,
        'isSolved1': true,
        'canGenerateNextQ': true,
        'score1': score,
      };
    } else {
      solvedData = {
        // 'question_number': null,
        'isSolved2': true,
        'canGenerateNextQ': true,
        'score2': score,
      };
    }

    await roomReference.update(solvedData).whenComplete(() {
      print('Uploaded solved data!');
    }).catchError((e) => print(e));
  }

  static checkIfAccountExists() {}
}

/// The person who creates the room, manages the random number generation,
/// and new question selection, checks for if a question is solved
/// and move on to the next.
