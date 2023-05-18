import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:resservation/models/meal.dart';
import 'package:resservation/presentation/admin/add_meal.dart';
import 'package:resservation/presentation/admin/admin_meals_reservations.dart';
import 'package:resservation/ressources/dimensions/constants.dart';
import 'package:unicons/unicons.dart';

class AdminMeals extends StatefulWidget {
  const AdminMeals({Key? key}) : super(key: key);

  @override
  State<AdminMeals> createState() => _AdminMealsState();
}

class _AdminMealsState extends State<AdminMeals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddMeal());
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('repas').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Meal> ml = [];
              for (var data in snapshot.data!.docs.toList()) {
                if (DateFormat("yyyy/MM/dd").format(data.get("start").toDate()) ==
                    DateFormat("yyyy/MM/dd").format(DateTime.now())) {
                  ml.add(Meal.fromJson(data.data() as Map<String, dynamic>));
                }
              }
              if (ml.isNotEmpty) {
                return ListView.builder(
                  itemCount: ml.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(AdminMealsReservation(id: snapshot.data!.docs[index].id));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  UniconsLine.utensils_alt,
                                  color: Colors.white,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Date de debut: ${DateFormat("yyyy/MM/dd HH:mm").format(ml[index].start)}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Date de fin : ${DateFormat("yyyy/MM/dd HH:mm").format(ml[index].end)}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Entree : ${ml[index].entree}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Plat principal : ${ml[index].principal} ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Dessert : ${ml[index].dessert}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          width: double.infinity,
                          decoration:
                              BoxDecoration(color: Colors.indigo.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    );
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
                          child: Text("Pas des étudiants pour le moment "),
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
