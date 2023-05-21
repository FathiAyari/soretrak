import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:soretrak/models/article.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';
import 'package:soretrak/ressources/presentation/admin/add_article.dart';
import 'package:soretrak/ressources/presentation/admin/update_article.dart';
import 'package:soretrak/ressources/presentation/widgets/icon_button_splash/view/icon_button_splash.dart';
import 'package:soretrak/services/AuthServices.dart';
import 'package:unicons/unicons.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  var user = GetStorage().read("user");
  QRViewController? controller;

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      var userData = await FirebaseFirestore.instance.collection('articles').doc(barcodeScanRes).get();

      if (userData.exists) {
        final snackBar = SnackBar(
          content: Text("Il ya deja un article avec cet code QR"),
          backgroundColor: (Colors.red),
          action: SnackBarAction(
            label: 'fermer',
            textColor: Colors.white,
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (barcodeScanRes != "-1") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddArticle(code: barcodeScanRes)));
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButtonSplash(
        bgColor: Colors.indigo.withOpacity(0.5),
        onPressed: () {
          scanQR();
        },
        icon: Icon(UniconsLine.qrcode_scan),
        splashColor: Colors.indigo,
      ),
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
                  Icon(
                    Icons.admin_panel_settings_sharp,
                    color: Colors.indigo,
                  ),
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
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('articles').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Article> res = [];
                    for (var data in snapshot.data!.docs.toList()) {
                      res.add(Article.fromJson(data.data() as Map<String, dynamic>));
                    }
                    if (res.isNotEmpty) {
                      return Expanded(
                          child: ListView.builder(
                        itemCount: res.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(10),
                                  onPressed: null,
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.cancel,
                                ),
                                SlidableAction(
                                  onPressed: (ctx) async {
                                    var requests = await FirebaseFirestore.instance
                                        .collection('requests')
                                        .where("articleId", isEqualTo: res[index].id)
                                        .get();

                                    for (var data in requests.docs.toList()) {
                                      data.reference.delete();
                                    }
                                    snapshot.data!.docs[index].reference.delete();
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (ctx) async {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => UpdateArticle(data: snapshot.data!.docs[index])));
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                ),
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(10),
                                  onPressed: null,
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.cancel,
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              height: Constants.screenHeight * 0.15,
                              decoration:
                                  BoxDecoration(color: Colors.indigo.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Nom d'article : ${res[index].name}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Marque d'article :${res[index].marque} ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Quantité d'article :${res[index].quantity} ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('cateogeries')
                                            .doc(res[index].idCat)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
                                          if (userSnapshot.hasData) {
                                            return Text(
                                              "Categorie d'article :${userSnapshot.data!.get("name")} ",
                                              style: TextStyle(color: Colors.white),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        })
                                  ],
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
