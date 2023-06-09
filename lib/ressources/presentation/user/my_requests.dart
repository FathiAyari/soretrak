import 'package:flutter/material.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';
import 'package:soretrak/ressources/presentation/user/my_accepted_requests.dart';
import 'package:soretrak/ressources/presentation/user/my_pending_requests.dart';
import 'package:soretrak/ressources/presentation/user/my_refused_requests.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({Key? key}) : super(key: key);

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> with TickerProviderStateMixin {
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0)..addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.04),
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              height: Constants.screenHeight * 0.06,
              child: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.grey,
                splashFactory: NoSplash.splashFactory,
                labelColor: Colors.green,
                controller: _tabController,
                labelPadding: EdgeInsets.all(10),
                indicator: BoxDecoration(color: Colors.cyan.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                tabs: [
                  Container(
                      alignment: Alignment.center,
                      child: Text("En cours", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                  Container(
                      alignment: Alignment.center,
                      child: Text("Refusé", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                  Container(
                      alignment: Alignment.center,
                      child: Text("Accepté", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                ],
              ),
            ),
          ),
          Expanded(
              child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [MyPendingRequests(), MyRefusedRequests(), MyAcceptedRequest()],
          ))
        ],
      ),
    );
  }
}
