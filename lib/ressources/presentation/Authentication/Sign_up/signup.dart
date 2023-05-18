import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  TextEditingController studentCardController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController cinController = TextEditingController();
  DateTime birth_date = DateTime.now();
  bool dateSelected = false;
  String sexe = "homme";
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
                        label: "CIN",
                        controller: cinController,
                        textInputType: TextInputType.number,
                        prefixWidget: Icon(
                          Icons.perm_identity_sharp,
                          color: Colors.indigo,
                        ),
                      ),
                      InputField(
                        label: "Numéro de carte etudiant",
                        controller: studentCardController,
                        textInputType: TextInputType.number,
                        prefixWidget: Icon(
                          Icons.perm_identity_sharp,
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              "Sexe : ",
                              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.indigo),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: Constants.screenHeight * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                ),
                                child: DropdownButton<String>(
                                  value: sexe,
                                  underline: SizedBox(
                                    height: 0,
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Homme',
                                          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black38),
                                        ),
                                      ),
                                      value: 'homme',
                                    ),
                                    DropdownMenuItem(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Femme',
                                          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black38),
                                        ),
                                      ),
                                      value: 'femme',
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      sexe = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 5),
                        child: Container(
                          width: double.infinity,
                          child: CupertinoButton(
                            color: Colors.green,
                            onPressed: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2500),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    birth_date = value;
                                    dateSelected = true;
                                  });
                                }
                              });
                            },
                            child: FittedBox(
                              child: Text(
                                  "Date de naissance${dateSelected ? " : ${DateFormat("yyyy/MM/dd").format(birth_date)}" : ""}"),
                            ),
                          ),
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
                                        if (dateSelected) {
                                          setState(() {
                                            loading = true;
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
                                        } else {
                                          final snackBar = SnackBar(
                                            content: const Text("Date de naissance obligatoire"),
                                            backgroundColor: (Colors.red),
                                            action: SnackBarAction(
                                              label: 'fermer',
                                              textColor: Colors.white,
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
