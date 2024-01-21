import 'dart:math';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:localstore/localstore.dart';
import 'package:gradient_icon/gradient_icon.dart';

Random rng = new Random();

class RandomButtons extends StatefulWidget {
  const RandomButtons({super.key});

  @override
  RandomButtonsState createState() => RandomButtonsState();
}

class RandomButtonsState extends State<RandomButtons> {
  final db = Localstore.instance;
  // Color is stored as an integer, to get the Color simply do Color(button['color'])
  // BorderStyle is stored as a boolean, to get the BorderStyle do boolToBorderStyle(button['borderStyle'])
  final List<Map<String, dynamic>> buttons = [];

  // Key id is unique. same id as the one used for saving
  List<Map<String, dynamic>> favorites = [];

  bool filterOn = false;

  int? backgroundColor;
  int? shadowColor;
  int? borderColor;
  int? textColor;
  double? elevation;

  double getElevation() {
    return elevation ?? rng.nextDouble() * 10;
  }

  int getBackgroundColor() {
    return backgroundColor ?? getRandomColor();
  }

  int getShadowColor() {
    return shadowColor ?? getRandomColor();
  }

  int getBorderColor() {
    return borderColor ?? getRandomColor();
  }

  int getTextColor() {
    return textColor ?? getRandomColor();
  }

  int getRandomColor() {
    // return Colors.primaries[rng.nextInt(Colors.primaries.length)].value;
    return Color(Random().nextInt(0xFFFFFFFF))
        .withOpacity(Random().nextBool() && Random().nextBool()
            ? (Random().nextDouble() * 0.8) + 0.2
            : 1.0)
        .value;
  }

  Map<String, dynamic> getRandomSideAttributes() {
    Map<String, dynamic> attributes = new Map();
    attributes['color'] = getBorderColor();
    attributes['strokeAlign'] = rng.nextDouble() * 2 - 1;
    attributes['style'] = rng.nextBool();
    attributes['width'] = rng.nextDouble() * 3;
    return attributes;
  }

  BorderStyle boolToBorderStyle(bool border) {
    return border ? BorderStyle.solid : BorderStyle.none;
  }

  Map<String, dynamic> getRandomShapeAttributes() {
    final random = rng.nextInt(7);
    Map<String, dynamic> values = new Map();

    final Map<String, dynamic> side = getRandomSideAttributes();

    switch (random) {
      case 0:
        values['type'] = 'BeveledRectangleBorder';
        values['borderRadiusX'] = rng.nextDouble() * 2;
        values['borderRadiusY'] = rng.nextDouble() * 2;
        break;
      case 1:
        values['type'] = 'CircleBorder';
        values['eccentricity'] = rng.nextDouble();
        break;
      case 2:
        values['type'] = 'ContinuousRectangleBorder';
        values['borderRadiusX'] = rng.nextDouble() * 2;
        values['borderRadiusY'] = rng.nextDouble() * 2;
        break;
      case 3:
        values['type'] = 'LinearBorder';
        values['bottomAlignment'] = rng.nextDouble() * 2 - 1;
        values['bottomSize'] = rng.nextDouble();
        values['endAlignment'] = rng.nextDouble() * 2 - 1;
        values['endSize'] = rng.nextDouble();
        values['startAlignment'] = rng.nextDouble() * 2 - 1;
        values['startSize'] = rng.nextDouble();
        values['topAlignment'] = rng.nextDouble() * 2 - 1;
        values['topSize'] = rng.nextDouble();
        break;
      case 4:
        values['type'] = 'RoundedRectangleBorder';
        values['borderRadiusX'] = rng.nextDouble() * 2;
        values['borderRadiusY'] = rng.nextDouble() * 2;
        break;
      case 5:
        values['type'] = 'StadiumBorder';
        break;
      case 6:
        values['type'] = 'StarBorder';
        final double sum = rng.nextDouble() - 0.0001;
        final double pointR = rng.nextDouble() * sum;
        values['innerRadiusRatio'] = rng.nextDouble();
        values['points'] = (rng.nextInt(50) + 2).toDouble();
        values['pointRounding'] = pointR;
        values['rotation'] = rng.nextDouble() * 360;
        values['squash'] = rng.nextDouble();
        values['valleyRounding'] = (sum - pointR);
        break;
      default:
    }

    values['side'] = side;
    return values;
  }

