// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../form/auth_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

bool isLoading = false;

final formKey = GlobalKey<FormState>();
TextEditingController userNameCtrl = TextEditingController();
TextEditingController userEmailCtrl = TextEditingController();
TextEditingController userPasswordCtrl = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Color.fromRGBO(70, 132, 153, 1),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Column(
            children: <Widget>[
              AuthPage(
                formKey: formKey,
                userNameCtrl: userNameCtrl,
                userEmailCtrl: userEmailCtrl,
                userPasswordCtrl: userPasswordCtrl,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // proses register user baru
                    onCreateUser(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(70, 132, 153, 1)),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreateUser(BuildContext context) async {
    await createUser();
  }

  Future createUser() async {
    setState(() {
      isLoading = true;
    });

    String name = userNameCtrl.text;
    String email = userEmailCtrl.text;
    String password = userPasswordCtrl.text;

    var url =
        'http://localhost/web-api/laporan-penjualan/users/user_register.php';
    var userData = {
      'user_name': name,
      'user_email': email,
      'user_password': password,
    };
    var response = await http.post(Uri.parse(url), body: json.encode(userData));
    var message = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(response.body);
    } else {
      setState(() {
        isLoading = false;
      });
      final alertMessage = AlertDialog(
        title: Text('Success'),
        content: Text(message.toString()),
        actions: [
          ElevatedButton(
              onPressed: () {
                // menutup message
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(70, 132, 153, 1)),
              child: Text('Ok')),
        ],
      );
      showDialog(
        context: context,
        builder: (context) {
          return alertMessage;
        },
      );
    }
  }
}
