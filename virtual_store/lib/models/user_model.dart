import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  bool isLoading = false;
  Map<String, dynamic> userData = Map();

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  Future signin(Map<String, dynamic> userData, VoidCallback onsuccess,
      VoidCallback onerror) async {
    isLoading = true;
    notifyListeners();

    try {
      final authUser = await _auth.signInWithEmailAndPassword(
          email: userData['email'], password: userData['password']);

      firebaseUser = authUser.user;

      await loadUser();
      onsuccess();

      isLoading = false;
      notifyListeners();
    } catch (error) {
      onerror();
      isLoading = false;
      notifyListeners();
    }
  }

  void signup(Map<String, dynamic> userData, String password,
      VoidCallback onsuccess, VoidCallback onerror) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
      email: userData['email'],
      password: password,
    )
        .then(
      (user) {
        firebaseUser = user.user;
        _saveUser(userData);
        onsuccess();

        isLoading = false;
        notifyListeners();
      },
    ).catchError(
      (error) {
        onerror();

        isLoading = false;
        notifyListeners();
      },
    );
  }

  void signout() async {
    await _auth.signOut();

    firebaseUser = null;
    userData = Map();
    notifyListeners();
  }

  bool isLoggedIn() => firebaseUser != null;

  Future loadUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();

    if (firebaseUser != null &&
        (userData.isEmpty || userData.isEmpty == null)) {
      final docUser = await Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .get();

      userData = docUser.data;
    }

    notifyListeners();
  }

  void resetEmail(String email) => _auth.sendPasswordResetEmail(email: email);

  Future _saveUser(Map<String, dynamic> userData) async {
    userData = userData;
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData(userData);
  }
}
