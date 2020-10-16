import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_brownie_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFirestoreAPI {
  final String PACIENTES = "pacientes";
  final String TICKETS = "tickets";
  final String CITAS = "citas";

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(UserModel user) async {
    DocumentReference ref = _db.collection(PACIENTES).doc(user.uid);
    return await ref.set({
      'uid': user.uid,
      'name': user.userName,
      'surname1': user.userSurname1,
      'surname2': user.userSurname2,
      'email': user.email,
      'paid_balance': user.paidBalance,
      'total_balance': user.totalBalance
    });
  }
}
