import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soretrak/models/Users.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';
import 'package:soretrak/ressources/presentation/widgets/input_field.dart';
import 'package:soretrak/services/AuthServices.dart';

import '../../../router/router.dart';
import 'alertTask.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  File? _image;

  final _formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Creér un compte",
              style: TextStyle(color: Colors.indigo),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.indigo),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      InputField(
                        label: "Nom",
                        controller: nameController,
                        textInputType: TextInputType.text,
                        prefixWidget: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.indigo,
                        ),
                      ),
                      InputField(
                        label: "Prénom",
                        controller: lastNameController,
                        textInputType: TextInputType.text,
                        prefixWidget: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.indigo,
                        ),
                      ),
                      InputField(
                        label: "Email",
                        controller: emailcontroller,
                        textInputType: TextInputType.emailAddress,
                        prefixWidget: Icon(
                          Icons.email,
                          color: Colors.indigo,
                        ),
                      ),
                      InputField(
                        label: "Mot de passe",
                        controller: passController,
                        textInputType: TextInputType.visiblePassword,
                        prefixWidget: Icon(
                          Icons.lock,
                          color: Colors.indigo,
                        ),
                      ),
                      loading
                          ? CircularProgressIndicator()
                          : Container(
                              child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 5),
                              child: Container(
                                width: double.infinity,
                                child: CupertinoButton(
                                    child: Text(
                                      'S\'inscrire',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic, // fontWeight: FontWeight.bold )
                                      ),
                                    ),
                                    color: Colors.indigo,
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          loading=true;
                                        });
                                        bool check = await AuthServices().signUp(Cusers(
                                            name: nameController.text,
                                            last_name: lastNameController.text,
                                            password: passController.text,
                                            email: emailcontroller.text,
                                            role: "user"));

                                        if (check) {
                                          setState(() {
                                            loading = false;
                                          });
                                          AuthServices().getUserData().then((value) {
                                            AuthServices().saveUserLocally(value);

                                            if (value.role == 'user') {
                                              Navigator.pushNamed(context, AppRouting.homeClient);
                                            } else if (value.role == 'admin') {
                                              Navigator.pushNamed(context, AppRouting.homeAdmin);
                                            } else {}
                                          });
                                        } else {
                                          setState(() {
                                            loading = false;
                                          });
                                          alertTask(
                                            lottieFile: "assets/lotties/error.json",
                                            action: "Ressayer",
                                            message: "Email déja existe",
                                            press: () {
                                              Navigator.pop(context);
                                            },
                                          ).show(context);
                                        }
                                      }
                                    }),
                              ),
                            )),
                    ],
                  )))),
    );
  }
}
