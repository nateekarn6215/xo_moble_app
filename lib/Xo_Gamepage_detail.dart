import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xo_moble_app/Homepage.dart';
import 'package:xo_moble_app/Winner.dart';

class Xo_Gamepage_detail extends StatefulWidget {
  const Xo_Gamepage_detail(
      {super.key, required this.size, this.id, this.result});
  final String size;
  final String? id;
  final String? result;

  @override
  State<Xo_Gamepage_detail> createState() => _Xo_Gamepage_detailState();
}

class _Xo_Gamepage_detailState extends State<Xo_Gamepage_detail> {
  //check display x o
  bool oTurn = true;
  List<String> show_X_O = [];
  List<String> test = [];

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

  List<Condition> ListCondition = [];

  //
  String size = "";

  var crossAxisCount;
  var itemCount;
  @override
  void initState() {
    super.initState();
    init();

    ///แปลง String ส่งมาเป็น int

    crossAxisCount = int.parse(widget.size);
    setState(() {
      itemCount = crossAxisCount * crossAxisCount;
    });

    if (itemCount <= 16) {
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
                        widget.result.toString(),
                        style: TextStyle(fontSize: 39),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            if (show_X_O.isNotEmpty)
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
                                  //_tapped(index);
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
                        ],
                      )
                    ],
                  ),
                ],
              )
            else
              SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      "history Xo Game",
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

  Future init() async {
    ListCondition = await DatabaseHelper.instance.getCondition(widget.id);
    List<int> symbol_x = [];
    List<int> symbol_O = [];
    for (int i = 0; i < ListCondition.length; i++) {
      if (ListCondition[i].symbol.toString() == "") {
        setState(() {
          show_X_O.add("");
        });
      } else {
        setState(() {
          show_X_O.add(ListCondition[i].symbol.toString());
        });
        if (ListCondition[i].symbol == "X") {
          symbol_x.add(i);
        } else if ((ListCondition[i].symbol == "O")) {
          symbol_O.add(i);
        }
      }
    }
    if (symbol_O.length > symbol_x.length) {
      if (itemCount == 9) {
        //row1
        if (show_X_O[0] == "O" && show_X_O[1] == "O" && show_X_O[2] == "O") {
          setState(() {
            matchIndex = [0, 1, 2];
          });
          //row2
        } else if (show_X_O[3] == "O" &&
            show_X_O[4] == "O" &&
            show_X_O[5] == "O") {
          setState(() {
            matchIndex = [3, 4, 5];
          });
          //row3
        } else if (show_X_O[6] == "O" &&
            show_X_O[7] == "O" &&
            show_X_O[8] == "O") {
          setState(() {
            matchIndex = [6, 7, 8];
          });
          //column 1
        } else if (show_X_O[0] == "O" &&
            show_X_O[3] == "O" &&
            show_X_O[6] == "O") {
          setState(() {
            matchIndex = [0, 3, 6];
          });
          //column 2
        } else if (show_X_O[1] == "O" &&
            show_X_O[4] == "O" &&
            show_X_O[7] == "O") {
          setState(() {
            matchIndex = [1, 4, 7];
          });
          //column 3
        } else if (show_X_O[2] == "O" &&
            show_X_O[5] == "O" &&
            show_X_O[8] == "O") {
          setState(() {
            matchIndex = [2, 5, 8];
          });
          //left to right
        } else if (show_X_O[0] == "O" &&
            show_X_O[4] == "O" &&
            show_X_O[8] == "O") {
          setState(() {
            matchIndex = [0, 4, 8];
          });
          //right  to  left
        } else if (show_X_O[2] == "O" &&
            show_X_O[4] == "O" &&
            show_X_O[6] == "O") {
          setState(() {
            matchIndex = [2, 4, 6];
          });
        }
      } else if (itemCount == 16) {
        //row1
        if (show_X_O[0] == "O" &&
            show_X_O[1] == "O" &&
            show_X_O[2] == "O" &&
            show_X_O[3] == "O") {
          setState(() {
            matchIndex = [0, 1, 2, 3];
          });
          //row2
        } else if (show_X_O[4] == "O" &&
            show_X_O[5] == "O" &&
            show_X_O[6] == "O" &&
            show_X_O[7] == "O") {
          setState(() {
            matchIndex = [4, 5, 6, 7];
          });
          //row3
        } else if (show_X_O[8] == "O" &&
            show_X_O[9] == "O" &&
            show_X_O[10] == "O" &&
            show_X_O[11] == "O") {
          setState(() {
            matchIndex = [8, 9, 10, 11];
          });
          //row4
        } else if (show_X_O[12] == "O" &&
            show_X_O[13] == "O" &&
            show_X_O[14] == "O" &&
            show_X_O[15] == "O") {
          setState(() {
            matchIndex = [12, 13, 14, 15];
          });
          //column 1
        } else if (show_X_O[0] == "O" &&
            show_X_O[4] == "O" &&
            show_X_O[8] == "O" &&
            show_X_O[12] == "O") {
          setState(() {
            matchIndex = [0, 4, 8, 12];
          });
          //column 2
        } else if (show_X_O[1] == "O" &&
            show_X_O[5] == "O" &&
            show_X_O[9] == "O" &&
            show_X_O[13] == "O") {
          setState(() {
            matchIndex = [1, 5, 9, 13];
          });
          //column 3
        } else if (show_X_O[2] == "O" &&
            show_X_O[6] == "O" &&
            show_X_O[10] == "O" &&
            show_X_O[14] == "O") {
          setState(() {
            matchIndex = [2, 6, 10, 14];
          });
          //column 4
        } else if (show_X_O[3] == "O" &&
            show_X_O[7] == "O" &&
            show_X_O[11] == "O" &&
            show_X_O[15] == "O") {
          setState(() {
            matchIndex = [3, 7, 11, 15];
          });
          //left to right
        } else if (show_X_O[0] == "O" &&
            show_X_O[5] == "O" &&
            show_X_O[10] == "O" &&
            show_X_O[15] == "O") {
          setState(() {
            matchIndex = [0, 5, 10, 15];
          });
          //right  to  left
        } else if (show_X_O[3] == "O" &&
            show_X_O[6] == "O" &&
            show_X_O[9] == "O" &&
            show_X_O[12] == "O") {
          setState(() {
            matchIndex = [3, 6, 9, 12];
          });
        }
      } else {
        //row1
        if (show_X_O[0] == "O" &&
            show_X_O[1] == "O" &&
            show_X_O[2] == "O" &&
            show_X_O[3] == "O" &&
            show_X_O[4] == "O") {
          setState(() {
            matchIndex = [0, 1, 2, 3, 4];
          });
          //row2
        } else if (show_X_O[5] == "O" &&
            show_X_O[6] == "O" &&
            show_X_O[7] == "O" &&
            show_X_O[8] == "O" &&
            show_X_O[9] == "O") {
          setState(() {
            matchIndex = [5, 6, 7, 8, 9];
          });
          //row3
        } else if (show_X_O[10] == "O" &&
            show_X_O[11] == "O" &&
            show_X_O[12] == "O" &&
            show_X_O[13] == "O" &&
            show_X_O[14] == "O") {
          setState(() {
            matchIndex = [10, 11, 12, 13, 14];
          });
          //row4
        } else if (show_X_O[15] == "O" &&
            show_X_O[16] == "O" &&
            show_X_O[17] == "O" &&
            show_X_O[18] == "O" &&
            show_X_O[19] == "O") {
          setState(() {
            matchIndex = [15, 16, 17, 18, 19];
          });
          //row 5
        } else if (show_X_O[20] == "O" &&
            show_X_O[21] == "O" &&
            show_X_O[22] == "O" &&
            show_X_O[23] == "O" &&
            show_X_O[24] == "O") {
          setState(() {
            matchIndex = [20, 21, 22, 23, 24];
          });
          //column 1
        } else if (show_X_O[0] == "O" &&
            show_X_O[5] == "O" &&
            show_X_O[10] == "O" &&
            show_X_O[15] == "O" &&
            show_X_O[20] == "O") {
          setState(() {
            matchIndex = [0, 5, 10, 15, 20];
          });
          //column 2
        } else if (show_X_O[1] == "O" &&
            show_X_O[6] == "O" &&
            show_X_O[11] == "O" &&
            show_X_O[16] == "O" &&
            show_X_O[21] == "O") {
          setState(() {
            matchIndex = [1, 6, 11, 16, 21];
          });
          //column 3
        } else if (show_X_O[2] == "O" &&
            show_X_O[7] == "O" &&
            show_X_O[12] == "O" &&
            show_X_O[17] == "O" &&
            show_X_O[22] == "O") {
          setState(() {
            matchIndex = [2, 7, 12, 17, 22];
          });
          //column 4
        } else if (show_X_O[3] == "O" &&
            show_X_O[8] == "O" &&
            show_X_O[13] == "O" &&
            show_X_O[18] == "O" &&
            show_X_O[23] == "O") {
          setState(() {
            matchIndex = [3, 8, 13, 18, 23];
          });
          //column 5
        } else if (show_X_O[4] == "O" &&
            show_X_O[9] == "O" &&
            show_X_O[14] == "O" &&
            show_X_O[19] == "O" &&
            show_X_O[24] == "O") {
          setState(() {
            matchIndex = [4, 9, 14, 19, 24];
          });
          //left to right
        } else if (show_X_O[0] == "O" &&
            show_X_O[6] == "O" &&
            show_X_O[12] == "O" &&
            show_X_O[18] == "O" &&
            show_X_O[24] == "O") {
          setState(() {
            matchIndex = [0, 6, 12, 18, 24];
          });
          //right  to  left
        } else if (show_X_O[4] == "O" &&
            show_X_O[8] == "O" &&
            show_X_O[12] == "O" &&
            show_X_O[16] == "O" &&
            show_X_O[20] == "O") {
          setState(() {
            matchIndex = [4, 8, 12, 16, 20];
          });
        }
      }
    } else if (symbol_x.length > symbol_O.length) {
      if (itemCount == 9) {
        //row1
        if (show_X_O[0] == "X" && show_X_O[1] == "X" && show_X_O[2] == "X") {
          setState(() {
            matchIndex = [0, 1, 2];
          });
          //row2
        } else if (show_X_O[3] == "X" &&
            show_X_O[4] == "X" &&
            show_X_O[5] == "X") {
          setState(() {
            matchIndex = [3, 4, 5];
          });
          //row3
        } else if (show_X_O[6] == "X" &&
            show_X_O[7] == "X" &&
            show_X_O[8] == "X") {
          setState(() {
            matchIndex = [6, 7, 8];
          });
          //column 1
        } else if (show_X_O[0] == "X" &&
            show_X_O[3] == "X" &&
            show_X_O[6] == "X") {
          setState(() {
            matchIndex = [0, 3, 6];
          });
          //column 2
        } else if (show_X_O[1] == "X" &&
            show_X_O[4] == "X" &&
            show_X_O[7] == "X") {
          setState(() {
            matchIndex = [1, 4, 7];
          });
          //column 3
        } else if (show_X_O[2] == "X" &&
            show_X_O[5] == "X" &&
            show_X_O[8] == "X") {
          setState(() {
            matchIndex = [2, 5, 8];
          });
          //left to right
        } else if (show_X_O[0] == "X" &&
            show_X_O[4] == "X" &&
            show_X_O[8] == "X") {
          setState(() {
            matchIndex = [0, 4, 8];
          });
          //right  to  left
        } else if (show_X_O[2] == "X" &&
            show_X_O[4] == "X" &&
            show_X_O[6] == "X") {
          setState(() {
            matchIndex = [2, 4, 6];
          });
        }
      } else if (itemCount == 16) {
        //row1
        if (show_X_O[0] == "X" &&
            show_X_O[1] == "X" &&
            show_X_O[2] == "X" &&
            show_X_O[3] == "X") {
          setState(() {
            matchIndex = [0, 1, 2, 3];
          });
          //row2
        } else if (show_X_O[4] == "X" &&
            show_X_O[5] == "X" &&
            show_X_O[6] == "X" &&
            show_X_O[7] == "X") {
          setState(() {
            matchIndex = [4, 5, 6, 7];
          });
          //row3
        } else if (show_X_O[8] == "X" &&
            show_X_O[9] == "X" &&
            show_X_O[10] == "X" &&
            show_X_O[11] == "X") {
          setState(() {
            matchIndex = [8, 9, 10, 11];
          });
          //row4
        } else if (show_X_O[12] == "X" &&
            show_X_O[13] == "X" &&
            show_X_O[14] == "X" &&
            show_X_O[15] == "X") {
          setState(() {
            matchIndex = [12, 13, 14, 15];
          });
          //column 1
        } else if (show_X_O[0] == "X" &&
            show_X_O[4] == "X" &&
            show_X_O[8] == "X" &&
            show_X_O[12] == "X") {
          setState(() {
            matchIndex = [0, 4, 8, 12];
          });
          //column 2
        } else if (show_X_O[1] == "X" &&
            show_X_O[5] == "X" &&
            show_X_O[9] == "X" &&
            show_X_O[13] == "X") {
          setState(() {
            matchIndex = [1, 5, 9, 13];
          });
          //column 3
        } else if (show_X_O[2] == "X" &&
            show_X_O[6] == "X" &&
            show_X_O[10] == "X" &&
            show_X_O[14] == "X") {
          setState(() {
            matchIndex = [2, 6, 10, 14];
          });
          //column 4
        } else if (show_X_O[3] == "X" &&
            show_X_O[7] == "X" &&
            show_X_O[11] == "X" &&
            show_X_O[15] == "X") {
          setState(() {
            matchIndex = [3, 7, 11, 15];
          });
          //left to right
        } else if (show_X_O[0] == "X" &&
            show_X_O[5] == "X" &&
            show_X_O[10] == "X" &&
            show_X_O[15] == "X") {
          setState(() {
            matchIndex = [0, 5, 10, 15];
          });
          //right  to  left
        } else if (show_X_O[3] == "X" &&
            show_X_O[6] == "X" &&
            show_X_O[9] == "X" &&
            show_X_O[12] == "X") {
          setState(() {
            matchIndex = [3, 6, 9, 12];
          });
        }
      } else {
        if (show_X_O[0] == "X" &&
            show_X_O[1] == "X" &&
            show_X_O[2] == "X" &&
            show_X_O[3] == "X" &&
            show_X_O[4] == "X") {
          setState(() {
            matchIndex = [0, 1, 2, 3, 4];
          });
          //row2
        } else if (show_X_O[5] == "X" &&
            show_X_O[6] == "X" &&
            show_X_O[7] == "X" &&
            show_X_O[8] == "X" &&
            show_X_O[9] == "X") {
          setState(() {
            matchIndex = [5, 6, 7, 8, 9];
          });
          //row3
        } else if (show_X_O[10] == "X" &&
            show_X_O[11] == "X" &&
            show_X_O[12] == "X" &&
            show_X_O[13] == "X" &&
            show_X_O[14] == "X") {
          setState(() {
            matchIndex = [10, 11, 12, 13, 14];
          });
          //row4
        } else if (show_X_O[15] == "X" &&
            show_X_O[16] == "X" &&
            show_X_O[17] == "X" &&
            show_X_O[18] == "X" &&
            show_X_O[19] == "X") {
          setState(() {
            matchIndex = [15, 16, 17, 18, 19];
          });
          //row 5
        } else if (show_X_O[20] == "X" &&
            show_X_O[21] == "X" &&
            show_X_O[22] == "X" &&
            show_X_O[23] == "X" &&
            show_X_O[24] == "X") {
          setState(() {
            matchIndex = [20, 21, 22, 23, 24];
          });
          //column 1
        } else if (show_X_O[0] == "X" &&
            show_X_O[5] == "X" &&
            show_X_O[10] == "X" &&
            show_X_O[15] == "X" &&
            show_X_O[20] == "X") {
          setState(() {
            matchIndex = [0, 5, 10, 15, 20];
          });
          //column 2
        } else if (show_X_O[1] == "X" &&
            show_X_O[6] == "X" &&
            show_X_O[11] == "X" &&
            show_X_O[16] == "X" &&
            show_X_O[21] == "X") {
          setState(() {
            matchIndex = [1, 6, 11, 16, 21];
          });
          //column 3
        } else if (show_X_O[2] == "X" &&
            show_X_O[7] == "X" &&
            show_X_O[12] == "X" &&
            show_X_O[17] == "X" &&
            show_X_O[22] == "X") {
          setState(() {
            matchIndex = [2, 7, 12, 17, 22];
          });
          //column 4
        } else if (show_X_O[3] == "X" &&
            show_X_O[8] == "X" &&
            show_X_O[13] == "X" &&
            show_X_O[18] == "X" &&
            show_X_O[23] == "X") {
          setState(() {
            matchIndex = [3, 8, 13, 18, 23];
          });
          //left to right
        } else if (show_X_O[4] == "X" &&
            show_X_O[9] == "X" &&
            show_X_O[14] == "X" &&
            show_X_O[19] == "X" &&
            show_X_O[24] == "X") {
          setState(() {
            matchIndex = [4, 9, 14, 19, 24];
          });
          //left to right
        } else if (show_X_O[0] == "X" &&
            show_X_O[6] == "X" &&
            show_X_O[12] == "X" &&
            show_X_O[18] == "X" &&
            show_X_O[24] == "X") {
          setState(() {
            matchIndex = [0, 6, 12, 18, 24];
          });
          //right  to  left
        } else if (show_X_O[4] == "X" &&
            show_X_O[8] == "X" &&
            show_X_O[12] == "X" &&
            show_X_O[16] == "X" &&
            show_X_O[20] == "X") {
          setState(() {
            matchIndex = [4, 8, 12, 16, 20];
          });
        }
      }
    } else if (symbol_x.length == symbol_O.length) {
      if (itemCount == 9) {
        //row1
        if (show_X_O[0] == "X" && show_X_O[1] == "X" && show_X_O[2] == "X") {
          setState(() {
            matchIndex = [0, 1, 2];
          });
          //row2
        } else if (show_X_O[3] == "X" &&
            show_X_O[4] == "X" &&
            show_X_O[5] == "X") {
          setState(() {
            matchIndex = [3, 4, 5];
          });
          //row3
        } else if (show_X_O[6] == "X" &&
            show_X_O[7] == "X" &&
            show_X_O[8] == "X") {
          setState(() {
            matchIndex = [6, 7, 8];
          });
          //column 1
        } else if (show_X_O[0] == "X" &&
            show_X_O[3] == "X" &&
            show_X_O[6] == "X") {
          setState(() {
            matchIndex = [0, 3, 6];
          });
          //column 2
        } else if (show_X_O[1] == "X" &&
            show_X_O[4] == "X" &&
            show_X_O[7] == "X") {
          setState(() {
            matchIndex = [1, 4, 7];
          });
          //column 3
        } else if (show_X_O[2] == "X" &&
            show_X_O[5] == "X" &&
            show_X_O[8] == "X") {
          setState(() {
            matchIndex = [2, 5, 8];
          });
          //left to right
        } else if (show_X_O[0] == "X" &&
            show_X_O[4] == "X" &&
            show_X_O[8] == "X") {
          setState(() {
            matchIndex = [0, 4, 8];
          });
          //right  to  left
        } else if (show_X_O[2] == "X" &&
            show_X_O[4] == "X" &&
            show_X_O[6] == "X") {
          setState(() {
            matchIndex = [2, 4, 6];
          });
        }
      } else if (itemCount == 16) {
        //row1
        if (show_X_O[0] == "O" && show_X_O[1] == "O" && show_X_O[2] == "O") {
          setState(() {
            matchIndex = [0, 1, 2];
          });
          //row2
        } else if (show_X_O[3] == "O" &&
            show_X_O[4] == "O" &&
            show_X_O[5] == "O") {
          setState(() {
            matchIndex = [3, 4, 5];
          });
          //row3
        } else if (show_X_O[6] == "O" &&
            show_X_O[7] == "O" &&
            show_X_O[8] == "O") {
          setState(() {
            matchIndex = [6, 7, 8];
          });
          //column 1
        } else if (show_X_O[0] == "O" &&
            show_X_O[3] == "O" &&
            show_X_O[6] == "O") {
          setState(() {
            matchIndex = [0, 3, 6];
          });
          //column 2
        } else if (show_X_O[1] == "O" &&
            show_X_O[4] == "O" &&
            show_X_O[7] == "O") {
          setState(() {
            matchIndex = [1, 4, 7];
          });
          //column 3
        } else if (show_X_O[2] == "O" &&
            show_X_O[5] == "O" &&
            show_X_O[8] == "O") {
          setState(() {
            matchIndex = [2, 5, 8];
          });
          //left to right
        } else if (show_X_O[0] == "O" &&
            show_X_O[4] == "O" &&
            show_X_O[8] == "O") {
          setState(() {
            matchIndex = [0, 4, 8];
          });
          //right  to  left
        } else if (show_X_O[2] == "O" &&
            show_X_O[4] == "O" &&
            show_X_O[6] == "O") {
          setState(() {
            matchIndex = [2, 4, 6];
          });
        } else if (itemCount == 16) {
          //row1
          if (show_X_O[0] == "O" &&
              show_X_O[1] == "O" &&
              show_X_O[2] == "O" &&
              show_X_O[3] == "O") {
            setState(() {
              matchIndex = [0, 1, 2, 3];
            });
            //row2
          } else if (show_X_O[4] == "O" &&
              show_X_O[5] == "O" &&
              show_X_O[6] == "O" &&
              show_X_O[7] == "O") {
            setState(() {
              matchIndex = [4, 5, 6, 7];
            });
            //row3
          } else if (show_X_O[8] == "O" &&
              show_X_O[9] == "O" &&
              show_X_O[10] == "O" &&
              show_X_O[11] == "O") {
            setState(() {
              matchIndex = [8, 9, 10, 11];
            });
            //row4
          } else if (show_X_O[12] == "O" &&
              show_X_O[13] == "O" &&
              show_X_O[14] == "O" &&
              show_X_O[15] == "O") {
            setState(() {
              matchIndex = [12, 13, 14, 15];
            });
            //column 1
          } else if (show_X_O[0] == "O" &&
              show_X_O[4] == "O" &&
              show_X_O[8] == "O" &&
              show_X_O[12] == "O") {
            setState(() {
              matchIndex = [0, 4, 8, 12];
            });
            //column 2
          } else if (show_X_O[1] == "O" &&
              show_X_O[5] == "O" &&
              show_X_O[9] == "O" &&
              show_X_O[13] == "O") {
            setState(() {
              matchIndex = [1, 5, 9, 13];
            });
            //column 3
          } else if (show_X_O[2] == "O" &&
              show_X_O[6] == "O" &&
              show_X_O[10] == "O" &&
              show_X_O[14] == "O") {
            setState(() {
              matchIndex = [2, 6, 10, 14];
            });
            //column 4
          } else if (show_X_O[3] == "O" &&
              show_X_O[7] == "O" &&
              show_X_O[11] == "O" &&
              show_X_O[15] == "O") {
            setState(() {
              matchIndex = [3, 7, 11, 15];
            });
            //left to right
          } else if (show_X_O[0] == "O" &&
              show_X_O[5] == "O" &&
              show_X_O[10] == "O" &&
              show_X_O[15] == "O") {
            setState(() {
              matchIndex = [0, 5, 10, 15];
            });
            //right  to  left
          } else if (show_X_O[3] == "O" &&
              show_X_O[6] == "O" &&
              show_X_O[9] == "O" &&
              show_X_O[12] == "O") {
            setState(() {
              matchIndex = [3, 6, 9, 12];
            });
          } else {
            //row1
            if (show_X_O[0] == "X" &&
                show_X_O[1] == "X" &&
                show_X_O[2] == "X" &&
                show_X_O[3] == "X") {
              setState(() {
                matchIndex = [0, 1, 2, 3];
              });
              //row2
            } else if (show_X_O[4] == "X" &&
                show_X_O[5] == "X" &&
                show_X_O[6] == "X" &&
                show_X_O[7] == "X") {
              setState(() {
                matchIndex = [4, 5, 6, 7];
              });
              //row3
            } else if (show_X_O[8] == "X" &&
                show_X_O[9] == "X" &&
                show_X_O[10] == "X" &&
                show_X_O[11] == "X") {
              setState(() {
                matchIndex = [8, 9, 10, 11];
              });
              //row4
            } else if (show_X_O[12] == "X" &&
                show_X_O[13] == "X" &&
                show_X_O[14] == "X" &&
                show_X_O[15] == "X") {
              setState(() {
                matchIndex = [12, 13, 14, 15];
              });
              //column 1
            } else if (show_X_O[0] == "X" &&
                show_X_O[4] == "X" &&
                show_X_O[8] == "X" &&
                show_X_O[12] == "X") {
              setState(() {
                matchIndex = [0, 4, 8, 12];
              });
              //column 2
            } else if (show_X_O[1] == "X" &&
                show_X_O[5] == "X" &&
                show_X_O[9] == "X" &&
                show_X_O[13] == "X") {
              setState(() {
                matchIndex = [1, 5, 9, 13];
              });
              //column 3
            } else if (show_X_O[2] == "X" &&
                show_X_O[6] == "X" &&
                show_X_O[10] == "X" &&
                show_X_O[14] == "X") {
              setState(() {
                matchIndex = [2, 6, 10, 14];
              });
              //column 4
            } else if (show_X_O[3] == "X" &&
                show_X_O[7] == "X" &&
                show_X_O[11] == "X" &&
                show_X_O[15] == "X") {
              setState(() {
                matchIndex = [3, 7, 11, 15];
              });
              //left to right
            } else if (show_X_O[0] == "X" &&
                show_X_O[5] == "X" &&
                show_X_O[10] == "X" &&
                show_X_O[15] == "X") {
              setState(() {
                matchIndex = [0, 5, 10, 15];
              });
              //right  to  left
            } else if (show_X_O[3] == "X" &&
                show_X_O[6] == "X" &&
                show_X_O[9] == "X" &&
                show_X_O[12] == "X") {
              setState(() {
                matchIndex = [3, 6, 9, 12];
              });
            }
          }
        }
      } else {
        if (show_X_O[0] == "O" &&
            show_X_O[1] == "O" &&
            show_X_O[2] == "O" &&
            show_X_O[3] == "O" &&
            show_X_O[4] == "O") {
          setState(() {
            matchIndex = [0, 1, 2, 3, 4];
          });
          //row2
        } else if (show_X_O[5] == "O" &&
            show_X_O[6] == "O" &&
            show_X_O[7] == "O" &&
            show_X_O[8] == "O" &&
            show_X_O[9] == "O") {
          setState(() {
            matchIndex = [5, 6, 7, 8, 9];
          });
          //row3
        } else if (show_X_O[10] == "O" &&
            show_X_O[11] == "O" &&
            show_X_O[12] == "O" &&
            show_X_O[13] == "O" &&
            show_X_O[14] == "O") {
          setState(() {
            matchIndex = [10, 11, 12, 13, 14];
          });
          //row4
        } else if (show_X_O[15] == "O" &&
            show_X_O[16] == "O" &&
            show_X_O[17] == "O" &&
            show_X_O[18] == "O" &&
            show_X_O[19] == "O") {
          setState(() {
            matchIndex = [15, 16, 17, 18, 19];
          });
          //row 5
        } else if (show_X_O[20] == "O" &&
            show_X_O[21] == "O" &&
            show_X_O[22] == "O" &&
            show_X_O[23] == "O" &&
            show_X_O[24] == "O") {
          setState(() {
            matchIndex = [20, 21, 22, 23, 24];
          });
          //column 1
        } else if (show_X_O[0] == "O" &&
            show_X_O[5] == "O" &&
            show_X_O[10] == "O" &&
            show_X_O[15] == "O" &&
            show_X_O[20] == "O") {
          setState(() {
            matchIndex = [0, 5, 10, 15, 20];
          });
          //column 2
        } else if (show_X_O[1] == "O" &&
            show_X_O[6] == "O" &&
            show_X_O[11] == "O" &&
            show_X_O[16] == "O" &&
            show_X_O[21] == "O") {
          setState(() {
            matchIndex = [1, 6, 11, 16, 21];
          });
          //column 3
        } else if (show_X_O[2] == "O" &&
            show_X_O[7] == "O" &&
            show_X_O[12] == "O" &&
            show_X_O[17] == "O" &&
            show_X_O[22] == "O") {
          setState(() {
            matchIndex = [2, 7, 12, 17, 22];
          });
          //column 4
        } else if (show_X_O[3] == "O" &&
            show_X_O[8] == "O" &&
            show_X_O[13] == "O" &&
            show_X_O[18] == "O" &&
            show_X_O[23] == "O") {
          setState(() {
            matchIndex = [3, 8, 13, 18, 23];
          });
          //column 5
        } else if (show_X_O[4] == "O" &&
            show_X_O[9] == "O" &&
            show_X_O[14] == "O" &&
            show_X_O[19] == "O" &&
            show_X_O[24] == "O") {
          setState(() {
            matchIndex = [4, 9, 14, 19, 24];
          });
          //left to right
        } else if (show_X_O[0] == "O" &&
            show_X_O[6] == "O" &&
            show_X_O[12] == "O" &&
            show_X_O[18] == "O" &&
            show_X_O[24] == "O") {
          setState(() {
            matchIndex = [0, 6, 12, 18, 24];
          });
          //right  to  left
        } else if (show_X_O[4] == "O" &&
            show_X_O[8] == "O" &&
            show_X_O[12] == "O" &&
            show_X_O[16] == "O" &&
            show_X_O[20] == "O") {
          setState(() {
            matchIndex = [4, 8, 12, 16, 20];
          });
        } else if (show_X_O[0] == "X" &&
            show_X_O[1] == "X" &&
            show_X_O[2] == "X" &&
            show_X_O[3] == "X" &&
            show_X_O[4] == "X") {
          setState(() {
            matchIndex = [0, 1, 2, 3, 4];
          });
          //row2
        } else if (show_X_O[5] == "X" &&
            show_X_O[6] == "X" &&
            show_X_O[7] == "X" &&
            show_X_O[8] == "X" &&
            show_X_O[9] == "X") {
          setState(() {
            matchIndex = [5, 6, 7, 8, 9];
          });
          //row3
        } else if (show_X_O[10] == "X" &&
            show_X_O[11] == "X" &&
            show_X_O[12] == "X" &&
            show_X_O[13] == "X" &&
            show_X_O[14] == "X") {
          setState(() {
            matchIndex = [10, 11, 12, 13, 14];
          });
          //row4
        } else if (show_X_O[15] == "X" &&
            show_X_O[16] == "X" &&
            show_X_O[17] == "X" &&
            show_X_O[18] == "X" &&
            show_X_O[19] == "X") {
          setState(() {
            matchIndex = [15, 16, 17, 18, 19];
          });
          //row 5
        } else if (show_X_O[20] == "X" &&
            show_X_O[21] == "X" &&
            show_X_O[22] == "X" &&
            show_X_O[23] == "X" &&
            show_X_O[24] == "X") {
          setState(() {
            matchIndex = [20, 21, 22, 23, 24];
          });
          //column 1
        } else if (show_X_O[0] == "X" &&
            show_X_O[5] == "X" &&
            show_X_O[10] == "X" &&
            show_X_O[15] == "X" &&
            show_X_O[20] == "X") {
          setState(() {
            matchIndex = [0, 5, 10, 15, 20];
          });
          //column 2
        } else if (show_X_O[1] == "X" &&
            show_X_O[6] == "X" &&
            show_X_O[11] == "X" &&
            show_X_O[16] == "X" &&
            show_X_O[21] == "X") {
          setState(() {
            matchIndex = [1, 6, 11, 16, 21];
          });
          //column 3
        } else if (show_X_O[2] == "X" &&
            show_X_O[7] == "X" &&
            show_X_O[12] == "X" &&
            show_X_O[17] == "X" &&
            show_X_O[22] == "X") {
          setState(() {
            matchIndex = [2, 7, 12, 17, 22];
          });
          //column 4
        } else if (show_X_O[3] == "X" &&
            show_X_O[8] == "X" &&
            show_X_O[13] == "X" &&
            show_X_O[18] == "X" &&
            show_X_O[23] == "X") {
          setState(() {
            matchIndex = [3, 8, 13, 18, 23];
          });
          //left to right
        } else if (show_X_O[4] == "X" &&
            show_X_O[9] == "X" &&
            show_X_O[14] == "X" &&
            show_X_O[19] == "X" &&
            show_X_O[24] == "X") {
          setState(() {
            matchIndex = [4, 9, 14, 19, 24];
          });
          //left to right
        } else if (show_X_O[0] == "X" &&
            show_X_O[6] == "X" &&
            show_X_O[12] == "X" &&
            show_X_O[18] == "X" &&
            show_X_O[24] == "X") {
          setState(() {
            matchIndex = [0, 6, 12, 18, 24];
          });
          //right  to  left
        } else if (show_X_O[4] == "X" &&
            show_X_O[8] == "X" &&
            show_X_O[12] == "X" &&
            show_X_O[16] == "X" &&
            show_X_O[20] == "X") {
          setState(() {
            matchIndex = [4, 8, 12, 16, 20];
          });
        }
      }
    }
  }
}
