import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_project/screens/viewnotes.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

import '../screens/addnotes.dart';
import '../widgets/mainDrawer.dart';

class NotesTitle extends StatefulWidget {
  static const routeName = 'NotesTile';
  @override
  _NotesTitleState createState() => _NotesTitleState();
}

class _NotesTitleState extends State<NotesTitle> {
  List myColor = [
    // Colors.yellow[200],
    // Colors.red[200],
    // Colors.deepPurple[200],
    // Colors.green[200],
    HexColor('#00B050'),
    HexColor('#009999'),
    HexColor('#002060'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNotes(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddNotes.routeName);
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => AddNotes(),
              //   ),
              // );
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Notes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> notesSnapshot) {
          if (notesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final noteDetail = notesSnapshot.data?.docs;

          return ListView.builder(
            itemCount: noteDetail!.length,
            itemBuilder: (ctx, index) {
              Random random = new Random();
              Color bg = myColor[random.nextInt(3)];
              DateTime myDateTime = noteDetail[index]['created'].toDate();
              final String formatedTime =
                  DateFormat.yMMMEd().format(myDateTime);
              var data = {
                'title': noteDetail[index]['title'],
                'description': noteDetail[index]['description']
              };
              final User user = FirebaseAuth.instance.currentUser!;
              final uid = user.uid;
              return uid == noteDetail[index]['userId']
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewNotes(
                              data,
                              noteDetail[index].reference,
                              formatedTime,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        color: bg,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${noteDetail[index]['title']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  formatedTime,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    );
            },
          );
        },
      ),
    );
  }
}
