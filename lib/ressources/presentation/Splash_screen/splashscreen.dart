import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';
import 'package:soretrak/ressources/router/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var seen = GetStorage().read("seen");
  var role = GetStorage().read("role");
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      if (role != null) {
        if (role == 'user') {
          Get.toNamed(AppRouting.homeClient);
        } else {
          Get.toNamed(AppRouting.homeAdmin);
        }
      } else {
        Get.toNamed("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(children: <Widget>[
              SizedBox(
                height: Constants.screenHeight * 0.2,
              ),
              SizedBox(
                height: Constants.screenHeight * 0.1,
              ),
              Text(
                "BIEN VENUE AU SORETRAK",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.indigo, fontSize: 20),
              ),
              SizedBox(
                height: Constants.screenHeight * 0.1,
              ),
              Lottie.asset("assets/lotties/loading.json", height: Constants.screenHeight * 0.07),
              Lottie.asset("assets/lotties/logo.json", height: Constants.screenHeight * 0.2),
            ])));
  }
}
