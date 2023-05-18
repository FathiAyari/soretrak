import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:resservation/models/meal.dart';
import 'package:resservation/ressources/dimensions/constants.dart';
import 'package:unicons/unicons.dart';

class AdminMealsReservation extends StatefulWidget {
  final String id;

  const AdminMealsReservation({Key? key, required this.id}) : super(key: key);

  @override
  State<AdminMealsReservation> createState() => _AdminMealsReservationState();
}

class _AdminMealsReservationState extends State<AdminMealsReservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reservations",
          style: TextStyle(color: Colors.indigo),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.indigo),
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('repas').doc(widget.id).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
            if (userSnapshot.hasData) {
              Meal tt = Meal.fromJson(userSnapshot.data!.data() as Map<String, dynamic>);
              if (tt.students!.isNotEmpty) {
                return ListView.builder(
                  itemCount: tt.students!.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(tt.students[index]).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> sp) {
                          if (sp.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: double.infinity,
                                height: Constants.screenHeight * 0.1,
                                decoration:
                                    BoxDecoration(color: Colors.indigo.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        UniconsLine.user,
                                        color: Colors.white,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Nom et Prénom : ${sp.data!.get("name")} ${sp.data!.get("last_name")}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        });
                  },
                );
              } else {
                return Center(
                  child: Container(
                    height: Constants.screenHeight * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Pas des reservations pour le moment "),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
