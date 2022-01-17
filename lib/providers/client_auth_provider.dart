// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heke_support/constants/color_constants.dart';
import 'package:heke_support/constants/firestore_constants.dart';
import 'package:heke_support/helper/account_mangemant.dart';
import 'package:heke_support/models/user_chat.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ClientAuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class ClientAuthProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  ClientAuthStatus _status = ClientAuthStatus.uninitialized;
  ClientAuthStatus get status => _status;

  ClientAuthProvider({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });


  final signInValidateKey = GlobalKey<FormState>();
  final signUpValidateKey = GlobalKey<FormState>();




  Future handleSignIn({
    required String password,
    required String userId,
    required String userName,
    required String photoUrl,
    required String userEmail,
    required String userPhone,
    required String userCountryId,
    required String userProveIdNumber,
    required String userType,
    required String chatStatue,
    required BuildContext context,

  }) async {

    _status = ClientAuthStatus.authenticating;
    notifyListeners();

    try {
      await firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: password);
      final QuerySnapshot result = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.userId, isEqualTo: userId).get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        DocumentSnapshot documentSnapshot = documents[0];
        UserChat userChat = UserChat.fromDocument(documentSnapshot);
        print(userChat);
        _status = ClientAuthStatus.authenticated;
        notifyListeners();
      }
    } on FirebaseAuthException catch(e) {
     await handleSignUp(
        context: context,
        userId: userId,
        chatStatue: chatStatue,
        password: password,
        photoUrl:photoUrl ,
        userCountryId: userCountryId,
        userEmail: userEmail,
        userName: userName,
        userPhone: userPhone,
        userProveIdNumber:userProveIdNumber ,
        userType: userType,
      );
      notifyListeners();
      print(e.message);
    }

  }

 Future handleSignUp({
    required String password,
    required String userId,
    required String userName,
    required String photoUrl,
    required String userEmail,
    required String userPhone,
    required String userCountryId,
    required String userProveIdNumber,
    required String userType,
    required String chatStatue,
    required BuildContext context,
  }) async {
    _status = ClientAuthStatus.authenticating;
    notifyListeners();

      try {
        await firebaseAuth.createUserWithEmailAndPassword(email: userEmail, password: password);
        await firebaseAuth.currentUser!.updateProfile(
          displayName: userName,
          photoURL: photoUrl,
        );

        firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(userId).set({
          FirestoreConstants.accountType: 'client',
          FirestoreConstants.userId: userId,
          FirestoreConstants.userName: userName,
          FirestoreConstants.photoUrl: photoUrl,
          FirestoreConstants.userEmail: userEmail,
          FirestoreConstants.userPhone: userPhone,
          FirestoreConstants.userCountryId: userCountryId,
          FirestoreConstants.userProveIdNumber: userProveIdNumber,
          FirestoreConstants.userType: userType,
          FirestoreConstants.chatStatue: chatStatue,
          FirestoreConstants.userStatusBlock: 'allowed',
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.chattingWith: null
        });
        _status = ClientAuthStatus.authenticated;
        notifyListeners();
        return true;
      } on FirebaseAuthException catch(e) {
        Fluttertoast.showToast(msg: e.code.toString(), backgroundColor: ColorConstants.greyColor,timeInSecForIosWeb: 5,webPosition:'center');
        _status = ClientAuthStatus.uninitialized;
        notifyListeners();
        print(e.message);
        return false;
      }

  }

  Future<void> handleSignOut() async {
    _status = ClientAuthStatus.uninitialized;
    await firebaseAuth.signOut();
    notifyListeners();
  }



}
