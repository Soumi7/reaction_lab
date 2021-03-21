import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reaction_lab/res/strings.dart';

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

  static uploadProblemData() async {
    _problemMap.forEach((level, levelDataList) {
      DocumentReference levelReference = _problemsCollection.doc(level);

      int index = 0;

      levelDataList.forEach((data) async {
        DocumentReference problemReference =
            levelReference.collection('statements').doc('$index');

        Map<String, dynamic> problemInfo = {
          'formula': data.elementAt(0),
          'correct_options': data.elementAt(1),
          'options': data.elementAt(2),
        };

        await problemReference.set(problemInfo).whenComplete(() {
          print('Data added -> $level - $index');
        }).catchError((_) => print('Failed to added -> $level - $index'));

        index++;
      });
    });
  }

  static retrieveUserData() {}

  static scanForAvialablePlayers({required Difficulty difficulty}) {
    String difficultyLevel = difficulty.parseToString();
  }

  static createNewRoom({required Difficulty difficulty}) {}

  static generateProblem({
    required String uid1,
    required String uid2,
  }) {
    // TODO: Generate the random
  }

  // TODO: Retrieve problem statement and the options
  static retrieveProblem({required}) {}

  static checkIfAccountExists() {}
}

/// The person who creates the room, manages the random number generation,
/// and new question selection, checks for if a question is solved
/// and move on to the next.
