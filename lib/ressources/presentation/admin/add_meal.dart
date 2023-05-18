import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resservation/models/meal.dart';
import 'package:resservation/presentation/widgets/input_field.dart';
import 'package:resservation/ressources/dimensions/constants.dart';

class AddMeal extends StatefulWidget {
  const AddMeal({Key? key}) : super(key: key);

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController en = TextEditingController();
  TextEditingController pc = TextEditingController();
  TextEditingController ds = TextEditingController();
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  bool startSelected = false;
  bool endSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Ajouter repas",
          style: TextStyle(color: Colors.indigo),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.indigo),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              InputField(label: "Entreé", textInputType: TextInputType.text, controller: en),
              InputField(label: "Plat principal", textInputType: TextInputType.text, controller: pc),
              InputField(label: "Dessert", textInputType: TextInputType.text, controller: ds),
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
                          showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
                            if (time != null) {
                              setState(() {
                                start = DateTime(value.year, value.month, value.day, time.hour, time.minute);
                                startSelected = true;
                              });
                            }
                          });
                        }
                      });
                    },
                    child: FittedBox(
                      child: Text("Date de debut ${startSelected ? " : ${DateFormat("yyyy/MM/dd HH:mm").format(start)}" : ""}"),
                    ),
                  ),
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
                          showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
                            if (time != null) {
                              setState(() {
                                end = DateTime(value.year, value.month, value.day, time.hour, time.minute);
                                endSelected = true;
                              });
                            }
                          });
                        }
                      });
                    },
                    child: FittedBox(
                      child: Text("Date de fin  ${endSelected ? " : ${DateFormat("yyyy/MM/dd HH:mm").format(end)}" : ""}"),
                    ),
                  ),
                ),
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 5),
                      child: Container(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: Colors.indigo,
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              if (!startSelected) {
                                final snackBar = SnackBar(
                                  content: Text("Date de debut est obligatoire"),
                                  backgroundColor: (Colors.red),
                                  action: SnackBarAction(
                                    label: 'fermer',
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else if (!endSelected) {
                                final snackBar = SnackBar(
                                  content: Text("Date de fin est obligatoire"),
                                  backgroundColor: (Colors.red),
                                  action: SnackBarAction(
                                    label: 'fermer',
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                FirebaseFirestore.instance.collection("repas").add(Meal(
                                    entree: en.text,
                                    principal: pc.text,
                                    dessert: ds.text,
                                    start: start,
                                    end: end,
                                    students: []).toJson());
                                setState(() {
                                  loading = false;
                                  en.clear();
                                  ds.clear();
                                  pc.clear();
                                  Navigator.pop(context);
                                });
                                final snackBar = SnackBar(
                                  content: Text("Repas bien ajouté"),
                                  backgroundColor: (Colors.green),
                                  action: SnackBarAction(
                                    label: 'fermer',
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }
                          },
                          child: FittedBox(
                            child: Text("Ajouter"),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