  Map<String, dynamic> getRandomButtonAttributes(BuildContext context) {
    Map<String, dynamic> button = Map();

    button['backgroundColor'] = getBackgroundColor();
    button['elevation'] = getElevation();

    button['foregroundColor'] = getTextColor();
    button['shadowColor'] = getShadowColor();
    button['shape'] = getRandomShapeAttributes();

    return button;
  }

  BorderSide createSideFrom(Map<String, dynamic> side) {
    return BorderSide(
      color: Color(side['color']),
      strokeAlign: side['strokeAlign'],
      style: boolToBorderStyle(side['style']),
      width: side['width'],
    );
  }

  String sideToString(Map<String, dynamic> side) {
    return '\n    Color: #${side['color'].toRadixString(16)}\n    StrokeAlign: ${side['strokeAlign'].toStringAsPrecision(3)}\n    Style: ${(side['style'] ? BorderStyle.solid : BorderStyle.none).toString().split('.')[1].toTitleCase()}\n    Width: ${side['width'].toStringAsPrecision(3)}';
  }

  OutlinedBorder? createShapeFrom(Map<String, dynamic> shape) {
    OutlinedBorder? border;

    switch (shape['type']) {
      case 'BeveledRectangleBorder':
        border = BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(
                shape['borderRadiusX'], shape['borderRadiusY'])),
            side: createSideFrom(shape['side']));
        break;
      case 'CircleBorder':
        border = CircleBorder(
            eccentricity: shape['eccentricity'],
            side: createSideFrom(shape['side']));
        break;
      case 'ContinuousRectangleBorder':
        border = ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(
              shape['borderRadiusX'], shape['borderRadiusY'])),
          side: createSideFrom(shape['side']),
        );
        break;
      case 'LinearBorder':
        border = LinearBorder(
          bottom: LinearBorderEdge(
              alignment: shape['bottomAlignment'], size: shape['bottomSize']),
          end: LinearBorderEdge(
              alignment: shape['endAlignment'], size: shape['endSize']),
          start: LinearBorderEdge(
              alignment: shape['startAlignment'], size: shape['startSize']),
          top: LinearBorderEdge(
              alignment: shape['topAlignment'], size: shape['topSize']),
          side: createSideFrom(shape['side']),
        );
        break;
      case 'RoundedRectangleBorder':
        border = RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(
              shape['borderRadiusX'], shape['borderRadiusY'])),
          side: createSideFrom(shape['side']),
        );
        break;
      case 'StadiumBorder':
        border = StadiumBorder(side: createSideFrom(shape['side']));
        break;
      case 'StarBorder':
        border = StarBorder(
          side: createSideFrom(shape['side']),
          innerRadiusRatio: shape['innerRadiusRatio'],
          pointRounding: shape['pointRounding'],
          points: shape['points'],
          rotation: shape['rotation'],
          squash: shape['squash'],
          valleyRounding: shape['valleyRounding'],
        );
        break;
      default:
        border = null;
    }

    return border;
  }

  String shapeToString(Map<String, dynamic> shape) {
    String result = '';
    result += 'Type: ${shape['type']}\n';
    switch (shape['type']) {
      case 'BeveledRectangleBorder':
        result +=
            '  BorderRadius: ${shape['borderRadiusX'].toStringAsPrecision(3)} x ${shape['borderRadiusY'].toStringAsPrecision(3)}\n';
        break;
      case 'CircleBorder':
        result +=
            '  Eccentricity: ${shape['eccentricity'].toStringAsPrecision(3)}\n';
        break;
      case 'ContinuousRectangleBorder':
        result +=
            '  BorderRadius: ${shape['borderRadiusX'].toStringAsPrecision(3)} x ${shape['borderRadiusY'].toStringAsPrecision(3)}\n';
        break;
      case 'LinearBorder':
        result +=
            '  BottomAlignment: ${shape['bottomAlignment'].toStringAsPrecision(3)}\n  BottomSize: ${shape['bottomSize'].toStringAsPrecision(3)}\n  EndAlignment: ${shape['endAlignment'].toStringAsPrecision(3)}\n  EndSize: ${shape['endSize'].toStringAsPrecision(3)}\n  StartAlignment: ${shape['startAlignment'].toStringAsPrecision(3)}\n  StartSize: ${shape['startSize'].toStringAsPrecision(3)}\n  TopAlignment: ${shape['topAlignment'].toStringAsPrecision(3)}\n  TopSize: ${shape['topSize'].toStringAsPrecision(3)}\n';
        break;
      case 'RoundedRectangleBorder':
        result +=
            '  BorderRadius: ${shape['borderRadiusX'].toStringAsPrecision(3)} x ${shape['borderRadiusY'].toStringAsPrecision(3)}\n';
        break;
      case 'StadiumBorder':
        break;
      case 'StarBorder':
        result +=
            '  InnerRadiusRatio: ${shape['innerRadiusRatio'].toStringAsPrecision(3)}\n  Points: ${shape['points']}\n  PointRounding: ${shape['pointRounding'].toStringAsPrecision(3)}\n  Rotation: ${shape['rotation'].toStringAsPrecision(3)}\n  Squash: ${shape['squash'].toStringAsPrecision(3)}\n  ValleyRounding: ${shape['valleyRounding'].toStringAsPrecision(3)}\n';
        break;
      default:
    }
    result += '  Side: ${sideToString(shape['side'])}';

    return result;
  }

  Widget createButtonFrom(Map<String, dynamic> but,
      void Function(void Function())? parentSetState) {
    return FilledButton.tonal(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (dialogContext, dialogSetState) {
                final saved = favorites.contains(but);
                return AlertDialog(
                  title: const Text("Properties"),
                  content: SizedBox(
                    // width: MediaQuery.of(context).size.width,
                    width: double.maxFinite,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        const ListTile(
                          title: Text("Button Type"),
                          subtitle: Text("Filled Button"),
                        ),
                        ListTile(
                          title: const Text("Background"),
                          subtitle: Text(
                              '  #${but['backgroundColor'].toRadixString(16)}'),
                          trailing: Icon(Icons.square_rounded,
                              color: Color(but['backgroundColor'])),
                        ),
                        ListTile(
                          title: const Text("Elevation"),
                          subtitle: Text(
                              '  ${but['elevation'].toStringAsPrecision(3)}'),
                        ),
                        ListTile(
                          title: const Text("Foreground"),
                          subtitle: Text(
                              '  #${but['foregroundColor'].toRadixString(16)}'),
                          trailing: Icon(Icons.square_rounded,
                              color: Color(but['foregroundColor'])),
                        ),
                        ListTile(
                          title: const Text("Shadow"),
                          subtitle: Text(
                              '  #${but['shadowColor'].toRadixString(16)}'),
                          trailing: Icon(Icons.square_rounded,
                              color: Color(but['shadowColor'])),
                        ),
                        ListTile(
                          title: const Text("Shape"),
                          subtitle: Text('  ${shapeToString(but['shape'])}'),
                          minVerticalPadding: 0,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        func() =>
                            saved ? deleteFavorite(but) : addFavorite(but);

                        dialogSetState(func);
                        if (parentSetState != null) {
                          parentSetState(() {});
                        }
                      },
                      icon: Icon(
                        saved
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        color: saved ? Colors.red : null,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      style: FilledButton.styleFrom(
        backgroundColor: Color(but['backgroundColor']),
        elevation: but['elevation'],
        foregroundColor: Color(but['foregroundColor']),
        shadowColor: Color(but['shadowColor']),
        shape: createShapeFrom(but['shape']),
      ),
      child: const Text('Text'),
    );
  }

  // String buttonToString(Map<String, dynamic> button) {}

  Widget buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        if (index.isOdd) return const Divider();
        index = index ~/ 2;

        while (index >= buttons.length) {
          buttons.add(getRandomButtonAttributes(context));
        }

        return createButtonFrom(buttons[index], null);
      },
    );
  }

  void openSavedPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              final Iterable<ListTile> tiles = favorites.map(
                (i) => ListTile(
                  title: createButtonFrom(i, setState),
                ),
              );
              final List<Widget> divided =
                  ListTile.divideTiles(context: context, tiles: tiles).toList();

              return Scaffold(
                appBar: AppBar(title: const Text("Saved Buttons")),
                body: ListView(children: divided),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildFilterRow(
      BuildContext dialogContext, dialogSetState, String name, color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          child: const Text(
            "Reset",
            style: TextStyle(fontSize: 12),
          ),
          onPressed: () => dialogSetState(() => color[0] = null),
        ),
        Expanded(
          child: ListTile(
            title: Text(name),
            trailing: color[0] != null
                ? Icon(Icons.square_rounded, color: Color(color[0]!))
                : const GradientIcon(
                    offset: Offset.zero,
                    icon: Icons.square_rounded,
                    gradient: SweepGradient(colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.lightGreen,
                      Colors.green,
                      Colors.lightBlue,
                      Colors.blue,
                      Colors.purple
                    ]),
                  ),
            titleAlignment: ListTileTitleAlignment.center,
            onTap: () => showColorPicker(dialogContext, dialogSetState, color),
          ),
        ),
      ],
    );
  }

  void openFilterPage(globalContext, globalSetState) {
    // It is a list with a single element. Used to pass by reference and get result from showColorPicker
    var newBackgroundColor = [backgroundColor];
    var newShadowColor = [shadowColor];
    var newBorderColor = [borderColor];
    var newTextColor = [textColor];

    var newElevation = elevation;

    var textFieldController = TextEditingController();

    showDialog(
      barrierDismissible: false, // Save or Cancel, nothing else
      context: globalContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, dialogSetState) {
            return AlertDialog(
              title: const Text('Filter'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    buildFilterRow(dialogContext, dialogSetState,
                        "Background Color: ", newBackgroundColor),
                    buildFilterRow(dialogContext, dialogSetState,
                        "Text Color: ", newTextColor),
                    buildFilterRow(dialogContext, dialogSetState,
                        "Border Color: ", newBorderColor),
                    buildFilterRow(dialogContext, dialogSetState,
                        "Shadow Color: ", newShadowColor),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          child: const Text(
                            "Reset",
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () =>
                              dialogSetState(() => newElevation = null),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        const Text(
                          "Elevation: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Flexible(
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (value) {
                              newElevation =
                                  double.tryParse(value.replaceAll(',', '.'));
                            },
                            onSubmitted: (value) {
                              if (newElevation == null || newElevation! < 0) {
                                newElevation = null;
                                textFieldController.clear();
                              }
                            },
                            controller: textFieldController
                              ..text =
                                  newElevation?.toStringAsPrecision(3) ?? '',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(globalContext),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  child: const Text("Save"),
                  onPressed: () => globalSetState(() {
                    backgroundColor = newBackgroundColor[0];
                    borderColor = newBorderColor[0];
                    shadowColor = newShadowColor[0];
                    textColor = newTextColor[0];
                    if (newElevation == null || newElevation! >= 0) {
                      elevation = newElevation;
                    }
                    filterOn = !filterOn;
                    buttons.clear();
                    Navigator.pop(globalContext);
                  }),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Start is an array containing the variable that should be changed
  void showColorPicker(BuildContext context, parentSetState, start) {
    start[0] = start[0] ?? 0xFFFFFFFF;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
                pickerColor: Color(start[0]),
                onColorChanged: (color) =>
                    parentSetState(() => start[0] = color.value)),
            TextButton(
              child: Text('Select'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void deleteFavorite(but) {
    var id = but['id'];
    db.collection('favorites').doc(id).delete();
    favorites.remove(but);
  }

  void addFavorite(but) {
    but['id'] = getUniqueId('favorites');
    db.collection('favorites').doc(but['id']).set(but);

    favorites.insert(0, but);
  }

  // gets an unique id inside folder
  String getUniqueId(String folder) {
    return db.collection(folder).doc().id;
  }

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() {
    (db.collection('favorites').get()).then((value) => setState(() {
          value?.entries.forEach((element) {
            favorites.add(element.value);
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      // Estic bastant segur de q no caldria i es podria passar el context i setState globals...
      builder: (inContext, inSetState) => Scaffold(
        appBar: AppBar(
          title: const FittedBox(child: Text("Random Button Generator")),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: openSavedPage,
              icon: const Icon(
                Icons.favorite_border_rounded,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () => openFilterPage(inContext, setState),
            icon: Icon(filterOn
                ? Icons.filter_list_rounded
                : Icons.filter_list_off_rounded),
          ),
        ),
        body: buildList(),
      ),
    );
  }
}
