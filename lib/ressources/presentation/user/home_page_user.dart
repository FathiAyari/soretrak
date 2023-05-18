import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soretrak/ressources/presentation/user/my_requests.dart';
import 'package:unicons/unicons.dart';

import 'user_home.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List pages = [
    HomeUser(),
    MyRequests(),
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
                label: 'Me demands',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
