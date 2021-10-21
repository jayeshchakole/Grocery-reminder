import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModalSheet extends StatefulWidget {
  Function addtx;
  ModalSheet(this.addtx, this.userKey, this.familyAcc);
  String userKey;
  bool familyAcc;
  @override
  _ModalSheetState createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _weightController = TextEditingController();
  final _quantityController = TextEditingController();
  final List<String> dropDownValue = ['kg', 'gm', 'qty', 'lit', 'ml'];
  String value1 = '';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    value1 = dropDownValue[1];
    super.initState();
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
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void trySubmit() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    final weight = double.parse(_weightController.text);
    final unit = value1;
    final DateTime expiryDate = _selectedDate;
    final quantity = double.parse(_quantityController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || weight <= 0) {
      return;
    }
    widget.addtx(
      enteredTitle,
      enteredAmount,
      weight,
      unit,
      quantity,
      expiryDate,
      widget.userKey,
      widget.familyAcc,
      
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Item Purched'),
                controller: _titleController,
                onSubmitted: (_) => trySubmit(),
                //focusNode: FocusNode(canRequestFocus: true),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
                controller: _amountController,
                onSubmitted: (_) => trySubmit(),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Weight'),
                      controller: _weightController,
                      onSubmitted: (_) => trySubmit(),
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
                          value1 = value.toString();
                          //print(value1);
                        });
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
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: 'Quantity min(x1)'),
                      controller: _quantityController,
                      onSubmitted: (_) => trySubmit(),
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
                            : 'Refill Date : ${DateFormat.yMd().format(_selectedDate)}',
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
                onPressed: trySubmit,
                child: Text(
                  'Add Product',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
