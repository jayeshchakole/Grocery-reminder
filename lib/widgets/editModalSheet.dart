import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../provider/functions.dart';
import '../models/list_item.dart';

class EditModalSheet extends StatefulWidget {
  final String id;
  final String title;
  final double amount;
  final double weight;
  final String unit;
  final double quantity;
  late final Timestamp expiryDate;
  EditModalSheet({
    required this.id,
    required this.amount,
    required this.expiryDate,
    required this.quantity,
    required this.title,
    required this.unit,
    required this.weight,
  });
  @override
  _EditModalSheetState createState() => _EditModalSheetState();
}

class _EditModalSheetState extends State<EditModalSheet> {
  final _form = GlobalKey<FormState>();

  final List<String> dropDownValue = ['kg', 'gm', 'qty', 'lit', 'ml'];
  String value1 = '';
  DateTime _selectedDate = DateTime.now();
  var _isInit = true;
  double firstQuantity = 0.0;
  double finalAmount = 0.0;

  var _editedProduct = ItemModal(
    id: '',
    title: '',
    amount: 0.0,
    weight: 0.0,
    unit: '',
    quantity: 0.0,
    expiryDate: DateTime.now(),
  );

  var _initValue = {
    'title': '',
    'amount': '',
    'weight': '',
    'unit': '',
    'quantity': '',
  };

  @override
  void initState() {
    value1 = dropDownValue[1];

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // final User user = FirebaseAuth.instance.currentUser!;
    //  uid = user.uid;
    if (_isInit) {
      // _editedProduct = Provider.of<FunctionsCode>(context, listen: false)
      //     .findById(widget.id);
      // firstQuantity = _editedProduct.quantity;

      print(firstQuantity);
      _initValue = {
        'title': widget.title,
        'amount': widget.amount.toString(),
        'weight': widget.weight.toString(),
        'unit': widget.unit,
        'quantity': widget.quantity.toString(),
      };
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now().add(Duration(days: 1825)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      if (pickedDate.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Expiry Date cannot be less than Current Date',
            ),
          ),
        );

        return;
      }
      
      Timestamp myTimeStamp = Timestamp.fromDate(pickedDate);

      setState(() {
        widget.expiryDate = myTimeStamp;
      });
    });
  }

  DateTime? convertStamp(Timestamp _stamp) {
        if (_stamp != null) {
          return Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate();
        } else {
          return null;
        }
      }

  void saveForm() {
    _form.currentState!.save();

    if (firstQuantity > _editedProduct.quantity) {
      finalAmount = _editedProduct.amount / _editedProduct.quantity;
      _editedProduct.amount = finalAmount;
      //print(firstQuantity);
    } else {
      finalAmount = _editedProduct.amount * _editedProduct.quantity;
      _editedProduct.amount = finalAmount;
    }

    Provider.of<FunctionsCode>(context, listen: false)
        .updateProduct(widget.id, _editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initValue['title'],
                  decoration: InputDecoration(labelText: 'Item Purched'),
                  onSaved: (value) {
                    _editedProduct = ItemModal(
                      id: widget.id,
                      title: value!,
                      amount: _editedProduct.amount,
                      weight: _editedProduct.weight,
                      unit: _editedProduct.unit,
                      quantity: _editedProduct.quantity,
                      expiryDate: _editedProduct.expiryDate,
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _initValue['amount'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                  onSaved: (value) {
                    _editedProduct = ItemModal(
                      id: widget.id,
                      title: _editedProduct.title,
                      amount: double.parse(value!),
                      weight: _editedProduct.weight,
                      unit: _editedProduct.unit,
                      quantity: _editedProduct.quantity,
                      expiryDate: _editedProduct.expiryDate,
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: _initValue['weight'],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Weight'),
                        onSaved: (value) {
                          _editedProduct = ItemModal(
                            id: widget.id,
                            title: _editedProduct.title,
                            amount: _editedProduct.amount,
                            weight: double.parse(value!),
                            unit: _editedProduct.unit,
                            quantity: _editedProduct.quantity,
                            expiryDate: _editedProduct.expiryDate,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      child: DropdownButton(
                        value: value1,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 15,
                        onChanged: (value) {
                          setState(() {
                            _editedProduct.unit = value.toString();
                          });
                          print(_editedProduct.unit);
                        },
                        items: dropDownValue
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: _initValue['quantity'],
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Quantity min(x1)'),
                        onSaved: (value) {
                          _editedProduct = ItemModal(
                            id: widget.id,
                            title: _editedProduct.title,
                            amount: _editedProduct.amount,
                            weight: _editedProduct.weight,
                            unit: _editedProduct.unit,
                            quantity: double.parse(value!),
                            expiryDate: _editedProduct.expiryDate,
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Choose Date'
                              : 'Expiry Date : ${convertStamp(widget.expiryDate)}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: _presentDatePicker,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: saveForm,
                  child: Text(
                    'Edit Product',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
