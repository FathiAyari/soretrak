import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../models/Users.dart';

class AuthServices {
  var storage = GetStorage();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var userCollection = FirebaseFirestore.instance.collection('users');

  Future<bool> signIn(String emailController, String passwordController) async {
    try {
      await auth.signInWithEmailAndPassword(email: emailController, password: passwordController);

      return true;
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> signUp(Cusers user) async {
    try {
      await auth.createUserWithEmailAndPassword(email: user.email, password: user.password!);

      await saveUser(user);

      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> resetPassword(String emailController) async {
    try {
      await auth.sendPasswordResetEmail(email: emailController);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  Future<Cusers> getUserData() async {
    var userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    return Cusers.fromJson(userData.data()!);
  }

  User? get user => auth.currentUser; //pour recuperer l'utilisateur courant

  saveUser(Cusers cuser) async {
    try {
      await userCollection.doc(user!.uid).set(cuser.Tojson(user!.uid));
    } catch (e) {}
  }

  saveUserLocally(Cusers user) {
    storage.write("role", user.role);

    storage.write("user", {
      'uid': user.uid,
      'name': user.name,
      'last_name': user.last_name,
      'email': user.email,
      'role': user.role,
    });
  }

  logOut(BuildContext context) {
    storage.remove('role');
    storage.remove('user');
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  Future<String> changeEmail(String email, String password) async {
    var userFromStorage = GetStorage().read('user');
    try {
      await auth.signInWithEmailAndPassword(email: userFromStorage['email'], password: password);
      await user!.updateEmail(email);
      await userCollection.doc(userFromStorage['uid']).update({'email': email});

      userFromStorage['email'] = email;
      await GetStorage().write('user', userFromStorage);
      return 'done';
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'email-already-in-use') {
        return "Email deja utilisé";
      } else {
        return "Mot de passe incorrecte";
      }
    }
  }

  Future<bool> changePassword(String password, String newPassword) async {
    var userFromStorage = GetStorage().read('user');

    try {
      await auth.signInWithEmailAndPassword(email: userFromStorage['email'], password: password);
      await user!.updatePassword(newPassword);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
