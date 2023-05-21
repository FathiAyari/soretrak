import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:soretrak/models/requests.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';

class RefusedRequest extends StatefulWidget {
  const RefusedRequest({Key? key}) : super(key: key);

  @override
  State<RefusedRequest> createState() => _RefusedRequestState();
}

class _RefusedRequestState extends State<RefusedRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('requests').where("status", isEqualTo: -1).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Request> res = [];
              for (var data in snapshot.data!.docs.toList()) {
                res.add(Request.fromJson(data.data() as Map<String, dynamic>));
              }
              if (res.isNotEmpty) {
                return ListView.builder(
                  itemCount: res.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Date de demande: ${DateFormat("yyyy/MM/dd").format(res[index].dateTime)}",
                                style: TextStyle(color: Colors.white),
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('users').doc(res[index].ownerId).snapshots(),
                                  builder:
                                      (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
                                    if (userSnapshot.hasData) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Nom :${userSnapshot.data!.get("name")} ",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Prénom :${userSnapshot.data!.get("last_name")} ",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('articles').doc(res[index].articleId).snapshots(),
                                  builder:
                                      (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
                                    if (userSnapshot.hasData) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Nom d'article :${userSnapshot.data!.get("name")} ",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Marque d'article :${userSnapshot.data!.get("marque")} ",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
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
                          child: Text("Pas des demandes refusé "),
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
