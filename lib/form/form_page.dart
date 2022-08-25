// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController productNameCtrl;
  late TextEditingController productPriceCtrl;

  FormPage({
    required this.formKey,
    required this.productNameCtrl,
    required this.productPriceCtrl,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
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
              controller: widget.productNameCtrl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Enter product name'),
              style: TextStyle(color: Colors.black87, fontSize: 18.0),
            ),
            Padding(padding: EdgeInsets.all(12.0)),
            TextFormField(
              controller: widget.productPriceCtrl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Enter product price'),
              style: TextStyle(color: Colors.black87, fontSize: 18.0),
            ),
            Padding(padding: EdgeInsets.all(12.0)),
          ],
        ),
      ),
    );
  }
}
