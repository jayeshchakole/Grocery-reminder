import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNotes extends StatefulWidget {
  static const routeName = 'Addnotes';
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  String title = '';
  String des = '';

  void add() {
    final user = FirebaseAuth.instance.currentUser;
    var data = {
      'title': title,
      'description': des,
      'created': DateTime.now(),
      'userId': user!.uid,
    };
    FirebaseFirestore.instance.collection('Notes').add(data);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/image/addnote.jpeg'),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(13),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: add,
                        child: Text(
                          'Save',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration:
                              InputDecoration.collapsed(hintText: 'Title'),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (value) {
                            title = value;
                          },
                        ),
                        Divider(
                          color: Colors.black,
                          height: 8,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.70,
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              // maxLines: 10,
                              // keyboardType: TextInputType.multiline,
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Note Description'),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              maxLines: 20,
                              onChanged: (value) {
                                des = value;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
