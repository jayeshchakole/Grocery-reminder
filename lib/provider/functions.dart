import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_project/widgets/connectFamilydailog.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/editModalSheet.dart';
import '../models/list_item.dart';
import '../widgets/modalsheet.dart';
import '../widgets/slidablewidget.dart';
import '../models/order_item.dart';
import '../screens/home_screen.dart';




class FunctionsCode with ChangeNotifier {
  late String userData;
  final String productId = '';
  List<ItemModal> _items = [];
  List<ItemModal> get item {
    return [..._items];
  }

  List<OrderItem> _orders = [];
  // List<OrderItem> get orders {
  //   return [..._orders];
  // }

  void orderData(String title, String unit, double weight, double quantity) {
    final newTx = OrderItem(
      title: title,
      unit: unit,
      quantity: quantity,
      weight: weight,
    );
    _orders.add(newTx);
  }

  void placeOrder() {
    String text = '';
    String unit = '';
    double quantity = 0.0;
    double weight = 0.0;
    String listOfOrder = '';
    for (int i = 0; i < _orders.length; i++) {
      // text = _orders[i].title;
      // unit = _orders[i].unit;
      // quantity = _orders[i].quantity;
      // weight = _orders[i].weight;
      final no = i + 1;
      listOfOrder += no.toString() +
          '.' +
          _orders[i].title +
          '  ' +
          _orders[i].weight.toString() +
          ' ' +
          _orders[i].unit +
          ', ' +
          'qty :' +
          _orders[i].quantity.toString() +
          'x' +
          '\n';
    }

    Share.share(listOfOrder);
  }

  void submitdata(String title, double amount, double weight, String unit,
      double quantity, DateTime expiryDate, String userKey, bool familyAcc) {
    final finalAmount = amount * quantity;

    // final newtx = ItemModal(
    //   title: title,
    //   amount: finalAmount,
    //   weight: weight,
    //   quantity: quantity,
    //   unit: unit,
    //   expiryDate: expiryDate,
    //   id: productId,
    // );
    // _items.add(newtx);
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('products').add(
      {
        'userId': familyAcc ? userKey : user!.uid,
        'title': title,
        'amount': finalAmount,
        'weight': weight,
        'unit': unit,
        'quantity': quantity,
        'expiryDate': expiryDate,
        'isorder': false,
      },
    );

    notifyListeners();
  }

  void addItem(BuildContext ctx, String userkey, bool familyAcc) {
    showModalBottomSheet(
      elevation: 5,
      context: ctx,
      builder: (_) {
        return ModalSheet(submitdata, userkey, familyAcc);
      },
    );
  }

  void deleteitem(String id) {
    // _items.removeWhere(
    //   (element) {
    //     return element.id == id;
    //   },
    // );
    FirebaseFirestore.instance.collection('products').doc(id).delete();
    notifyListeners();
  }

  // ItemModal findById(String id) {
  //   return _items.firstWhere((prod) => prod.id == id);
  // }

  void dismissableSliderAction(
    BuildContext context,
    SlidableAction action,
    String id,
    String title,
    double amount,
    double weight,
    String unit,
    double quantity,
    Timestamp expiryDate,
  ) {
    switch (action) {
      case SlidableAction.delete:
        deleteitem(id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Product Deleted',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
        break;
      case SlidableAction.edit:
        showModalBottomSheet(
          context: context,
          builder: (_) => EditModalSheet(
            id: id,
            amount: amount,
            expiryDate: expiryDate,
            quantity: quantity,
            title: title,
            unit: unit,
            weight: weight,
          ),
        );
        break;
    }
    notifyListeners();
  }

  void updateProduct(String id, ItemModal newPrdouct) {
    // final productIndex = _items.indexWhere((prod) => prod.id == id);
    // _items[productIndex] = newPrdouct;
    FirebaseFirestore.instance.collection('products').doc(id).update({
      'title': newPrdouct.title,
      'amount': newPrdouct.amount,
      'unit': newPrdouct.unit,
      'quantity': newPrdouct.quantity,
      'weight': newPrdouct.weight,
      'expiryDate': newPrdouct.expiryDate,
    });
    notifyListeners();
  }

  Color changeColor(Timestamp refilDate, Timestamp current) {
    DateTime refillDate = refilDate.toDate();
    DateTime currentDate = current.toDate();
    final String currentDt = currentDate.toString();
    final String refill = refillDate.toString();
    final finalCurrentDate = DateTime.parse(refill);
    final finalRefillDate = DateTime.parse(currentDt);

    if (finalRefillDate.isAfter(finalCurrentDate)) {
      return Colors.red;
    } else if (finalRefillDate
            .isAfter(finalCurrentDate.subtract(Duration(days: 7))) ||
        finalRefillDate.isAfter(finalCurrentDate.subtract(Duration(days: 6))) ||
        finalRefillDate.isAfter(finalCurrentDate.subtract(Duration(days: 5))) ||
        finalRefillDate.isAfter(finalCurrentDate.subtract(Duration(days: 4))) ||
        finalRefillDate.isAfter(finalCurrentDate.subtract(Duration(days: 3))) ||
        finalRefillDate.isAfter(finalCurrentDate.subtract(Duration(days: 3))) ||
        finalRefillDate.isAfter(finalCurrentDate.subtract(Duration(days: 2))) ||
        finalRefillDate.isAfter(finalCurrentDate.subtract(Duration(days: 1)))) {
      return Colors.yellow;
    } else {
      return Colors.white;
    }
  }

  void logOut() async {
    FirebaseAuth.instance.signOut();
    final pref = await SharedPreferences.getInstance();
    //pref.clear();
    notifyListeners();
  }

  Future<String> getData(String uid) async {
    //print('success');
    final pref = await SharedPreferences.getInstance();
    final extractedUsername = pref.getString('userData');
    final extractedUserKey = pref.getString('key');
    final String key = extractedUserKey.toString();
    final String username = extractedUsername.toString();
    // print('${username}success');
    // print('${key}success');
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(key)
        .collection('familymember')
        .get();
    for (int i = 0; i < data.docs.length; i++) {
      userData = data.docs[i][username];
    }
    //print(userData);
    return userData;
  }

  Future<void> connectToFamily(
      String key, String name, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(key)
        .collection('familymember')
        .add({
      name: uid,
    });
    final pref = await SharedPreferences.getInstance();
    pref.setString('userData', name);
    pref.setString('key', key);
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  void connectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConnectFamily(connectToFamily),
    );
  }

  

  
}
