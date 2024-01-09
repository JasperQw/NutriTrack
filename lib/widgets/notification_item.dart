import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/screens/notification_detail_screen.dart';
import 'package:nutritrack/utils/colors.dart';

class NotificationItem extends StatefulWidget {
  final String title;
  final String message;
  final String senderUid;
  final String status;
  final String requestStatus;
  final String notificationUid;
  final String type;
  const NotificationItem(
      {super.key,
      required this.title,
      required this.message,
      required this.senderUid,
      required this.status,
      required this.notificationUid,
      required this.requestStatus,
      required this.type});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.status == "unread") {
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          FirebaseAuth auth = FirebaseAuth.instance;
          await firestore
              .collection("users")
              .doc(auth.currentUser!.uid)
              .collection("notification")
              .doc(widget.notificationUid)
              .update({"status": "read"});
        }

        if (context.mounted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NotificationDetailScreen(
                type: widget.type,
                title: widget.title,
                message: widget.message,
                senderUid: widget.senderUid,
                requestStatus: widget.requestStatus,
                notificationUid: widget.notificationUid);
          }));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 32),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: const BoxDecoration(
            color: black,
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white24,
                spreadRadius: 2,
                blurRadius: 10,
              )
            ]),
        child: Row(
          children: [
            Stack(
              children: [
                const Icon(
                  Icons.notifications_none,
                  size: 30,
                ),
                widget.status == "unread"
                    ? Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            const SizedBox(
              width: 32,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
