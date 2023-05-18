import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:resservation/models/historic.dart';
import 'package:resservation/ressources/dimensions/constants.dart';

class AdminHistoric extends StatefulWidget {
  const AdminHistoric({Key? key}) : super(key: key);

  @override
  State<AdminHistoric> createState() => _AdmiHistoricState();
}

class _AdmiHistoricState extends State<AdminHistoric> {
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user['uid'])
              .collection('historics')
              .orderBy("dateTime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Historic> hs = [];
              for (var data in snapshot.data!.docs.toList()) {
                hs.add(Historic.fromJson(data.data() as Map<String, dynamic>));
              }
              if (hs.isNotEmpty) {
                return ListView.builder(
                  itemCount: hs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Date d'action : ${DateFormat("yyyy/MM/dd hh:mm").format(hs[index].dateTime)}",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Sujet : ${hs[index].subject}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
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
                          child: Text("Pas d'historique pour le moment "),
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
    ));
  }
}
