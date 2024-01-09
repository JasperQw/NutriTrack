import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:nutritrack/utils/colors.dart";

class ProfileDialog {
  profileDialog(BuildContext context, String type, TextEditingController tec) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 300,
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$type Email",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]),
                child: TextField(
                  controller: tec,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  cursorColor: white,
                  decoration: const InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    suffixStyle: TextStyle(
                      fontSize: 13,
                      color: white,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: black,
                    labelStyle: TextStyle(color: Colors.white70),
                    contentPadding: EdgeInsets.only(
                      left: 20,
                      top: 20,
                      bottom: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    label: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (tec.text.isEmpty) return;
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  FirebaseAuth auth = FirebaseAuth.instance;
                  if (tec.text == auth.currentUser!.email) return;

                  QuerySnapshot dependent = await firestore
                      .collection("users")
                      .doc(auth.currentUser!.uid)
                      .collection("dependent")
                      .where("email", isEqualTo: tec.text)
                      .get();
                  QuerySnapshot guardian = await firestore
                      .collection("users")
                      .doc(auth.currentUser!.uid)
                      .collection("guardian")
                      .where("email", isEqualTo: tec.text)
                      .get();

                  if (dependent.docs.isNotEmpty || guardian.docs.isNotEmpty) {
                    return;
                  }

                  QuerySnapshot snapshot = await firestore
                      .collection("users")
                      .where("email", isEqualTo: tec.text)
                      .get();

                  if (snapshot.size != 0 && snapshot.docs.isNotEmpty) {
                    DocumentSnapshot currentUser = await firestore
                        .collection('users')
                        .doc(auth.currentUser!.uid)
                        .get();
                    String currentUserName = currentUser.get("name");
                    DocumentSnapshot s = snapshot.docs.first;
                    String id = s.id;
                    firestore
                        .collection("users")
                        .doc(id)
                        .collection("notification")
                        .add({
                      "message": type,
                      "sender_name": currentUserName,
                      "sender_uid": auth.currentUser!.uid,
                      "created_at": DateTime.now(),
                      "request_status": "pending",
                      "status": "unread"
                    });
                  }

                  tec.text = "";

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(color: white, width: 1),
                  ),
                  child: const Text("Submit"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
