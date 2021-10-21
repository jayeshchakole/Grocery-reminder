import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/mainDrawer.dart';
import '../widgets/slidablewidget.dart';
import '../provider/functions.dart';

enum AccountType {
  Personal,
  Family,
}

class HomeScreen extends StatefulWidget {
  static const routeName = 'homescreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOrder = false;
  //bool accountSwicth = false;
  var _userkey;
  bool familyAcc = false;
  bool personalAcc = true;
  int accType = 1;

  void getuserkey() async {
    final pref = await SharedPreferences.getInstance();
    final key = pref.getString('key');
    setState(() {
      _userkey = key.toString();
    });
  }

  @override
  void didChangeDependencies() {
    getuserkey();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    getuserkey();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final function = Provider.of<FunctionsCode>(context);
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    var _userData;

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.account_box),
            onSelected: (AccountType selectedValue) {
              switch (selectedValue) {
                case AccountType.Family:
                  setState(() {
                    accType = 2;
                    personalAcc = false;
                    familyAcc = true;
                  });
                  break;
                case AccountType.Personal:
                  setState(() {
                    accType = 1;
                    personalAcc = true;
                    familyAcc = false;
                  });
                  break;
                default:
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Family Account',
                ),
                value: AccountType.Family,
              ),
              PopupMenuItem(
                child: Text(
                  'Personal Account',
                ),
                value: AccountType.Personal,
              ),
            ],
          ),
          _isOrder
              ? Container(
                  height: 0,
                  width: 0,
                )
              : IconButton(
                  onPressed: () {
                    function.addItem(context, _userkey, familyAcc);
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                ),
          IconButton(
            icon: Icon(Icons.payment),
            onPressed: () {
              setState(() {
                _isOrder = !_isOrder;
              });
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> productSnapshot) {
          if (productSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final productDetail = productSnapshot.data?.docs;
          final length = productDetail!.length;
          return Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: length,
                    itemBuilder: (ctx, index) {
                      DateTime myDateTime =
                          productDetail[index]['expiryDate'].toDate();
                      final String formatedTime =
                          DateFormat.yMMMEd().format(myDateTime);

                      return FutureBuilder(
                        future: function.getData(uid),
                        builder: (context, snapshot) {
                          _userData = snapshot.data;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
/************************************************Personal Account *******************************************************/
                          switch (accType) {
                            case 1:
                              print('personal sucess');
                              if (uid == productDetail[index]['userId']) {
                                return Container(
                                  height: 90,
                                  child: Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 1,
                                    ),
                                    child: SlidableWidget(
                                      onDismissed: (action) {
                                        function.dismissableSliderAction(
                                          context,
                                          action,
                                          productDetail[index].id,
                                          productDetail[index]['title'],
                                          productDetail[index]['amount'],
                                          productDetail[index]['weight'],
                                          productDetail[index]['unit'],
                                          productDetail[index]['quantity'],
                                          productDetail[index]['expiryDate'],
                                        );
                                      },
                                      child: Container(
                                        color: function.changeColor(
                                            productDetail[index]['expiryDate'],
                                            Timestamp.now()),
                                        alignment: Alignment.center,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 28,
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: FittedBox(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      productDetail[index]
                                                              ['weight']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      productDetail[index]
                                                          ['unit'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Row(
                                            children: [
                                              Text(
                                                productDetail[index]['title'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'x${productDetail[index]['quantity']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          subtitle: Text(
                                            'Refill Date: ${formatedTime}',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: _isOrder
                                              ? Checkbox(
                                                  value: productDetail[index]
                                                      ['isorder'],
                                                  onChanged: (value) {
                                                    FirebaseFirestore.instance
                                                        .collection('products')
                                                        .doc(
                                                            productDetail[index]
                                                                .id)
                                                        .update(
                                                            {'isorder': value});
                                                    if (value == true) {
                                                      function.orderData(
                                                        productDetail[index]
                                                            ['title'],
                                                        productDetail[index]
                                                            ['unit'],
                                                        productDetail[index]
                                                            ['weight'],
                                                        productDetail[index]
                                                            ['quantity'],
                                                      );
                                                    }
                                                  })
                                              : SizedBox(
                                                  width: 60,
                                                  child: Text(
                                                    'Rs:${productDetail[index]['amount']}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                Center(
                                  child: Text(
                                    'No Data Found',
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                              break;
/***********************************************Family Account *************************************************************/
                            case 2:
                              if (_userData == uid) {
                                print('family success');
                                if (_userkey ==
                                    productDetail[index]['userId']) {
                                  return Container(
                                    height: 90,
                                    child: Card(
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 1,
                                      ),
                                      child: SlidableWidget(
                                        onDismissed: (action) {
                                          function.dismissableSliderAction(
                                            context,
                                            action,
                                            productDetail[index].id,
                                            productDetail[index]['title'],
                                            productDetail[index]['amount'],
                                            productDetail[index]['weight'],
                                            productDetail[index]['unit'],
                                            productDetail[index]['quantity'],
                                            productDetail[index]['expiryDate'],
                                          );
                                        },
                                        child: Container(
                                          color: function.changeColor(
                                              productDetail[index]
                                                  ['expiryDate'],
                                              Timestamp.now()),
                                          alignment: Alignment.center,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              radius: 28,
                                              child: Padding(
                                                padding: EdgeInsets.all(4),
                                                child: FittedBox(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        productDetail[index]
                                                                ['weight']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        productDetail[index]
                                                            ['unit'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Row(
                                              children: [
                                                Text(
                                                  productDetail[index]['title'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'x${productDetail[index]['quantity']}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                            subtitle: Text(
                                              'Refill Date: ${formatedTime}',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            trailing: _isOrder
                                                ? Checkbox(
                                                    value: productDetail[index]
                                                        ['isorder'],
                                                    onChanged: (value) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'products')
                                                          .doc(productDetail[
                                                                  index]
                                                              .id)
                                                          .update({
                                                        'isorder': value
                                                      });
                                                      if (value == true) {
                                                        function.orderData(
                                                          productDetail[index]
                                                              ['title'],
                                                          productDetail[index]
                                                              ['unit'],
                                                          productDetail[index]
                                                              ['weight'],
                                                          productDetail[index]
                                                              ['quantity'],
                                                        );
                                                      }
                                                    })
                                                : SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      'Rs:${productDetail[index]['amount']}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                Center(
                                  child: Text(
                                    'Not connected to any family',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }

                              break;
                            default:
                              return Text(
                                'No Data Found',
                                style: TextStyle(color: Colors.pink),
                              );
                          }

                          return Center();
                        },
                      );
                    },
                  ),
                ),
                if (_isOrder)
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: function.placeOrder,
                      child: Text('Order now'),
                    ),
                  )
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (_isOrder)
          ? null
          : FloatingActionButton(
              onPressed: () {
                function.addItem(context, _userkey, familyAcc);
              },
              child: Icon(Icons.add),
            ),
    );
  }
}
