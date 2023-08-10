import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:for_what_game_app/constants/asset_paths.dart';
import 'package:flip_card/flip_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> myassets;
  late int score;
  List<int> eliminatedIndexes = [];
  String buffer1 = '';
  int index1 = -1;
  String buffer2 = '';
  int index2 = -2;
  int clickCounter = 0;
  late List<FlipCardController> controllers;
  List<int> matchedIndexes = [];
  int tempindex = -1;

  @override
  void initState() {
    super.initState();
    initializaValues();
  }

  initializaValues() {
    myassets = AssetPaths.assets;
    controllers =
        List.generate(myassets.length, (index) => FlipCardController());
    score = 0;
  }

  void restart([bool pop = true]) {
    matchedIndexes.clear();
    for (var controller in controllers) {
      if (controller.state?.isFront == false) {
        controller.toggleCardWithoutAnimation();
      }
    }
    setState(() {
      initializaValues();
      shuffleTempVars();
    });
    if (pop) {
      Navigator.pop(context);
    }
  }

  Future<void> scoreUp() async {
    setState(() {
      score++;
    });
    if (score == (myassets.length / 2).toInt()) {
      await gameOverPopUp(score);
      return;
    }
  }

  shuffleTempVars() {
    index1 = -1;
    index2 = -2;
    buffer1 = "-1";
    buffer2 = "-2";
  }

  void isEqual() async {
    clickCounter = 0;
    if (buffer1 == buffer2 && index1 != index2) {
      matchedIndexes.addAll([index1, index2]);
      scoreUp();
      shuffleTempVars();
      return;
    }
    await controllers.elementAt(index1).toggleCard();
    await controllers.elementAt(index2).toggleCard();
    matchedIndexes.remove(index1);
    shuffleTempVars();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: Color.fromARGB(255, 255, 199, 59),
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: () {
            restart(false);
            gameOverPopUp(score);
          },
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 157, 133, 199),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.red,
                        offset: Offset(10, 10),
                        blurStyle: BlurStyle.normal,
                        spreadRadius: 3,
                      ),
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.orange,
                        offset: Offset(3, 5),
                        blurStyle: BlurStyle.normal,
                        spreadRadius: 3,
                      ),
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.yellow,
                        offset: Offset(3, 5),
                        blurStyle: BlurStyle.normal,
                        spreadRadius: 3,
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Score:$score',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.5,
                child: GridView.builder(
                    itemCount: myassets.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      final itemtobuild = myassets.elementAt(index);
                      return FlipCard(
                        controller: controllers.elementAt(index),
                        flipOnTouch: isFlipable(index),
                        onFlipDone: (isFront) {
                          if (isFront) {
                            clickCounter++;
                            if (clickCounter == 1) {
                              buffer1 = itemtobuild;
                              index1 = index;
                              setState(() {
                                matchedIndexes.add(index1);
                              });
                              return;
                            }
                            buffer2 = itemtobuild;
                            index2 = index;
                            isEqual();
                          }
                        },
                        front: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 54,
                            width: 54,
                            color: Colors.deepPurple[100],
                            child: Icon(Icons.tag_faces_rounded),
                          ),
                        ),
                        back: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 54,
                            width: 54,
                            color: Colors.deepPurple[100],
                            child:

                                // Image.asset('assets/images/avoc.jpg',
                                //     fit: BoxFit.scaleDown),

                                Image.asset(
                              itemtobuild,
                            ),
                            // child: Image.asset('assets/images/goat.jpg'),
                            // child: Image.asset('assets/images/hipo.jpg'),
                            // child: Image.asset('assets/images/lion.jpg'),
                            // child: Image.asset('assets/images/pig.jpg'),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                child: Text(
                  'Powered by EVQ',
                  style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(),
              ),
            ],
          ),
        ));
  }

  bool isFlipable(int index) {
    return !matchedIndexes.contains(index);
  }

  Future<void> gameOverPopUp(int score) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          width: 150,
          alignment: Alignment.center,
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 12,
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('\n      Tekrar Başla?      '),
                  SizedBox(
                    height: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        restart();
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.purpleAccent.shade400,
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
//TODO:
//*resimlerin arkasını çevireceğiz DONE
//*resimleri rastgele sırayla dizeceğiz DONE
//*resimlerin açılmasını yapacağız DONE
//*açılmış kartların eşlenmesini yapacağız 
//*score hesaplaması yapacağız 
//*girişte isim alacağız
