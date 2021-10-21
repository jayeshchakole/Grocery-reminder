import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grocery_project/widgets/Auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    void _submitAuthForm(
      String email,
      String password,
      String username,
      bool islogin,
      BuildContext ctx,
    ) async {
      UserCredential userCredential;
      try {
        setState(() {
          _isloading = true;
        });
        if (islogin == false ) {
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(
            {
              'email': email,
              'username': username,
              'id': userCredential.user!.uid,
              
            },);
        } else {
           userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          
        }
      } on PlatformException catch (error) {
        var message = 'An error occured, Please check your creidential';
        if (error.message != null) {
          message = error.message!;
        }
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              message,
            ),
          ),
        );
        setState(() {
          _isloading = false;
        });
      } catch (error) {
        print(error);
        setState(() {
          _isloading = false;
        });
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        context,
        _submitAuthForm,
        _isloading,
      ),
    );
  }
}
