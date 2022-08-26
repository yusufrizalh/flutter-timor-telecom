// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController userNameCtrl;
  late TextEditingController userEmailCtrl;
  late TextEditingController userPasswordCtrl;

  AuthPage({
    required this.formKey,
    required this.userNameCtrl,
    required this.userEmailCtrl,
    required this.userPasswordCtrl,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: widget.userNameCtrl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Enter user name'),
              style: TextStyle(color: Colors.black87, fontSize: 18.0),
            ),
            Padding(padding: EdgeInsets.all(12.0)),
            TextFormField(
              controller: widget.userEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Enter user email'),
              style: TextStyle(color: Colors.black87, fontSize: 18.0),
            ),
            Padding(padding: EdgeInsets.all(12.0)),
            TextFormField(
              controller: widget.userPasswordCtrl,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(labelText: 'Enter user password'),
              style: TextStyle(color: Colors.black87, fontSize: 18.0),
            ),
            Padding(padding: EdgeInsets.all(12.0)),
          ],
        ),
      ),
    );
  }
}
