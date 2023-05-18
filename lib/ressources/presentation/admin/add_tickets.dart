import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resservation/models/Users.dart';
import 'package:resservation/presentation/widgets/input_field.dart';

class AddTickets extends StatefulWidget {
  final Cusers cusers;
  const AddTickets({Key? key, required this.cusers}) : super(key: key);

  @override
  State<AddTickets> createState() => _AddTicketsState();
}

class _AddTicketsState extends State<AddTickets> {
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController qt = TextEditingController();
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ajouter des tickets",
          style: TextStyle(color: Colors.indigo),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.indigo),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nom et prénom : ${widget.cusers.name} ${widget.cusers.last_name}",
                style: TextStyle(color: Colors.indigo, fontSize: 15),
              ),
              Text(
                "Cin : ${widget.cusers.cin} ",
                style: TextStyle(color: Colors.indigo, fontSize: 15),
              ),
              Text(
                "Solde : ${widget.cusers.tickets!.length} tickets",
                style: TextStyle(color: Colors.indigo, fontSize: 15),
              ),
              Text(
                "Sexe : ${widget.cusers.sexe} ",
                style: TextStyle(color: Colors.indigo, fontSize: 15),
              ),
              Text(
                "Carte etudiant : ${widget.cusers.student_card_number} ",
                style: TextStyle(color: Colors.indigo, fontSize: 15),
              ),
              Form(
                key: _formkey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: InputField(label: "Quantité", textInputType: TextInputType.number, controller: qt),
                ),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: Colors.indigo,
                          child: Text("Ajouter"),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              var tk = await FirebaseFirestore.instance.collection("users").doc(widget.cusers.uid).get();
                              var oldTk = tk.get('tickets');
                              var newList = [];
                              int length = int.tryParse(qt.text)!;
                              for (int i = 0; i < length; i++) {
                                int randomNumber = Random().nextInt(999999);
                                newList.add(randomNumber);
                              }
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.cusers.uid)
                                  .update({"tickets": newList + oldTk});
                              FirebaseFirestore.instance.collection("users").doc(user['uid']).collection("historics").add({
                                "dateTime": DateTime.now(),
                                "subject":
                                    "Vous aves ajouter ${qt.text} tickets à ${widget.cusers.name} ${widget.cusers.last_name}"
                              });
                              FirebaseFirestore.instance.collection("users").doc(widget.cusers.uid).collection("historics").add({
                                "dateTime": DateTime.now(),
                                "subject": "Vous aves recu ${qt.text} tickets de la part de ${user['name']} ${user['last_name']}"
                              });
                              setState(() {
                                isLoading = false;
                                qt.clear();
                                Navigator.pop(context);
                              });
                            }
                          },
                        ),
                      ),
                    )
              /*       Text(
                "Solde : ${widget.cusers.tickets!.length} Ticket",
                style: TextStyle(color: Colors.indigo, fontSize: 15),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
