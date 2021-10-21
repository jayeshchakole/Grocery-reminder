import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

import '../screens/home_screen.dart';

class BuildTokenDialog extends StatefulWidget {
  @override
  _BuildTokenDialogState createState() => _BuildTokenDialogState();
}

class _BuildTokenDialogState extends State<BuildTokenDialog> {
  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    return SizedBox(
      height: 100,
      width: 150,
      child: AlertDialog(
        title: Text('Token Id'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text(uid)],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: uid),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copy to Clipboard'),
                ),
              );
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.copy),
          ),
          IconButton(
            onPressed: () {
              Share.share(uid);
            },
            icon: Icon(Icons.share),
          )
        ],
      ),
    );
  }
}
