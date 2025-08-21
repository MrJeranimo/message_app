import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
        home: MyHomePage(),
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
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    /* How to find the size of the screen
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height; */

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Home"),
        centerTitle: true,
      ),
      body: Column(
        spacing: 5.0,
        children: [
          SizedBox(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: appState.updateTextChains,
              child: Text("Update Text Chains"),
            )
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: appState.textController,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: appState.addName,
              child: Text("Add Name"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: appState.clearNames,
              child: Text("Clear Names"),
            ),
          ),
        ],
      ),
    );
  }
}

class TextChain extends StatefulWidget {
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Row(
      children: [Text(appState.getNextName())],
    );
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}