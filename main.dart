import 'dart:math';

import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:random_words/random_words.dart';

void main() {
  runApp(MyApp());
}

/*
* var translate =
        await translator.translate(randomWord, from: 'en', to: 'tr');
* */
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Words game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Words Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final translator = GoogleTranslator();
  Random random = new Random();
  List<String> words = [];
  String _answerWord;
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateWords();
  }

  void _pointCounter() {
    setState(() {
      _counter++;
    });
  }

  void _pointClear() {
    setState(() {
      _counter = 0;
    });
  }

  void _updateWords() {
    setState(() {
      if (words.isEmpty) {
        generateNoun().take(4).forEach((element) {
          words.add(element.word);
          print(element.word);
        });

        //_answer =words[random.nextInt(3)];
      } else {
        words.clear();
        generateNoun().take(4).forEach((element) {
          words.add(element.word);
          print(element.word);
        });
      }
    });
    _answerWord = words[random.nextInt(4)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            Text(
              'Word is : $_answerWord',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(
              flex: 1,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  _answers(words[0], context),
                  _answers(words[1], context),
                  _answers(words[2], context),
                  _answers(words[3], context),
                ],
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Text(
              "Score : $_counter",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _updateWords,
            tooltip: "Change the question",
            child: Icon(Icons.update),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: _pointClear,
            tooltip: "Reset the Score",
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  /*_getTranslated(word)async{
    var translate = await translator.translate(word, from: 'en', to: 'tr');

  }*/

  _answers(String word, BuildContext context) {
    return FutureBuilder(
        future: translator.translate(word, from: 'en', to: 'tr'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "error",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.teal,
                width: double.infinity,
                height: 75,
                child: TextButton(
                    child: Text(
                      "${snapshot.data}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (word == _answerWord) {
                        _pointCounter();
                        print("correct");
                        _updateWords();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          new SnackBar(
                            content: Text('Wrong Answer',style: TextStyle(
                              fontSize: 20,

                            ),),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {

                              },
                            ),
                          ),
                        );
                      }
                    }),
              ),
            );
        });
  }

/*_answers(String word, BuildContext context)async {
    var translate = await translator.translate(word, from: 'en', to: 'tr');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.teal,
        width: double.infinity,
        height: 75,
        child: TextButton(
            child: Text(
              "$translate",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (word == _answerWord) {
                _pointCounter();
                print("correct");
                _updateWords();
              } else {
                Scaffold.of(context).showSnackBar(
                  new SnackBar(
                    content: Text(
                      "Wrong Answer",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }*/
}
