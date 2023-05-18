import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resservation/presentation/admin/admin_historic.dart';
import 'package:resservation/presentation/admin/admin_home.dart';
import 'package:resservation/presentation/admin/admin_meals.dart';
import 'package:unicons/unicons.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  List pages = [
    AdminHome(),
    AdminMeals(),
    AdminHistoric(),
  ];
  int index = 0;
  Future<bool> avoidReturnButton() async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("vous etes sur de sortir ?"),
            actions: [Negative(context), Positive()],
          );
        });
    return true;
  }

  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text(
            " Oui",
            style: TextStyle(
              color: Color(0xffEAEDEF),
            ),
          )),
    );
  }

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context); // fermeture de dialog
        },
        child: Text(" Non"));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: avoidReturnButton,
      child: SafeArea(
        child: Scaffold(
          body: pages[index],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.indigo,
            currentIndex: index,
            onTap: (i) {
              setState(() {
                index = i;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                label: 'Accuiel',
              ),
              BottomNavigationBarItem(
                icon: Icon(UniconsLine.bell),
                label: 'Repas',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.history),
                label: 'Historique',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
