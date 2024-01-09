import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FoodFunctions {
  FirebaseAuth authRef = FirebaseAuth.instance;
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getNutrient(String foodName) async {
    Map<String, dynamic> essentials = {};
    Map<String, dynamic> vitamins = {};
    Map<String, dynamic> minerals = {};
    QuerySnapshot essentialSnapshot = await firestoreRef
        .collection("food")
        .doc(foodName)
        .collection("Essentials")
        .get();

    QuerySnapshot vitaminSnapshot = await firestoreRef
        .collection("food")
        .doc(foodName)
        .collection("Vitamins")
        .get();

    QuerySnapshot mineralSnapshot = await firestoreRef
        .collection("food")
        .doc(foodName)
        .collection("Minerals")
        .get();

    for (var doc in essentialSnapshot.docs) {
      essentials[doc.get("label")] = {
        "amount": double.parse(doc.get("amount").toString()),
        "unit": doc.get("unit")
      };
    }

    for (var doc in vitaminSnapshot.docs) {
      vitamins[doc.get("label")] = {
        "amount": double.parse(doc.get("amount").toString()),
        "unit": doc.get("unit")
      };
    }

    for (var doc in mineralSnapshot.docs) {
      minerals[doc.get("label")] = {
        "amount": double.parse(doc.get("amount").toString()),
        "unit": doc.get("unit")
      };
    }

    return {
      "essentials": essentials,
      "vitamins": vitamins,
      "minerals": minerals
    };
  }

  addIntake(double amount, Map<String, dynamic> essentials,
      Map<String, dynamic> vitamins, Map<String, dynamic> minerals) async {
    String key = DateFormat("EEEE, dd-MM-yyyy").format(
      DateTime.now(),
    );

    String uid = authRef.currentUser!.uid;

    QuerySnapshot docRef = await firestoreRef
        .collection("users")
        .doc(uid)
        .collection("nutrients")
        .doc(key)
        .collection("Essentials")
        .get();

    CollectionReference essentialRef = firestoreRef
        .collection("users")
        .doc(uid)
        .collection("nutrients")
        .doc(key)
        .collection("Essentials");
    CollectionReference vitaminRef = firestoreRef
        .collection("users")
        .doc(uid)
        .collection("nutrients")
        .doc(key)
        .collection("Vitamins");
    CollectionReference mineralRef = firestoreRef
        .collection("users")
        .doc(uid)
        .collection("nutrients")
        .doc(key)
        .collection("Minerals");

    if (docRef.docs.isNotEmpty) {
      for (MapEntry<String, dynamic> essential in essentials.entries) {
        await essentialRef
            .doc(essential.key == "Carbohydrate" ? "Carbo" : essential.key)
            .update({
          "curVal": FieldValue.increment(double.parse(
              ((essential.value["amount"] as double) * amount)
                  .toStringAsFixed(2)))
        });
      }

      for (MapEntry<String, dynamic> vitamin in vitamins.entries) {
        await vitaminRef.doc(vitamin.key).update({
          "curVal": FieldValue.increment(double.parse(
              ((vitamin.value["amount"] as double) * amount)
                  .toStringAsFixed(2)))
        });
      }

      for (MapEntry<String, dynamic> mineral in minerals.entries) {
        await mineralRef.doc(mineral.key).update({
          "curVal": FieldValue.increment(double.parse(
              ((mineral.value["amount"] as double) * amount)
                  .toStringAsFixed(2)))
        });
      }
    } else {
      for (MapEntry<String, dynamic> essential in essentials.entries) {
        await essentialRef
            .doc(essential.key == "Carbohydrate" ? "Carbo" : essential.key)
            .set({
          "curVal": double.parse(
              ((essential.value["amount"] as double) * amount)
                  .toStringAsFixed(2)),
          "label": essential.key == "Carbohydrate" ? "Carbo" : essential.key,
          "targetVal": 3000,
          "unit": essential.value["unit"]
        });
      }

      for (MapEntry<String, dynamic> vitamin in vitamins.entries) {
        await vitaminRef.doc(vitamin.key).set({
          "curVal": double.parse(((vitamin.value["amount"] as double) * amount)
              .toStringAsFixed(2)),
          "label": vitamin.key,
          "targetVal": 3000,
          "unit": vitamin.value["unit"]
        });
      }

      for (MapEntry<String, dynamic> mineral in minerals.entries) {
        await mineralRef.doc(mineral.key).set({
          "curVal": double.parse(((mineral.value["amount"] as double) * amount)
              .toStringAsFixed(2)),
          "label": mineral.key,
          "targetVal": 3000,
          "unit": mineral.value["unit"]
        });
      }
    }
  }
}
