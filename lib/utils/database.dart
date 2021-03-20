import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reaction_lab/res/strings.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class Database {
  static String? userUid;

  static uploadUserData() {}

  static uploadProblemData() {}

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
/// and new question selection, checks for
