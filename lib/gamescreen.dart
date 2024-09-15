import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hangman_game/utils.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final player = AudioPlayer();
  String word = wordslist[Random().nextInt(wordslist.length)];
  List guessedalphabets = [];
  int points = 0;
  int status = 0;
  bool soundOn = true;
  List images = [
    "images/hangman0.png",
    "images/hangman1.png",
    "images/hangman2.png",
    "images/hangman3.png",
    "images/hangman4.png",
    "images/hangman5.png",
    "images/hangman6.png",
  ];

  playsound(String sound) async {
    if(soundOn){
      player.audioCache = AudioCache(prefix: 'sounds/');
      await player.play(AssetSource(sound));
    }
  }

  opendialog(String title){
    return showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context){
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width/2,
            height: 180,
            decoration: const BoxDecoration(
              color: Colors.purpleAccent
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: retroStyle(25,Colors.white,FontWeight.bold),textAlign: TextAlign.center,),
                const SizedBox(height: 5,),
                Text("Your Points : $points" , style: retroStyle(20,Colors.white,FontWeight.bold),textAlign: TextAlign.center),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width/2,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        status = 0;
                        guessedalphabets.clear();
                        points = 0;
                        word = wordslist[Random().nextInt(wordslist.length)];
                      });
                      playsound("restart.mp3");
                    },
                    child: Center(child: Text("Play Again",style: retroStyle(20,Colors.black,FontWeight.bold),)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String handletext(){
    String displayword = "";
    for(int i=0;i<word.length;i++){
      String char = word[i];
      if(guessedalphabets.contains(char)){
        displayword += "$char ";
      }else{
        displayword += "? ";
      }
    }
    return displayword;
  }

  checkletter(String alphabet){
    if(word.contains(alphabet)){
      setState(() {
        guessedalphabets.add(alphabet);
        points += 1;
      });
      playsound("correct.mp3");
    }else if(status < 6){
      setState(() {
        status += 1;
        points -= 1;
      });
      playsound("wrong.mp3");
    }else{
      opendialog("You Lose");
      playsound("lost.mp3");
    }

    bool isWon = true;
    for(int i=0;i<word.length;i++){
      String char = word[i];
      if(!guessedalphabets.contains(char)){
        setState(() {
          isWon = false;
        });
        break;
      }
    }

    if(isWon){
      opendialog("You Won");
      playsound("won.mp3");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text(
          "Hangman",
          style: retroStyle(30, Colors.white, FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                soundOn = !soundOn;
              });
            },
            iconSize: 40,
            color: Colors.white,
            icon: Icon(
             soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3.5,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                ),
                child: Center(
                    child: Text(
                  "$points Points",
                  style: retroStyle(16, Colors.black, FontWeight.normal),
                )),
              ),
              const SizedBox(
                height: 40,
              ),
              Image(
                image: AssetImage(images[status]),
                width: 155,
                height: 155,
                color: Colors.white,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "${7-status} Lives Left",
                style: retroStyle(18, Colors.grey, FontWeight.w700),
              ),
              const SizedBox(height: 30),
              Text(
                handletext(),
                style: retroStyle(35, Colors.white, FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 10),
                childAspectRatio: 1.3,
                children: letters.map((alphabet) {
                  return InkWell(
                      onTap: () => checkletter(alphabet),
                      child: Center(
                        child: Text(
                          alphabet,
                          style: retroStyle(20, Colors.white, FontWeight.w700),
                        ),
                      ));
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
