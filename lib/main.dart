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
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: MyAppBar(title='Home'),
      body: Column(
        children: [Text('A random idea:'), Text(appState.current.asLowerCase)],
      ),
    );
  }
}

class MyAppBar extends AppBar {
  Widget build(BuildContext context, String title) {
    var homeIcon = Icon(Icons.home);
    
    return AppBar(
      backgroundColor: Colors.blue[700],
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: print("Hello"),
          icon: homeIcon,
          ),
      ],
    );
  }
}