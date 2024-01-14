import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

Random rng = new Random();

BorderSide getRandomSide() {
  return BorderSide(
    color: Colors.primaries[rng.nextInt(Colors.primaries.length)],
    strokeAlign: rng.nextDouble() * 2 - 1,
    style: rng.nextBool() ? BorderStyle.none : BorderStyle.solid,
    width: rng.nextDouble() * 3,
  );
}

OutlinedBorder? getRandomShape() {
  final random = rng.nextInt(7);
  switch (random) {
    case 0:
      return BeveledRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.elliptical(rng.nextDouble() * 2, rng.nextDouble() * 2)),
          side: getRandomSide());
    case 1:
      return CircleBorder(
        eccentricity: rng.nextDouble(),
        side: getRandomSide(),
      );
    case 2:
      return ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.elliptical(rng.nextDouble() * 2, rng.nextDouble() * 2)),
        side: getRandomSide(),
      );
    case 3:
      return LinearBorder(
        bottom: LinearBorderEdge(
            alignment: rng.nextDouble() * 2 - 1, size: rng.nextDouble()),
        end: LinearBorderEdge(
            alignment: rng.nextDouble() * 2 - 1, size: rng.nextDouble()),
        start: LinearBorderEdge(
            alignment: rng.nextDouble() * 2 - 1, size: rng.nextDouble()),
        top: LinearBorderEdge(
            alignment: rng.nextDouble() * 2 - 1, size: rng.nextDouble()),
        side: getRandomSide(),
      );
    case 4:
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.elliptical(rng.nextDouble() * 2, rng.nextDouble() * 2)),
        side: getRandomSide(),
      );
    case 5:
      return StadiumBorder(side: getRandomSide());
    case 6:
      final double sum = rng.nextDouble() - 0.0001;
      final double pointR = rng.nextDouble() * sum;
      return StarBorder(
        side: getRandomSide(),
        innerRadiusRatio: rng.nextDouble(),
        pointRounding: pointR,
        points: rng.nextInt(50) + 2,
        rotation: rng.nextDouble() * 360,
        squash: rng.nextDouble(),
        valleyRounding: sum - pointR,
      );
    default:
      return null;
  }
}

Widget generateRandomButton() {
  return FilledButton(
    onPressed: () {},
    style: FilledButton.styleFrom(
      backgroundColor: Colors.primaries[rng.nextInt(Colors.primaries.length)],
      elevation: rng.nextDouble() * 10,
      foregroundColor: Colors.primaries[rng.nextInt(Colors.primaries.length)],
      shadowColor: Colors.primaries[rng.nextInt(Colors.primaries.length)],
      shape: getRandomShape(),
    ),
    child: const Text('Text'),
  );
}

class RandomButtons extends StatefulWidget {
  @override
  RandomButtonsState createState() => RandomButtonsState();
}

class RandomButtonsState extends State<RandomButtons> {
  final List<Widget> buttons = <Widget>[];

  Widget buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        if (index.isOdd) return const Divider();
        index = index ~/ 2;

        while (index >= buttons.length) {
          buttons.add(generateRandomButton()); // Change This
        }

        return buttons[index];
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Button Generator"),
        centerTitle: true,
      ),
      body: buildList(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();
        final index = item ~/ 2;

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(pair) {
    final alreadySaved = _savedWordPairs.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
      hoverColor: Colors.black,
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: TextStyle(fontSize: 16.0),
            ),
            trailing: Icon(
              Icons.favorite_rounded,
              color: Colors.red,
            ),
            onTap: () {
              setState(() {
                _savedWordPairs.remove(pair);
              });
            },
          );
        });
        final List<Widget> divided =
            ListTile.divideTiles(context: context, tiles: tiles).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text("Saved WordPairs"),
          ),
          body: ListView(children: divided),
        );
      },
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPair Generator'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildList(),
    );
  }
}
