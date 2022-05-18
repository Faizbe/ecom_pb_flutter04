import 'package:ecom_pb_flutter04/auth/auth_service.dart';
import 'package:ecom_pb_flutter04/providers/product_provider.dart';
import 'package:ecom_pb_flutter04/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String _errMsg = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            shrinkWrap: true,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email Address'
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return emptyFieldErrMsg;
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                obscureText: _obscureText,
                controller: _passwordController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    hintText: 'Password'
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return emptyFieldErrMsg;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                child: Text('LOGIN'),
                onPressed: _loginAdmin,
              ),
              SizedBox(height: 20,),
              Text(_errMsg)
            ],
          ),
        )
      ),
    );
  }

  void _loginAdmin() async {
    if(_formKey.currentState!.validate()) {
      try {
        final uid = await AuthService.loginAdmin(_emailController.text, _passwordController.text);
        if(uid != null) {

          final isAdmin = await Provider.of<ProductProvider>(context, listen: false).isAdmin(AuthService.currentUser!.email!);
          if(isAdmin) {
            Navigator.pushReplacementNamed(context, DashboardPage.routeName);
          }else {
            setState(() {
              _errMsg = 'You are not an admin';
            });
          }
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          _errMsg = error.message!;
        });
    }
    }
  }
}
