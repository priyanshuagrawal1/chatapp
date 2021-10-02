import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  bool _isLoading = false;
  Future<void> _submitAuthForm(
      {String? email,
      String? password,
      String? username,
      bool? isLogin,
      File? profile,
      BuildContext? context}) async {
    dynamic authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin!) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email!, password: password!);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(profile!);
        String url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({'username': username, 'email': email, 'imgUrl': url});
      }
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      String message = 'An errr occured ';
      // ignore: unnecessary_null_comparison
      if (error != null) {
        message = error.message!;
      }
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      var message = error.toString();
      if (error.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account. ') {
        message = 'The email address is already in use by another account.';
      }
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitAuthForm: _submitAuthForm,
        isloading: _isLoading,
      ),
    );
  }
}
