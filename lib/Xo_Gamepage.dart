import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xo_moble_app/Winner.dart';

class Xo_Gamepage extends StatefulWidget {
  const Xo_Gamepage({super.key, required this.size});
  final String size;

  @override
  State<Xo_Gamepage> createState() => _Xo_GamepageState();
}

class _Xo_GamepageState extends State<Xo_Gamepage> {
  //check display x o
  bool oTurn = true;
  List<String> show_X_O = [];

  List<int> matchIndex = [];
  static const maxscore = 30;
  int seconds = maxscore;
  Timer? timer;
  int attempts = 0;
  //check winner
  int oScore = 0;
  int xScore = 0;
  int fillbox = 0;
  String result = "";
  bool winnerFound = false;
  double fontSize = 0;

  //
  String size = "";

  var crossAxisCount;
  var itemCount;
  @override
  void initState() {
    super.initState();

    ///แปลง String ส่งมาเป็น int

    crossAxisCount = int.parse(widget.size);
    itemCount = crossAxisCount * crossAxisCount;

    for (int i = 0; i < itemCount; i++) {
      show_X_O.add('');
    }
    if (show_X_O.length <= 16) {
      setState(() {
        fontSize = 70;
      });
    } else {
      setState(() {
        fontSize = 50;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    _backgroundImage(),
                    Positioned(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              224,
                                                              242,
                                                              228),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                  child: const Icon(
                                                    Icons.arrow_back,
                                                    size: 30,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  _title(),
                                ]),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              color: Colors.yellow,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Player O",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(oScore.toString(), style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Player X", style: TextStyle(fontSize: 20)),
                      Text(xScore.toString(), style: TextStyle(fontSize: 20))
                    ],
                  ),
                )
              ]),
            ),
            Stack(
              children: [
                _backgroundImage2(),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: GridView.builder(
                          itemCount: itemCount,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return GestureDetector(
                              onTap: () {
                                _tapped(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          width: 5, color: Color(0xFFCC00)),
                                      color: matchIndex.contains(index)
                                          ? Colors.yellow
                                          : Colors.red),
                                  child: Center(
                                      child: Text(
                                    show_X_O[index],
                                    style: TextStyle(fontSize: fontSize),
                                  )),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 5),
                    Column(
                      children: [
                        Text(
                          result,
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        _buildTimer(),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _tapped(int index) {
    final isRuning = timer == null ? false : timer!.isActive;
    if (isRuning) {
      setState(() {
        if (oTurn && show_X_O[index] == '') {
          show_X_O[index] = 'O';
          fillbox++;
          oTurn = !oTurn;
        } else if (!oTurn && show_X_O[index] == '') {
          show_X_O[index] = 'X';
          fillbox++;
          oTurn = true;
        }
        if (show_X_O.length == 9) {
          _checkwinner3X3();
        } else if (show_X_O.length == 16) {
          _checkwinner4X4();
        } else {
          _checkwinner5X5();
        }
      });
      print(fillbox);
    }
  }

  Future<void> _checkwinner4X4() async {
    //check row 1
    if (show_X_O[0] == show_X_O[1] &&
        show_X_O[0] == show_X_O[2] &&
        show_X_O[0] == show_X_O[3] &&
        show_X_O[0] != '') {
      setState(() {
        result = 'Player ' + show_X_O[0] + ' Winner !!';
        _updateScore(show_X_O[0]);
        matchIndex.addAll([0, 1, 2, 3]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check row 2
    if (show_X_O[4] == show_X_O[5] &&
        show_X_O[4] == show_X_O[6] &&
        show_X_O[4] == show_X_O[7] &&
        show_X_O[4] != '') {
      setState(() {
        result = 'Player ' + show_X_O[4] + ' Winner !!';
        _updateScore(show_X_O[4]);
        matchIndex.addAll([4, 5, 6, 7]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check row 3
    if (show_X_O[8] == show_X_O[9] &&
        show_X_O[8] == show_X_O[10] &&
        show_X_O[8] == show_X_O[11] &&
        show_X_O[8] != '') {
      setState(() {
        result = 'Player ' + show_X_O[8] + ' Winner !!';
        _updateScore(show_X_O[8]);
        matchIndex.addAll([8, 9, 10, 11]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check row 4
    if (show_X_O[12] == show_X_O[13] &&
        show_X_O[12] == show_X_O[14] &&
        show_X_O[12] == show_X_O[15] &&
        show_X_O[12] != '') {
      setState(() {
        result = 'Player ' + show_X_O[12] + ' Winner !!';
        _updateScore(show_X_O[0]);
        matchIndex.addAll([12, 13, 14, 15]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }

    //check Column 1
    if (show_X_O[0] == show_X_O[4] &&
        show_X_O[0] == show_X_O[8] &&
        show_X_O[0] == show_X_O[12] &&
        show_X_O[0] != '') {
      setState(() {
        result = 'Player ' + show_X_O[0] + ' Winner !!';
        _updateScore(show_X_O[0]);
        matchIndex.addAll([0, 4, 8, 12]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 2
    if (show_X_O[1] == show_X_O[5] &&
        show_X_O[1] == show_X_O[9] &&
        show_X_O[1] == show_X_O[13] &&
        show_X_O[1] != '') {
      setState(() {
        result = 'Player ' + show_X_O[1] + ' Winner !!';
        _updateScore(show_X_O[1]);
        matchIndex.addAll([1, 5, 9, 13]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 3
    if (show_X_O[2] == show_X_O[6] &&
        show_X_O[2] == show_X_O[10] &&
        show_X_O[2] == show_X_O[14] &&
        show_X_O[2] != '') {
      setState(() {
        result = 'Player ' + show_X_O[2] + ' Winner !!';
        _updateScore(show_X_O[0]);
        matchIndex.addAll([2, 6, 10, 14]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 4
    if (show_X_O[3] == show_X_O[7] &&
        show_X_O[3] == show_X_O[11] &&
        show_X_O[3] == show_X_O[15] &&
        show_X_O[3] != '') {
      setState(() {
        result = 'Player ' + show_X_O[3] + ' Winner !!';
        _updateScore(show_X_O[0]);
        matchIndex.addAll([3, 7, 11, 15]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }

    //check Left to right
    if (show_X_O[0] == show_X_O[5] &&
        show_X_O[0] == show_X_O[10] &&
        show_X_O[0] == show_X_O[15] &&
        show_X_O[0] != '') {
      setState(() {
        result = 'Player ' + show_X_O[0] + ' Winner !!';
        _updateScore(show_X_O[0]);
        matchIndex.addAll([0, 5, 10, 15]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check right to Left
    if (show_X_O[3] == show_X_O[6] &&
        show_X_O[3] == show_X_O[9] &&
        show_X_O[3] == show_X_O[12] &&
        show_X_O[3] != '') {
      setState(() {
        result = 'Player ' + show_X_O[3] + ' Winner !!';
        _updateScore(show_X_O[0]);
        matchIndex.addAll([3, 6, 9, 12]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }

    if (!winnerFound && fillbox == 16) {
      setState(() {
        result = 'Draw !!';
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    if (seconds == 0) {
      setState(() {
        result = 'Draw !!';
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
  }

  Future<void> _checkwinner3X3() async {
    //check row 1
    if (show_X_O[0] == show_X_O[1] &&
        show_X_O[0] == show_X_O[2] &&
        show_X_O[0] != '') {
      setState(() {
        result = 'Player ' + show_X_O[0] + ' Winner !!';
        matchIndex.addAll([0, 1, 2]);
        stopTimer();
        _updateScore(show_X_O[0]);
      });
      size = size = widget.size;
      //await DatabaseHelper.instance.add(Winner(winner: result, size: size));
      DatabaseHelper.instance
          .add2(Winner(winner: result, size: size), show_X_O);
    }
    //check row 2
    if (show_X_O[3] == show_X_O[4] &&
        show_X_O[3] == show_X_O[5] &&
        show_X_O[3] != '') {
      setState(() {
        result = 'Player ' + show_X_O[3] + ' Winner !!';
        matchIndex.addAll([3, 4, 5]);
        stopTimer();
        _updateScore(show_X_O[3]);
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check row 3
    if (show_X_O[6] == show_X_O[7] &&
        show_X_O[6] == show_X_O[8] &&
        show_X_O[6] != '') {
      setState(() {
        result = 'Player ' + show_X_O[6] + ' Winner !!';
        matchIndex.addAll([6, 7, 8]);
        stopTimer();
        _updateScore(show_X_O[6]);
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 1
    if (show_X_O[0] == show_X_O[3] &&
        show_X_O[0] == show_X_O[6] &&
        show_X_O[0] != '') {
      setState(() {
        result = 'Player ' + show_X_O[0] + ' Winner !!';
        matchIndex.addAll([0, 3, 6]);
        stopTimer();
        _updateScore(show_X_O[0]);
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 2
    if (show_X_O[1] == show_X_O[4] &&
        show_X_O[1] == show_X_O[7] &&
        show_X_O[1] != '') {
      setState(() {
        result = 'Player ' + show_X_O[1] + ' Winner !!';
        matchIndex.addAll([1, 4, 7]);
        stopTimer();
        _updateScore(show_X_O[1]);
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 3
    if (show_X_O[2] == show_X_O[5] &&
        show_X_O[2] == show_X_O[8] &&
        show_X_O[2] != '') {
      setState(() {
        result = 'Player ' + show_X_O[2] + ' Winner !!';
        matchIndex.addAll([2, 5, 8]);
        stopTimer();
        _updateScore(show_X_O[2]);
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check left to right
    if (show_X_O[0] == show_X_O[4] &&
        show_X_O[0] == show_X_O[8] &&
        show_X_O[0] != '') {
      setState(() {
        result = 'Player ' + show_X_O[0] + ' Winner !!';
        matchIndex.addAll([0, 4, 8]);
        stopTimer();
        _updateScore(show_X_O[0]);
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check right to left
    if (show_X_O[2] == show_X_O[4] &&
        show_X_O[2] == show_X_O[6] &&
        show_X_O[2] != '') {
      setState(() {
        result = 'Player ' + show_X_O[2] + ' Winner !!';
        matchIndex.addAll([2, 4, 6]);
        stopTimer();
        _updateScore(show_X_O[2]);
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }

    if (!winnerFound && fillbox == 9) {
      setState(() {
        result = 'Draw  !!';
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }

    if (seconds == 0) {
      setState(() {
        result = 'Draw !!';
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
  }

  Future<void> _checkwinner5X5() async {
    //check row 1
    if (show_X_O[0] == show_X_O[1] &&
        show_X_O[0] == show_X_O[2] &&
        show_X_O[0] == show_X_O[3] &&
        show_X_O[0] == show_X_O[4] &&
        show_X_O[0] != '') {
      setState(() {
        result = 'Player ' + show_X_O[0] + ' Winner !!';
        _updateScore(show_X_O[0]);
        matchIndex.addAll([0, 1, 2, 3, 4]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check row 2
    if (show_X_O[5] == show_X_O[6] &&
        show_X_O[5] == show_X_O[7] &&
        show_X_O[5] == show_X_O[8] &&
        show_X_O[5] == show_X_O[9] &&
        show_X_O[5] != '') {
      setState(() {
        result = 'Player ' + show_X_O[5] + ' Winner !!';
        _updateScore(show_X_O[5]);
        matchIndex.addAll([5, 6, 7, 8, 9]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check row 3
    if (show_X_O[10] == show_X_O[11] &&
        show_X_O[10] == show_X_O[12] &&
        show_X_O[10] == show_X_O[13] &&
        show_X_O[10] == show_X_O[14] &&
        show_X_O[10] != '') {
      setState(() {
        result = 'Player ' + show_X_O[1] + ' Winner !!';
        _updateScore(show_X_O[10]);
        matchIndex.addAll([10, 11, 12, 13, 14]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check row 4
    if (show_X_O[15] == show_X_O[16] &&
        show_X_O[15] == show_X_O[17] &&
        show_X_O[15] == show_X_O[18] &&
        show_X_O[15] == show_X_O[19] &&
        show_X_O[15] != '') {
      setState(() {
        result = 'Player ' + show_X_O[15] + ' Winner !!';
        _updateScore(show_X_O[15]);
        matchIndex.addAll([15, 16, 17, 18, 19]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check row 5
    if (show_X_O[20] == show_X_O[21] &&
        show_X_O[20] == show_X_O[22] &&
        show_X_O[20] == show_X_O[23] &&
        show_X_O[20] == show_X_O[24] &&
        show_X_O[20] != '') {
      setState(() {
        result = 'Player ' + show_X_O[20] + ' Winner !!';
        _updateScore(show_X_O[20]);
        matchIndex.addAll([20, 21, 22, 23, 24]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 1
    if (show_X_O[0] == show_X_O[5] &&
        show_X_O[0] == show_X_O[10] &&
        show_X_O[0] == show_X_O[15] &&
        show_X_O[0] == show_X_O[20] &&
        show_X_O[0] != '') {
      setState(() {
        result = 'Player ' + show_X_O[0] + ' Winner !!';
        _updateScore(show_X_O[6]);
        matchIndex.addAll([0, 5, 10, 15, 20]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 2
    if (show_X_O[1] == show_X_O[6] &&
        show_X_O[1] == show_X_O[11] &&
        show_X_O[1] == show_X_O[16] &&
        show_X_O[1] == show_X_O[21] &&
        show_X_O[1] != '') {
      setState(() {
        result = 'Player ' + show_X_O[1] + ' Winner !!';
        _updateScore(show_X_O[1]);
        matchIndex.addAll([1, 6, 11, 16, 21]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 3
    if (show_X_O[2] == show_X_O[7] &&
        show_X_O[2] == show_X_O[12] &&
        show_X_O[2] == show_X_O[17] &&
        show_X_O[2] == show_X_O[22] &&
        show_X_O[2] != '') {
      setState(() {
        result = 'Player ' + show_X_O[2] + ' Winner !!';
        _updateScore(show_X_O[2]);
        matchIndex.addAll([2, 7, 12, 17, 22]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 4
    if (show_X_O[3] == show_X_O[5] &&
        show_X_O[3] == show_X_O[10] &&
        show_X_O[3] == show_X_O[15] &&
        show_X_O[3] == show_X_O[20] &&
        show_X_O[3] != '') {
      setState(() {
        result = 'Player ' + show_X_O[3] + ' Winner !!';
        _updateScore(show_X_O[3]);
        matchIndex.addAll([3, 5, 10, 15, 20]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check Column 5
    if (show_X_O[4] == show_X_O[9] &&
        show_X_O[4] == show_X_O[14] &&
        show_X_O[4] == show_X_O[19] &&
        show_X_O[4] == show_X_O[24] &&
        show_X_O[4] != '') {
      setState(() {
        result = 'Player ' + show_X_O[4] + ' Winner !!';
        _updateScore(show_X_O[4]);
        matchIndex.addAll([9, 14, 19, 24]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check left to right
    if (show_X_O[0] == show_X_O[6] &&
        show_X_O[0] == show_X_O[12] &&
        show_X_O[0] == show_X_O[18] &&
        show_X_O[0] == show_X_O[24] &&
        show_X_O[0] != '') {
      setState(() {
        result = 'Player ' + show_X_O[0] + ' Winner !!';
        _updateScore(show_X_O[0]);
        matchIndex.addAll([6, 12, 18, 24]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    //check right to left
    if (show_X_O[4] == show_X_O[8] &&
        show_X_O[4] == show_X_O[12] &&
        show_X_O[4] == show_X_O[16] &&
        show_X_O[4] == show_X_O[20] &&
        show_X_O[4] != '') {
      setState(() {
        result = 'Player ' + show_X_O[4] + ' Winner !!';
        _updateScore(show_X_O[4]);
        matchIndex.addAll([4, 8, 12, 16, 20]);
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    if (!winnerFound && fillbox == 25) {
      setState(() {
        result = 'Draw !!';
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
    if (seconds == 0) {
      setState(() {
        result = 'Draw !!';
        stopTimer();
      });
      await DatabaseHelper.instance.add(Winner(winner: result));
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      if (show_X_O.length == 9) {
        for (int i = 0; i < 9; i++) {
          show_X_O[i] = '';
        }

        for (int i = 0; i < 9; i++) {
          matchIndex.remove(i);
        }
      } else if (show_X_O.length == 16) {
        for (int i = 0; i < 16; i++) {
          show_X_O[i] = '';
        }

        for (int i = 0; i < 16; i++) {
          matchIndex.remove(i);
        }
      } else {
        for (int i = 0; i < 25; i++) {
          show_X_O[i] = '';
        }

        for (int i = 0; i < 25; i++) {
          matchIndex.remove(i);
        }
      }
    });
    fillbox = 0;
    result = '';
    winnerFound = false;
    oTurn = true;
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        if (mounted)
          setState(() {
            seconds--;
          });
      } else if (seconds < 1) {
        if (mounted)
          setState(() {
            result = "draw !!";
          });
        stopTimer();
      }
    });
  }

  void stopTimer() {
    restartTimer();
    timer?.cancel();
  }

  void restartTimer() {
    seconds = maxscore;
  }

  Widget _buildTimer() {
    final isRuning = timer == null ? false : timer!.isActive;
    return isRuning
        ? SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxscore,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  backgroundColor: Color.fromARGB(255, 225, 15, 15),
                ),
                Center(
                  child: Text(
                    seconds.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 50),
                  ),
                )
              ],
            ),
          )
        : Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    startTimer();
                    _clearBoard();
                    attempts++;
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                  ),
                  child: Text(
                    attempts == 0 ? 'Start' : "Play Again",
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                  )),
            ],
          );
  }

  Widget _title() {
    return Text(
      "Welcome To Xo Game",
      style: TextStyle(
        color: Colors.red,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _backgroundImage() {
    return Stack(
      children: [
        /*
        Image(
          height: 70,
          width: 410,
          image: AssetImage('images/Clouds.jpg'),
          fit: BoxFit.fill,
        ),*/
        Positioned(
          child: Container(
            width: 411,
            height: 80,
            color: Colors.black,
          ),
        )
      ],

      //
    );
  }

  Widget _backgroundImage2() {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: 411,
            height: 557,
            color: Colors.black,
          ),
        )
      ],

      //
    );
  }

  Widget _backgroundImage3() {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: 411,
            height: 132,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
