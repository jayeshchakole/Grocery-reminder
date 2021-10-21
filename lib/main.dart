import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grocery_project/screens/addnotes.dart';
import 'package:grocery_project/screens/notestitle.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import './provider/functions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => FunctionsCode(),
        )
      ],
      child: MaterialApp(
          title: 'Grocery Reminder',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            backgroundColor: Colors.teal,
            accentColor: Colors.greenAccent,
            textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white)),
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.tealAccent,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          home:  StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, usersnapShot) {
              if (usersnapShot.hasData) {
                return HomeScreen();
              }
              return AuthScreen();
            },
          ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            NotesTitle.routeName: (ctx) => NotesTitle(),
            AddNotes.routeName : (ctx) => AddNotes(),
            //EditProducts.routeName : (ctx) => EditProducts(),
          }),
    );
  }
}
