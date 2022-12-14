import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xo_moble_app/Winner.dart';
import 'package:xo_moble_app/Xo_Gamepage.dart';
import 'package:xo_moble_app/Xo_Gamepage_detail.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

String text = "";

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                _backgroundImage(),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _title(),
                            _image(),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _subtitle(),
                          ]),
                    )
                  ],
                )
              ],
            ),
            Stack(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "เกม XO มหาสนุก",
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    text = "3";
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Xo_Gamepage(size: text)),
                                  );
                                },
                                child: Image.asset(
                                  'images/image01.png',
                                  width: 130,
                                  height: 100,
                                )),
                            Text("3X3")
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    text = "4";
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Xo_Gamepage(size: text)),
                                  );
                                },
                                child: Image.asset(
                                  'images/image01.png',
                                  width: 130,
                                  height: 100,
                                )),
                            Text("4X4")
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    text = "5";
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Xo_Gamepage(size: text)),
                                  );
                                },
                                child: Image.asset(
                                  'images/image01.png',
                                  width: 130,
                                  height: 100,
                                )),
                            Text("5X5")
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                _backgroundImageHistory(),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _history(),
                          ]),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Winner>>(
                  future: DatabaseHelper.instance.getWinner(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<Winner>> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text('Loading.....'),
                      );
                    }
                    return snapshot.data!.isEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  "No Winner in List",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          )
                        : ListView(
                            children: snapshot.data!.map((Winner) {
                              return Column(
                                children: [
                                  Center(
                                      child: ListTile(
                                    title: Text("\n" +
                                        "รหัสการแข่งขัน :" +
                                        Winner.id.toString() +
                                        "\nขนาดที่เล่น : " +
                                        Winner.size.toString() +
                                        "X" +
                                        Winner.size.toString() +
                                        "\n" +
                                        "ผลการแข่งขัน : " +
                                        Winner.winner.toString() +
                                        "\nวันที่ " +
                                        Winner.date!.day.toString() +
                                        "-" +
                                        Winner.date!.month.toString() +
                                        "-" +
                                        Winner.date!.year.toString() +
                                        " เวลา " +
                                        Winner.date!.hour.toString() +
                                        "." +
                                        Winner.date!.minute.toString()),
                                    onTap: () {
                                      /*
                                      setState(() {
                                        DatabaseHelper.instance
                                            .remove(Winner.id!);
                                      });*/

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Xo_Gamepage_detail(
                                                    size:
                                                        Winner.size.toString(),
                                                    id: Winner.id.toString(),
                                                    result: Winner.winner
                                                        .toString())),
                                      );
                                    },
                                  )),
                                  Text("----------------------------")
                                ],
                              );
                            }).toList(),
                          );
                  }),
            ),
            FloatingActionButton.extended(
                onPressed: () async {
                  await DatabaseHelper.deleteTable("Winner");
                  FocusScope.of(context).unfocus();
                },
                label: Text('ลบข้อมูลทั้งหมด')),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _title() {
    return Text(
      "Welcome Digio (Thailand)",
      style: TextStyle(fontSize: 23),
    );
  }

  Widget _history() {
    return Text(
      "ประวัติการเล่น",
      style: TextStyle(fontSize: 23),
    );
  }

  Widget _subtitle() {
    return Text("ต้องการเล่นเกม X O ไหม ?", style: TextStyle(fontSize: 15));
  }

  Widget _image() {
    return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset("images/digio.jpg"),
        ));
  }

  Widget _backgroundImage() {
    return Stack(
      children: [
        Container(
          width: 411,
          height: 100,
          color: Colors.blue,
        )
      ],

      //
    );
  }

  Widget _backgroundImageHistory() {
    return Stack(
      children: [
        Container(
          width: 411,
          height: 70,
          color: Colors.blue,
        )
      ],

      //
    );
  }
}
