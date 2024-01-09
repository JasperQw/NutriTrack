import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class FoodDetection {
  foodDetectionAPI(Uint8List image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    Reference ref =
        storage.ref().child("temporary_image").child(auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    Uri url = Uri.parse("http://127.0.0.1:5000");
    http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image_url": downloadUrl}));

    await storage
        .ref()
        .child("temporary_image")
        .child(auth.currentUser!.uid)
        .delete();

    if (response.statusCode == 200) {
      return {"message": response.body, "code": response.statusCode};
    } else {
      return {"message": response.body, "code": response.statusCode};
    }
  }
}
