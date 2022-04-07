import 'package:flutter/material.dart';
import 'package:authapp/components/comHelper.dart';
import 'package:authapp/components/genLoginSignupHeader.dart';
import 'package:authapp/components/genTextFormField.dart';
import 'package:authapp/database/DbHelper.dart';
import 'package:authapp/models/user.dart';
import 'package:authapp/Screens/create_account_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  login() async {
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      alertDialog(context, "Please Enter User Name");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(uid, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("user_id", user.user_id);
    sp.setString("user_name", user.user_name);
    sp.setString("email", user.email);
    sp.setString("password", user.password);
    sp.setBool("isLoggedIn", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              genLoginSignupHeader('Login'),
              getTextFormField(
                  controller: _conUserId,
                  icon: Icons.person,
                  hintName: 'User Name'),
              const SizedBox(height: 10.0),
              getTextFormField(
                controller: _conPassword,
                icon: Icons.lock,
                hintName: 'Password',
                isObscureText: true,
              ),
              Container(
                margin: const EdgeInsets.all(30.0),
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: login,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Does not have account? '),
                  ElevatedButton(
                    child: const Text('Signup', style: TextStyle(color: Colors.green),),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CreateAccount()));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
