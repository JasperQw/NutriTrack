import "dart:typed_data";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";

class AuthFunctions {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<String> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> signUp(
      String name,
      String email,
      String password,
      String confirmedPassword,
      String type,
      int age,
      double height,
      double weight,
      Uint8List? file,
      String race,
      String religion) async {
    String res = "error";
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmedPassword.isNotEmpty &&
        type.isNotEmpty &&
        age > 0 &&
        height > 0 &&
        weight > 0 &&
        file != null) {
      try {
        UserCredential user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        Reference ref =
            storage.ref().child("usersProfileImage").child(user.user!.uid);
        UploadTask uploadTask = ref.putData(file);

        TaskSnapshot snap = await uploadTask;
        String downloadUrl = await snap.ref.getDownloadURL();
        await firestore.collection("users").doc(user.user!.uid).set({
          "id": user.user!.uid,
          "name": name,
          "email": email,
          "type": type,
          "age": age,
          "weight": weight,
          "height": height,
          "race": race,
          "religion": religion,
          "profileImage": downloadUrl
        });

        res = "success";
        return res;
      } catch (e) {
        res = e.toString();
        return res;
      }
    }
    return res;
  }

  Future<Map<String, String>> getUserData() async {
    DocumentSnapshot data =
        await firestore.collection("users").doc(auth.currentUser!.uid).get();
    return {
      "name": data.get("name"),
      "imagePath": data.get("profileImage"),
      "type": data.get("type")
    };
  }

  Future<Map<String, String>> getSpecificUserData(String uid) async {
    DocumentSnapshot data = await firestore.collection("users").doc(uid).get();
    return {
      "name": data.get("name"),
      "imagePath": data.get("profileImage"),
      "type": data.get("type")
    };
  }

  Future<List<Map<String, String>>> getDependent() async {
    QuerySnapshot data = await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("dependent")
        .get();
    List<Map<String, String>> dependentList = [];
    for (QueryDocumentSnapshot doc in data.docs) {
      dependentList.add({
        "name": doc['name'],
        "plan": doc['plan'],
        "imagePath": doc['profileImage'],
        "key": doc.id
      });
    }

    return dependentList;
  }

  Future<List<Map<String, String>>> getGuardian() async {
    QuerySnapshot data = await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("guardian")
        .get();
    List<Map<String, String>> guardianList = [];
    for (QueryDocumentSnapshot doc in data.docs) {
      guardianList.add({
        "name": doc['name'],
        "imagePath": doc['profileImage'],
      });
    }
    return guardianList;
  }
}
