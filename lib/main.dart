import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

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
        title: 'Random Names Generator',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<WordPair> _wordPairs = [];
  int? _lastIndex;

  List<WordPair> get wordPairs => _wordPairs;
  int? get lastIndex => _lastIndex;

  void addNext() {
    if (_wordPairs.length >= 10) {
      _wordPairs.removeAt(0);
    }
    _wordPairs.add(WordPair.random()); 
    _lastIndex = _wordPairs.length - 1;
    notifyListeners(); 
  }

  void clearList() {
    _wordPairs.clear();
    _lastIndex = null;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: MainContent()))
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       SizedBox(
        width: 300, 
        child: Text(
          'Clique no botão para gerar uma palavra nova', 
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center, 
          )
       ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          NewWordButton(),
          SizedBox(width: 10),
          CleanListButton(),
        ],),
      Expanded(
        child: NameList(),
      ),
      ],
    );
  }
}

class NewWordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mainContentState = context.watch<MyAppState>();
  
    return MyButton(
      width: 150, 
      height: 70, 
      text: 'Nova Palavra', 
      cor: Colors.blueAccent,
      onPressFunction:  () {
        mainContentState.addNext(); 
      });
  }
}

class CleanListButton extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    var mainContentState = context.watch<MyAppState>();
  
    return MyButton(
      width: 150, 
      height: 70, 
      text: 'Limpar Lista', 
      cor: Colors.redAccent,
      onPressFunction:  () {
        mainContentState.clearList(); 
      });
  }
}

class MyButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback onPressFunction;
  final MaterialAccentColor cor;

  MyButton(
    {
      required this.width,
      required this.height,
      required this.text,
      required this.onPressFunction,
      required this.cor,
    }
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          onPressed: onPressFunction,
          style: ElevatedButton.styleFrom(
            backgroundColor: cor,
            minimumSize: Size(width, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            )
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        );
  }
}

class NameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mainContentState = context.watch<MyAppState>();

    return ListView.builder(
            itemCount: mainContentState.wordPairs.length,
            itemBuilder: (context, index) {
              final wordPair = mainContentState.wordPairs[index];

              return NameLine(
                key: ValueKey(wordPair), // Adicione uma chave única
                word: wordPair.asLowerCase,
                lastIndex: mainContentState.lastIndex ?? -1,
                index: index,
                );
            },
          );
  }
}

class NameLine extends StatefulWidget {
  final String word;
  final int lastIndex;
  final int index;

  NameLine({
    required this.word,
    required this.lastIndex,
    required this.index,
    Key? key,
  }) : super(key: key);
 
  @override
  _NameLineState createState() => _NameLineState();
}

class _NameLineState extends State<NameLine> {
  late bool isHighlighted;

  @override
  void initState() {
    super.initState();
    isHighlighted = widget.index == widget.lastIndex;
  }

  @override
  void didUpdateWidget(covariant NameLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index == widget.lastIndex && !isHighlighted) {
      setState(() {
        isHighlighted = true;
      });
    } else if (widget.index != widget.lastIndex && isHighlighted) {
      setState(() {
        isHighlighted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      color: isHighlighted ? Colors.amber : Colors.transparent,
      child: ListTile(
        title: Text(
          widget.word, 
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
