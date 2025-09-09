import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

void main() {
  String jsonString = '{"name": "Test","id": 1,"messages": [{"message": "Hello","isMe": false},{"message": "Hello","isMe": true}]}';
  Map<String, dynamic> chainMap = jsonDecode(jsonString);
  Chain chain = Chain.fromJson(chainMap);
  print(chain);
  print(chainMap);
  for(int i = 0; i < chain.messageChain.length; i++) {
    print(chain.messageChain[i].message);
    print(chain.messageChain[i].isMe);
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Message App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: ListViewBuilder(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var names = <String>[];
  var index = 0;
  var textChains = <TextChain>[];
  final textController = TextEditingController();
  int currentIndex = 0;

  void addName() {
    names.add(textController.text);
    notifyListeners();
  }

  void clearNames() {
    names.clear();
    textChains.clear();
    notifyListeners();
  }

  String getNextName() {
    var name = names.elementAt(index);
    index++;
    return name;
  }

  void updateTextChains() {
    for(int i = textChains.length - 1; i < names.length - 1; i++) {
      textChains.add(TextChain());
    }
    print(names);
    print(textChains);
    notifyListeners();
  }

  void onListClick(int index, context) {
    currentIndex = index;
    print("List Item Clicked $index");
    // Pushes a new page onto the navigation stack
    // Uses the MaterialPageRoute to go to the new page
    Navigator.push(context, MaterialPageRoute(builder:(context) => TextChain()));
  }

  void sendMessage(int index) {
    print("Updated Text Chain $index");
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({super.key}); // Constructor with optimal key

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.list),
            trailing: Text("N/A"),
            title: Text("Text Chain $index"),
            onTap: () => appState.onListClick(index, context),
          );
        },
      ),
    );
  }
}

class TextChain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String jsonString = '{"name": "Test","id": 1,"messages": [{"message": "Hello","isMe": false},{"message": "Hello","isMe": true},{"message": "Goodbye","isMe": false}]}';
    Map<String, dynamic> chainMap = jsonDecode(jsonString);
    Chain chain = Chain.fromJson(chainMap);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(chain.name),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: chain.messageChain.length,
        itemBuilder: (context, messageIndex) {
          final message = chain.messageChain[messageIndex].message;
          final isMe = chain.messageChain[messageIndex].isMe;
          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: 4),
              constraints: BoxConstraints(maxWidth: 250),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue[400] : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe? Radius.circular(12) : Radius.zero,
                  bottomRight: isMe? Radius.zero : Radius.circular(12),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Chain {
  final String name;
  final int id;
  List<dynamic> messageChain;

  Chain({
    required this.name,
    required this.id,
    required this.messageChain,
  });

  factory Chain.fromJson(Map<String, dynamic> json){
    return Chain(
      name: json["name"],
      id: json["id"],
      messageChain: (json["messages"] as List)
          .map((msg) => Message.fromJson(msg))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "messages": messageChain,
    };
  }
}

class Message {
  // Dart variables to hold the equivalent JSON values
  final String message;
  final bool isMe;

  // Constructor for the Dart Message class
  Message({
    required this.message,
    required this.isMe,
  });

  // Factory Constuctor to turn a Message from Json into Dart
  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      message: json["message"],
      isMe: json["isMe"],
    );
  }

  // Method to turn a Dart Message into a Json Message
  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "isMe": isMe,
    };
  }
}
