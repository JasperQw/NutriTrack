import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String title;
  final String message;
  final String senderUid;
  final String requestStatus;
  final String notificationUid;
  final String type;
  const NotificationDetailScreen(
      {super.key,
      required this.title,
      required this.message,
      required this.senderUid,
      required this.requestStatus,
      required this.notificationUid,
      required this.type});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
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
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Text(
                          widget.message,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        widget.requestStatus != "pending"
                            ? Container()
                            : Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        FirebaseFirestore firestore =
                                            FirebaseFirestore.instance;
                                        FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        await firestore
                                            .collection("users")
                                            .doc(auth.currentUser!.uid)
                                            .collection("notification")
                                            .doc(widget.notificationUid)
                                            .update(
                                                {"request_status": "accepted"});

                                        DocumentSnapshot senderInfo =
                                            await firestore
                                                .collection("users")
                                                .doc(widget.senderUid)
                                                .get();

                                        DocumentSnapshot currentUserInfo =
                                            await firestore
                                                .collection("users")
                                                .doc(auth.currentUser!.uid)
                                                .get();

                                        String senderName =
                                            senderInfo.get("name");
                                        String senderPlan =
                                            senderInfo.get("type");
                                        String senderProfileImage =
                                            senderInfo.get("profileImage");
                                        String currentUserName =
                                            currentUserInfo.get("name");
                                        String currentUserPlan =
                                            currentUserInfo.get("type");
                                        String currentUserProfileImage =
                                            currentUserInfo.get("profileImage");

                                        if (widget.type == "Dependent") {
                                          await firestore
                                              .collection("users")
                                              .doc(auth.currentUser!.uid)
                                              .collection("guardian")
                                              .doc(widget.senderUid)
                                              .set({
                                            "name": senderName,
                                            "profileImage": senderProfileImage
                                          });

                                          await firestore
                                              .collection("users")
                                              .doc(widget.senderUid)
                                              .collection("dependent")
                                              .doc(auth.currentUser!.uid)
                                              .set({
                                            "name": currentUserName,
                                            "plan": currentUserPlan,
                                            "profileImage":
                                                currentUserProfileImage
                                          });

                                          await firestore
                                              .collection("users")
                                              .doc(widget.senderUid)
                                              .collection("notification")
                                              .add({
                                            "message": "Dependent Success",
                                            "sender_name": currentUserName,
                                            "sender_uid": auth.currentUser!.uid,
                                            "created_at": DateTime.now(),
                                            "request_status": "accepted",
                                            "status": "unread"
                                          });
                                        } else if (widget.type == "Guardian") {
                                          await firestore
                                              .collection("users")
                                              .doc(auth.currentUser!.uid)
                                              .collection("dependent")
                                              .doc(widget.senderUid)
                                              .set({
                                            "name": senderName,
                                            "plan": senderPlan,
                                            "profileImage": senderProfileImage
                                          });

                                          await firestore
                                              .collection("users")
                                              .doc(widget.senderUid)
                                              .collection("guardian")
                                              .doc(auth.currentUser!.uid)
                                              .set({
                                            "name": currentUserName,
                                            "profileImage":
                                                currentUserProfileImage
                                          });

                                          await firestore
                                              .collection("users")
                                              .doc(widget.senderUid)
                                              .collection("notification")
                                              .add({
                                            "message": "Guardian Success",
                                            "sender_name": currentUserName,
                                            "sender_uid": auth.currentUser!.uid,
                                            "created_at": DateTime.now(),
                                            "request_status": "accepted",
                                            "status": "unread"
                                          });
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: blue,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Accept",
                                          style: TextStyle(
                                              fontSize: 18, color: white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        FirebaseFirestore firestore =
                                            FirebaseFirestore.instance;
                                        FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        await firestore
                                            .collection("users")
                                            .doc(auth.currentUser!.uid)
                                            .collection("notification")
                                            .doc(widget.notificationUid)
                                            .update(
                                                {"request_status": "rejected"});

                                        DocumentSnapshot currentUserInfo =
                                            await firestore
                                                .collection("users")
                                                .doc(auth.currentUser!.uid)
                                                .get();

                                        String currentUserName =
                                            currentUserInfo.get("name");

                                        if (widget.type == "Dependent") {
                                          await firestore
                                              .collection("users")
                                              .doc(widget.senderUid)
                                              .collection("notification")
                                              .add({
                                            "message": "Dependent Fail",
                                            "sender_name": currentUserName,
                                            "sender_uid": auth.currentUser!.uid,
                                            "created_at": DateTime.now(),
                                            "request_status": "accepted",
                                            "status": "unread"
                                          });
                                        } else if (widget.type == "Guardian") {
                                          await firestore
                                              .collection("users")
                                              .doc(widget.senderUid)
                                              .collection("notification")
                                              .add({
                                            "message": "Guardian Fail",
                                            "sender_name": currentUserName,
                                            "sender_uid": auth.currentUser!.uid,
                                            "created_at": DateTime.now(),
                                            "request_status": "accepted",
                                            "status": "unread"
                                          });
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: gray,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Reject",
                                          style: TextStyle(
                                              fontSize: 18, color: white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
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
