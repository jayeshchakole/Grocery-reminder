import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  BuildContext context;
  final void Function(
    String email,
    String password,
    String username,
    bool islogin,
    BuildContext ctx,
  ) submitFn;
  AuthForm(
    this.context,
    this.submitFn,
    this.isLoading,
  );
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _islogin = true;
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail,
        _userPassword,
        _userName,
        _islogin,
        widget.context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 30),
              width: 250,
              height: 155,
              child: Image.asset(
                'lib/assets/image/login.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
              margin: EdgeInsets.only(
                left: 25,
              ),
              child: Text(
                _islogin ? 'Login' : 'Create Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(width: 30, child: Icon(Icons.email)),
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              key: ValueKey('email address'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || !value.contains('@')) {
                                  return 'Please type a valid Email Address';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _userEmail = newValue!;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Email Address'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (!_islogin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 30, child: Icon(Icons.person)),
                            Expanded(
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                key: ValueKey('username'),
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.length <= 3) {
                                    return 'Username Should be of atleast 4 charcter';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _userName = newValue!;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Username'),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(width: 30, child: Icon(Icons.lock)),
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              key: ValueKey('password'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.length <= 5) {
                                  return 'Password must be 6 charcter long';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _userPassword = newValue!;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // if (isFamily)
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       SizedBox(
                      //           width: 30, child: Icon(Icons.verified_user)),
                      //       Expanded(
                      //         child: TextFormField(
                      //           textInputAction: TextInputAction.done,
                      //           key: ValueKey('Token'),
                      //           obscureText: true,
                      //           validator: (value) {
                      //             if (value == null || value.length <= 25) {
                      //               return 'Token is incorrect';
                      //             }
                      //             return null;
                      //           },
                      //           onSaved: (newValue) {
                      //             _token = newValue!;
                      //           },
                      //           decoration: InputDecoration(labelText: 'Token'),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        RaisedButton(
                          onPressed: _trySubmit,
                          child: Text(_islogin ? 'Login' : 'SignUp'),
                        ),
                      SizedBox(height: 3),

                      if (!widget.isLoading)
                        FlatButton(
                          child: Text(
                            _islogin
                                ? 'Create a New Account'
                                : 'I Aready have a Account',
                            style: TextStyle(
                              color: Colors.teal,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _islogin = !_islogin;
                            });
                          },
                        )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
