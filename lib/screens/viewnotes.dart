import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ViewNotes extends StatefulWidget {
  final Map data;
  final String time;
  final DocumentReference ref;

  ViewNotes(this.data, this.ref, this.time);
  @override
  _ViewNotesState createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  String title = '';
  String des = '';
  bool isEdit = false;
  String initTitle = '';
  String initDes = '';

  void delete() {
    widget.ref.delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('lib/assets/image/addnote.jpeg'),
            fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Double Tap To Edit',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            onDoubleTap: () {
              setState(() {
                isEdit = true;
                initTitle = widget.data['title'];
                initDes = widget.data['description'];
              });
            },
            child: SafeArea(
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
                              setState(() {
                                isEdit = false;
                              });
                            },
                            child: Icon(
                              Icons.arrow_back,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: delete,
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isEdit
                                ? TextFormField(
                                    initialValue: initTitle,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onChanged: (value) {
                                      title = value;
                                    },
                                  )
                                : Text(
                                    widget.data['title'],
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                            Divider(
                              color: Colors.black,
                              height: 8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: isEdit
                                  ? TextFormField(
                                      initialValue: initDes,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      onChanged: (value) {
                                        des = value;
                                      },
                                    )
                                  : Text(
                                      widget.data['description'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
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
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: isEdit ? Icon(Icons.save) : Icon(Icons.save_outlined),
          onPressed: isEdit
              ? () {
                  edit();
                  Navigator.of(context).pop();
                }
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'You are not in Edit mode, Double Tap to Edit',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
        ),
      ),
    );
  }

  void edit() {
    var data = {
      'title': title,
      'description': des,
      'created': DateTime.now(),
    };
    widget.ref.update(data);
  }
}
