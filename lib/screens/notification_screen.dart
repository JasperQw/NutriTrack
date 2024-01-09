import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutritrack/resources/message_functions.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<Map<String, dynamic>> notificationList = [];
  late StreamSubscription notificationListener;
  getNotifications() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    Stream<QuerySnapshot> snapshots = firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("notification")
        .orderBy("created_at", descending: true)
        .snapshots();

    notificationListener = snapshots.listen((event) {
      if (event.size != 0 && event.docs.isNotEmpty) {
        for (DocumentSnapshot snapshot in event.docs) {
          setState(() {
            notificationList.clear();
            notificationList.add({
              "type": snapshot.get("message"),
              "message": MessageFunctions().getMessage(
                  snapshot.get("message"), snapshot.get("sender_name")),
              "title": MessageFunctions().getTitle(
                  snapshot.get("message"), snapshot.get("sender_name")),
              "sender_uid": snapshot.get("sender_uid"),
              "status": snapshot.get("status"),
              "request_status": snapshot.get("request_status"),
              "notification_uid": snapshot.id
            });
          });
        }
      }
    });
  }

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  @override
  void dispose() {
    notificationListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriTrack',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: primaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
          ),
          title: const Text(
            "Notification",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: notificationList.isEmpty ? Alignment.center : null,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: notificationList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/no_notification.svg",
                              height: 200,
                              width: 200,
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            const Text(
                              "No Notification!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                      : SingleChildScrollView(
                          clipBehavior: Clip.none,
                          child: Column(
                            children: notificationList.map((e) {
                              return NotificationItem(
                                  type: e['type']!,
                                  title: e['title']!,
                                  message: e['message']!,
                                  senderUid: e['sender_uid']!,
                                  status: e['status']!,
                                  notificationUid: e['notification_uid']!,
                                  requestStatus: e['request_status']!);
                            }).toList(),
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
