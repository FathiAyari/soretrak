import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:soretrak/models/requests.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({Key? key}) : super(key: key);

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('requests').where("status", isEqualTo: 0).snapshots(),
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
                      child: Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              borderRadius: BorderRadius.circular(10),
                              onPressed: (ctx) async {
                                var article =
                                    await FirebaseFirestore.instance.collection("articles").doc(res[index].articleId).get();
                                if (article.get("quantity") > 0) {
                                  int oldqt = article.get("quantity");
                                  article.reference.update({"quantity": oldqt - 1});
                                  snapshot.data!.docs[index].reference.update({"status": 1});
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text("la quantité de l'article est 0"),
                                    backgroundColor: (Colors.red),
                                    action: SnackBarAction(
                                      label: 'fermer',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.done_all,
                              label: "Accepter",
                            ),
                            SlidableAction(
                              onPressed: (ctx) async {
                                snapshot.data!.docs[index].reference.update({"status": -1});
                              },
                              borderRadius: BorderRadius.circular(10),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.close,
                              label: "Refuser",
                            ),
                          ],
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration:
                              BoxDecoration(color: Colors.indigo.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Date de demande: ${DateFormat("yyyy/MM/dd").format(res[index].dateTime)}",
                                    style: TextStyle(color: Colors.white)),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection('users').doc(res[index].ownerId).snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
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
                                    stream:
                                        FirebaseFirestore.instance.collection('articles').doc(res[index].articleId).snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
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
                          child: Text("Pas des demandes en cours "),
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
