import 'package:flutter/material.dart';

class ConnectFamily extends StatefulWidget {
  Function connectToFamily;
  ConnectFamily(this.connectToFamily);

  @override
  _ConnectFamilyState createState() => _ConnectFamilyState();
}

class _ConnectFamilyState extends State<ConnectFamily> {
  @override
  Widget build(BuildContext context) {
    final _keyController = TextEditingController();
    final _nameController = TextEditingController();

    void _saveKey() {
      final String key = _keyController.text;
      final String name = _nameController.text;
      // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      // FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(key)
      //     .collection('familymember')
      //     .add({
      //   'user1': key,
      // });
      widget.connectToFamily(key, name, context);
    }

    return SizedBox(
      height: 100,
      width: 150,
      child: AlertDialog(
        title: const Text('Enter the Unique key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter the First name'),
              controller: _nameController,
              key: ValueKey('name'),
              onSubmitted: (_) => _saveKey(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Enter the key.'),
              controller: _keyController,
              key: ValueKey('key'),
              onSubmitted: (_) => _saveKey(),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: _saveKey,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
