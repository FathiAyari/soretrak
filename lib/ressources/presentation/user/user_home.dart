import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:soretrak/models/article.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';
import 'package:soretrak/ressources/presentation/widgets/icon_button_splash/view/icon_button_splash.dart';
import 'package:soretrak/services/AuthServices.dart';
import 'package:unicons/unicons.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({Key? key}) : super(key: key);

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  var user = GetStorage().read("user");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 30,
                    child: Image.asset(
                      "assets/images/user.png",
                      color: Colors.indigo,
                    ),
                  ),
                  Text(
                    "Bonjour ${user['name']} ${user['last_name']}",
                    style: TextStyle(color: Colors.indigo, fontSize: 20),
                  ),
                  Spacer(),
                  IconButtonSplash(
                    bgColor: Colors.indigo.withOpacity(0.5),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Deconnecter",
                              style: TextStyle(color: Colors.indigo),
                            ),
                            content: Container(
                                child: Text(
                              "Clickez oui pour deconnecter",
                              style: TextStyle(color: Colors.indigo),
                            )),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Oui',
                                  style: TextStyle(color: Colors.indigo),
                                ),
                                onPressed: () {
                                  AuthServices().logOut(context);
                                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(UniconsLine.signout),
                    splashColor: Colors.indigo,
                  )
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('articles').where("quantity", isNotEqualTo: 0).snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    List<Article> articles = [];
                    for (var data in snapshot.data!.docs) {
                      articles.add(Article.fromJson(data.data() as Map<String, dynamic>));
                    }
                    if (articles.isNotEmpty) {
                      return Expanded(
                          child: ListView.builder(
                        itemCount: articles!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Slidable(
                              key: const ValueKey(0),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    borderRadius: BorderRadius.circular(10),
                                    onPressed: null,
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.cancel,
                                    label: 'Annuler',
                                  ),
                                  SlidableAction(
                                    onPressed: (ctx) async {
                                      FirebaseFirestore.instance.collection("requests").add({
                                        "articleId": articles[index].id,
                                        "ownerId": user['uid'],
                                        "status": 0,
                                        "dateTime": DateTime.now(),
                                      });
                                      final snackBar = SnackBar(
                                        content: Text("Demande est en cours de traitement"),
                                        backgroundColor: (Colors.green),
                                        action: SnackBarAction(
                                          label: 'fermer',
                                          textColor: Colors.white,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    backgroundColor: Colors.indigo.withOpacity(0.5),
                                    foregroundColor: Colors.white,
                                    icon: Icons.add,
                                    label: 'Demander',
                                  ),
                                ],
                              ),
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
                                        UniconsLine.ticket,
                                        color: Colors.white,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Nom de l'article :${articles[index].name} ",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Marque de l'article :${articles[index].marque} ",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Quantité disponible de l'article :${articles[index].quantity} ",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ));
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
                                child: Text("Pas des articles pour le moment "),
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
                })
          ],
        ),
      ),
    );
  }
}
