// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//write book
Future createWallet() async {
  // get the user uid
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser;
  final gmail = user.email;

  // Reference the document
  final docBook = FirebaseFirestore.instance.collection('wallets').doc(gmail);

  final wallet = Amount(amount: '0');

  final json = wallet.toJson();

  await docBook.set(json);
}

class Amount {
  String amount;

  Amount({
    required this.amount,
  });

  // to JSON
  Map<String, dynamic> toJson() => {
        'balance': amount,
      };

  // from json
  static Amount fromJson(Map<String, dynamic> json) =>
      Amount(amount: json['title']);
}
