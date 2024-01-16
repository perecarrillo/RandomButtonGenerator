import 'dart:collection';
import 'dart:math';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';

Random rng = new Random();

(BorderSide, String) getRandomSide() {
  final BorderSide side = BorderSide(
    color: Colors.primaries[rng.nextInt(Colors.primaries.length)],
    strokeAlign: rng.nextDouble() * 2 - 1,
    style: rng.nextBool() ? BorderStyle.none : BorderStyle.solid,
    width: rng.nextDouble() * 3,
  );
  return (
    side,
    '\n    Color: ${side.color.value.toRadixString(16)}\n    StrokeAlign: ${side.strokeAlign.toStringAsPrecision(3)}\n    Style: ${side.style.toString().split('.')[1].toTitleCase()}\n    Width: ${side.width}'
  );
}

(OutlinedBorder?, String) getRandomShape() {
  final random = rng.nextInt(7);
  Map<String, String> values = new LinkedHashMap();
  OutlinedBorder? border;

  final (side, sideString) = getRandomSide();

  switch (random) {
    case 0:
      values['Type'] = 'BeveledRectangleBorder';
      final borderRadiusx = rng.nextDouble() * 2;
      final borderRadiusy = rng.nextDouble() * 2;
      values['BorderRadius'] =
          '${borderRadiusx.toStringAsPrecision(3)} x ${borderRadiusy.toStringAsPrecision(3)}';

      border = BeveledRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.elliptical(borderRadiusx, borderRadiusy)),
          side: side);
      break;
    case 1:
      values['Type'] = 'CircleBorder';
      final eccentricity = rng.nextDouble();
      values['Eccentricity'] = eccentricity.toStringAsPrecision(3);
      border = CircleBorder(eccentricity: eccentricity, side: side);
      break;
    case 2:
      values['Type'] = 'ContinuousRectangleBorder';

      final borderRadiusx = rng.nextDouble() * 2;
      final borderRadiusy = rng.nextDouble() * 2;
      values['BorderRadius'] =
          '${borderRadiusx.toStringAsPrecision(3)} x ${borderRadiusy.toStringAsPrecision(3)}';

      border = ContinuousRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.elliptical(borderRadiusx, borderRadiusy)),
        side: side,
      );
      break;
    case 3:
      values['Type'] = 'LinearBorder';
      final bottomAlignment = rng.nextDouble() * 2 - 1;
      final bottomSize = rng.nextDouble();
      values['BottomAlignment'] = bottomAlignment.toStringAsPrecision(3);
      values['BottomSize'] = bottomSize.toStringAsPrecision(3);

      final endAlignment = rng.nextDouble() * 2 - 1;
      final endSize = rng.nextDouble();
      values['EndAlignment'] = endAlignment.toStringAsPrecision(3);
      values['EndSize'] = endSize.toStringAsPrecision(3);

      final startAlignment = rng.nextDouble() * 2 - 1;
      final startSize = rng.nextDouble();
      values['StartAlignment'] = startAlignment.toStringAsPrecision(3);
      values['StartSize'] = startSize.toStringAsPrecision(3);

      final topAlignment = rng.nextDouble() * 2 - 1;
      final topSize = rng.nextDouble();
      values['TopAlignment'] = topAlignment.toStringAsPrecision(3);
      values['TopSize'] = topSize.toStringAsPrecision(3);

      border = LinearBorder(
        bottom: LinearBorderEdge(alignment: bottomAlignment, size: bottomSize),
        end: LinearBorderEdge(alignment: endAlignment, size: endSize),
        start: LinearBorderEdge(alignment: startAlignment, size: startSize),
        top: LinearBorderEdge(alignment: topAlignment, size: topSize),
        side: side,
      );
      break;
    case 4:
      values['Type'] = 'RoundedRectangleBorder';

      final borderRadiusx = rng.nextDouble() * 2;
      final borderRadiusy = rng.nextDouble() * 2;
      values['BorderRadius'] =
          '${borderRadiusx.toStringAsPrecision(3)} x ${borderRadiusy.toStringAsPrecision(3)}';

      border = RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.elliptical(borderRadiusx, borderRadiusy)),
        side: side,
      );
      break;
    case 5:
      values['Type'] = 'StadiumBorder';

      border = StadiumBorder(side: side);
      break;
    case 6:
      values['Type'] = 'StarBorder';
      final double sum = rng.nextDouble() - 0.0001;
      final double pointR = rng.nextDouble() * sum;
      final innerRadiusRatio = rng.nextDouble();
      final points = rng.nextInt(50) + 2;
      final rotation = rng.nextDouble() * 360;
      final squash = rng.nextDouble();
      values['InnerRadiusRatio'] = innerRadiusRatio.toStringAsPrecision(3);
      values['Points'] = points.toStringAsPrecision(3);
      values['PointRounding'] = pointR.toStringAsPrecision(3);
      values['Rotation'] = rotation.toStringAsPrecision(3);
      values['Squash'] = squash.toStringAsPrecision(3);
      values['ValleyRounding'] = (sum - pointR).toStringAsPrecision(3);

      border = StarBorder(
        side: side,
        innerRadiusRatio: rng.nextDouble(),
        pointRounding: pointR,
        points: rng.nextInt(50) + 2,
        rotation: rng.nextDouble() * 360,
        squash: rng.nextDouble(),
        valleyRounding: sum - pointR,
      );
      break;
    default:
      border = null;
  }

  values['Side'] = sideString;

  String string = '';

  for (MapEntry<String, String> i in values.entries) {
    string = '$string\n  ${i.key}: ${i.value}';
  }

  string = string.trim();
  return (border, string);
}

Color getRandomColor() {
  return Colors.primaries[rng.nextInt(Colors.primaries.length)];
}

Widget generateRandomButton(BuildContext context) {
  final Color backgroundColor = getRandomColor();
  final double elevation = rng.nextDouble() * 10;
  final Color foregroundColor = getRandomColor();
  final Color shadowColor = getRandomColor();
  final (OutlinedBorder? shape, String shapeString) = getRandomShape();
  return FilledButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text("Properties"),
            content: SizedBox(
              // width: MediaQuery.of(context).size.width,
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    title: Text("Background"),
                    subtitle:
                        Text('  #${backgroundColor.value.toRadixString(16)}'),
                    trailing:
                        Icon(Icons.square_rounded, color: backgroundColor),
                  ),
                  ListTile(
                    title: Text("Elevation"),
                    subtitle: Text('  ${elevation.toStringAsPrecision(3)}'),
                  ),
                  ListTile(
                    title: Text("Foreground"),
                    subtitle:
                        Text('  #${foregroundColor.value.toRadixString(16)}'),
                    trailing:
                        Icon(Icons.square_rounded, color: foregroundColor),
                  ),
                  ListTile(
                    title: Text("Shadow"),
                    subtitle: Text('  #${shadowColor.value.toRadixString(16)}'),
                    trailing: Icon(Icons.square_rounded, color: shadowColor),
                  ),
                  ListTile(
                    title: Text("Shape"),
                    subtitle: Text('  $shapeString'),
                    minVerticalPadding: 0,
                  ),
                ],
              ),
            )),
      );
    },
    style: FilledButton.styleFrom(
      backgroundColor: backgroundColor,
      elevation: elevation,
      foregroundColor: foregroundColor,
      shadowColor: shadowColor,
      shape: shape,
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
          buttons.add(generateRandomButton(context)); // Change This
        }

        return buttons[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Button Generator"),
        centerTitle: true,
      ),
      body: buildList(),
    );
  }
}
