import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:resservation/models/Users.dart';
import 'package:resservation/presentation/admin/add_tickets.dart';
import 'package:resservation/presentation/widgets/icon_button_splash/view/icon_button_splash.dart';
import 'package:resservation/ressources/dimensions/constants.dart';
import 'package:unicons/unicons.dart';

import '../../services/AuthServices.dart';

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
      var userData = await FirebaseFirestore.instance.collection('users').doc(barcodeScanRes).get();

      if (userData.exists) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTickets(
                      cusers: Cusers.fromJson(userData.data() as Map<String, dynamic>),
                    )));
      } else {
        final snackBar = SnackBar(
          content: Text("Pas d'etudian avec ce Qr code"),
          backgroundColor: (Colors.red),
          action: SnackBarAction(
            label: 'fermer',
            textColor: Colors.white,
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                stream: FirebaseFirestore.instance.collection('users').where("role", isEqualTo: "user").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Cusers> users = [];
                    for (var data in snapshot.data!.docs.toList()) {
                      users.add(Cusers.fromJson(data.data() as Map<String, dynamic>));
                    }
                    if (users.isNotEmpty) {
                      return Expanded(
                          child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Container(
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
                                        "Nom et prénom : ${users[index].name} ${users[index].last_name}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "Nombre de tickets :${users[index].tickets!.length} ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            width: double.infinity,
                            height: Constants.screenHeight * 0.1,
                            decoration:
                                BoxDecoration(color: Colors.indigo.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
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
                })
          ],
        ),
      ),
    );
  }
}
