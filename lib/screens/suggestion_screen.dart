import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/utils/constant.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

Widget sendWidget(String text) {
  return Container(
    alignment: Alignment.topRight,
    child: Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(
        left: 80,
        top: 32,
      ),
      decoration: const BoxDecoration(
          color: yellowishGreen,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          )),
      child: Text(
        text,
        style: const TextStyle(
          color: black,
        ),
        textAlign: TextAlign.justify,
      ),
    ),
  );
}

Widget replyWidget(String text) {
  return Container(
    alignment: Alignment.topLeft,
    child: Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(
        right: 80,
        top: 32,
      ),
      decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          )),
      child: Text(
        text,
        style: const TextStyle(
          color: black,
        ),
        textAlign: TextAlign.justify,
      ),
    ),
  );
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final openAI = OpenAI.instance.build(
      token: OPENAI_API_KEY,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 5),
      ),
      enableLog: true);
  late TextEditingController sendTextController;
  List<Widget> chatHistroy = [];
  List<Map<String, dynamic>> chatHistoryString = [];

  getChatHistory() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    Query chatRef = firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chat")
        .orderBy("created_at", descending: false);
    QuerySnapshot chatSnapshot = await chatRef.get();

    if (chatSnapshot.size != 0 && chatSnapshot.docs.isNotEmpty) {
      setState(() {
        for (QueryDocumentSnapshot doc in chatSnapshot.docs) {
          if (doc.get("from") == "user") {
            chatHistroy.add(sendWidget(doc.get("message")));
            chatHistoryString
                .add({"role": "user", "message": doc.get("message")});
          } else {
            chatHistroy.add(replyWidget(doc.get("message")));
            chatHistoryString
                .add({"role": "bot", "message": doc.get("message")});
          }
        }
      });
    }
  }

  @override
  void initState() {
    sendTextController = TextEditingController();
    getChatHistory();
    super.initState();
  }

  @override
  void dispose() {
    sendTextController.dispose();
    super.dispose();
  }

  Widget suggestionSelectionBox(String text) {
    return GestureDetector(
      onTap: () async {
        await sendMessage(text);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: white),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  sendMessage(String text) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chat")
        .add({
      "from": "user",
      "message": text,
      "created_at": DateTime.now().microsecondsSinceEpoch
    });
    setState(() {
      chatHistoryString.add({"role": "user", "message": text});
      chatHistroy.add(sendWidget(text));
      sendTextController.text = "";
    });

    List<Messages> messagesHistory = chatHistoryString.map((m) {
      if (m['role'] == "user") {
        return Messages(role: Role.user, content: m['message']);
      } else {
        return Messages(role: Role.assistant, content: m['message']);
      }
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: messagesHistory,
      maxToken: 200,
    );

    final response = await openAI.onChatCompletion(request: request);

    for (var element in response!.choices) {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("chat")
          .add({
        "from": "bot",
        "message": element.message!.content,
        "created_at": DateTime.now().microsecondsSinceEpoch
      });
      setState(() {
        chatHistroy.add(replyWidget(element.message!.content));
        chatHistoryString
            .add({"role": "bot", "message": element.message!.content});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "NutriBot",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              IconButton(
                onPressed: () async {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  FirebaseAuth auth = FirebaseAuth.instance;
                  CollectionReference chatRef = firestore
                      .collection("users")
                      .doc(auth.currentUser!.uid)
                      .collection("chat");

                  QuerySnapshot chatSnapshot = await chatRef.get();

                  for (QueryDocumentSnapshot doc in chatSnapshot.docs) {
                    await doc.reference.delete();
                  }

                  setState(() {
                    chatHistroy.clear();
                    chatHistoryString.clear();
                  });
                },
                icon: const Icon(Icons.delete_outline),
                padding: const EdgeInsets.all(20),
              )
            ],
          ),
          Expanded(
            child: chatHistroy.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/ChatBot.svg",
                            height: 200,
                            width: 200,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 30),
                            child: const Text(
                              "No chat yet!\nAsk me some questions!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    reverse: true,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: chatHistroy,
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      suggestionSelectionBox("Suggest me a balanced meal!"),
                      suggestionSelectionBox("Suggest me a expensive meal!"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: sendTextController,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          30,
                        ),
                      ),
                    ),
                    hintText: "Enter your questions....",
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          30,
                        ),
                      ),
                      borderSide: BorderSide(color: white),
                    ),
                  ),
                  cursorColor: white,
                ),
              ),
              IconButton(
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  await sendMessage(sendTextController.text);
                },
                icon: const Icon(
                  Icons.send,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
