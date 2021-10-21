import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:grocery_project/screens/notestitle.dart';
import '../provider/functions.dart';
import '../screens/home_screen.dart';
import './tokendialog.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Widget buidListTile(String title, IconData iconData, Function taphandler) {
    return ListTile(
        leading: Icon(
          iconData,
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          taphandler();
        });
  }

  @override
  Widget build(BuildContext context) {
    final function = Provider.of<FunctionsCode>(context);
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: const Text(
              'Grocery Reminder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          buidListTile(
            'Home',
            Icons.home,
            () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          buidListTile(
            'Notes',
            Icons.edit,
            () {
              Navigator.of(context).pushReplacementNamed(NotesTitle.routeName);
            },
          ),
          buidListTile(
            'Add user',
            Icons.person_add,
            () {
              showDialog(
                context: context,
                builder: (context) => BuildTokenDialog(),
              );
            },
          ),
          buidListTile(
            'Connect to Family ',
            Icons.connect_without_contact,
            () {
              function.connectDialog(context);
              // showDialog(
              //   context: context,
              //   builder: (context) => BuildTokenDialog(2),
              // );
            },
          ),
          buidListTile(
            'Logout',
            Icons.logout,
            () {
              function.logOut();
            },
          ),
        ],
      ),
    );
  }
}
