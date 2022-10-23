import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key, required this.size});
  final String size;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool oTurn = true;
  List<String> show_X_O = [];

  var crossAxisCount;
  var itemCount;
  @override
  void initState() {
    super.initState();

    ///แปลง String ส่งมาเป็น int
    crossAxisCount = int.parse(widget.size);
    itemCount = crossAxisCount * crossAxisCount;
    //
    for (int i = 0; i < itemCount; i++) {
      show_X_O.add('');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(show_X_O.length);
    return Scaffold(
      body: Container(
          child: GridView.builder(
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount),
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                  onTap: () {
                    _tapped(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 5)),
                    child: Center(
                        child: Text(
                      show_X_O[index],
                      style: TextStyle(fontSize: 100),
                    )),
                  ),
                );
              })),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (oTurn && show_X_O[index] == '') {
        show_X_O[index] = 'O';
        oTurn = !oTurn;
      } else if (!oTurn && show_X_O[index] == '') {
        show_X_O[index] = 'X';
        oTurn = true;
      }

      _checjwinner();
    });
  }

  void _checjwinner() {
    //check row 1
    if (show_X_O[0] == show_X_O[1] &&
        show_X_O[0] == show_X_O[2] &&
        show_X_O[0] == show_X_O[3] &&
        show_X_O[0] != '') {
      print("winnerRow1");
    }
    //check row 2
    if (show_X_O[4] == show_X_O[5] &&
        show_X_O[4] == show_X_O[6] &&
        show_X_O[4] == show_X_O[7] &&
        show_X_O[4] != '') {
      print("winnerRow2");
    }
    //check row 3
    if (show_X_O[8] == show_X_O[9] &&
        show_X_O[8] == show_X_O[10] &&
        show_X_O[8] == show_X_O[11] &&
        show_X_O[8] != '') {
      print("winnerRow3");
    }
    //check row 4
    if (show_X_O[12] == show_X_O[13] &&
        show_X_O[12] == show_X_O[14] &&
        show_X_O[12] == show_X_O[15] &&
        show_X_O[12] != '') {
      print("winnerRow4");
    }

    //check Column 1
    if (show_X_O[0] == show_X_O[4] &&
        show_X_O[0] == show_X_O[8] &&
        show_X_O[0] == show_X_O[12] &&
        show_X_O[0] != '') {
      print("winnerColumn1");
    }
    //check Column 2
    if (show_X_O[4] == show_X_O[5] &&
        show_X_O[4] == show_X_O[6] &&
        show_X_O[4] == show_X_O[7] &&
        show_X_O[4] != '') {
      print("winnerColumn2");
    }
    //check Column 3
    if (show_X_O[8] == show_X_O[9] &&
        show_X_O[8] == show_X_O[6] &&
        show_X_O[8] == show_X_O[7] &&
        show_X_O[8] != '') {
      print("winnerColumn3");
    }
    //check Column 4
    if (show_X_O[4] == show_X_O[5] &&
        show_X_O[4] == show_X_O[6] &&
        show_X_O[4] == show_X_O[7] &&
        show_X_O[4] != '') {
      print("winnerColumn4");
    }

    //check Left to right
    if (show_X_O[0] == show_X_O[6] &&
        show_X_O[0] == show_X_O[10] &&
        show_X_O[0] == show_X_O[15] &&
        show_X_O[0] != '') {
      print("winnerLeft to right");
    }
    //check right to Left
    if (show_X_O[3] == show_X_O[6] &&
        show_X_O[3] == show_X_O[9] &&
        show_X_O[3] == show_X_O[12] &&
        show_X_O[3] != '') {
      print("winner right to Left ");
    }
  }
}
