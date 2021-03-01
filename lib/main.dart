import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/scheduler.dart';


void main() {
  runApp(MaterialApp(

    home:HomeScreen(),
  ),
  );
}


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tile Clicker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(120.0, 0.0, 0.0, 0.0),
            child: Text('Tile Clicker',
              style: TextStyle(
                fontSize: (40.0),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(120.0, 0.0, 0.0, 0.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GamePage()),
                );
              },
              child: Text('Start'),
            ),
          ),
        ],
      ),
    );
  }
}







class GamePage extends StatelessWidget {
  final String title;

  GamePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The green box goes here with some other Widgets.
    final title = 'Tile Clicker';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SafeArea(
          child: Center(

            child: GameWindow(),
          ),
        ),

      ),
    );
  }
}


class GameWindow extends StatefulWidget {
  @override
  _GameWindowState createState() => _GameWindowState();

}


class _GameWindowState extends State<GameWindow> {

  int strikesRemaining = 3;
  int total = 0;
  int gameScore = 0;
  int _counter = 60;
  Timer _timer;
  List colors = [Colors.red, Colors.blue];
  Random random = new Random();
  int index = 0;

  void addStrike(){
    strikesRemaining = strikesRemaining - 1;
  }

  void addPoint(){
    gameScore = gameScore + 1;
  }
  void checkStrikesRemaining(){
    if (strikesRemaining == 0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameOverScreen(gameScore)
        ),
      );
    }
  }
  void changeIndex() {
    setState(() => index = random.nextInt(2));
  }

  void countdown(){
    _counter = 60;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if ( _counter > 0) {
        _counter--;
      } else {
      _timer.cancel();
      }
    });
  });
}
void checkTotal(){
    if (total == 1){
      countdown();
    }
}

  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        (_counter > 0)
            ? Text("")
            : Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameOverScreen(gameScore)
      ),
    ),
        Container(
          child: Text('$_counter'),
        ),
        Expanded(child: Container(
            height: 200,
            width: 400,
            color: colors[index],
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Center(child: Text('X',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,
                    fontSize: 24)))
        ),
        ),


        Container(
            margin:EdgeInsets.only(bottom:20),
            child: Text('Strikes Remaining: ' + strikesRemaining.toString(), style:TextStyle(fontSize: 20))),
        RaisedButton(
          child: Text('Blue'),
          onPressed: (){
            if(colors[index] == Colors.blue){
              addPoint();
            }
            else{
              addStrike();
              checkStrikesRemaining();
            }
            changeIndex();
          },
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(200, 10, 200, 10),
        ),
        RaisedButton(
          child: Text('Red'),
          onPressed: (){
            total++;
            checkTotal();
            if(colors[index] == Colors.red){
              addPoint();
            }
            else{
              addStrike();
              checkStrikesRemaining();
            }
            changeIndex();
          },
          color: Colors.red,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(200, 10, 200, 10),
        ),

      ],
    );
  }
}


class GameOverScreen extends StatelessWidget {
  final int gameScore;
  int bestScore;
  GameOverScreen(this.gameScore);
  void checkBest(){
    if(bestScore == null){
      bestScore = 0;
    }
    if(gameScore > bestScore){
      bestScore = gameScore;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkBest();
    return Scaffold(
        appBar: AppBar(
          title: Text('Game Over'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Game Over',
                style: TextStyle(fontSize: 50),
              ),
              Text('High Score: ' + bestScore.toString(), style: TextStyle(fontSize: 30),),
              Text('Score: ' + gameScore.toString(), style: TextStyle(fontSize: 30),),

              Container(
                margin: new EdgeInsets.only(top:5.0),
                child: RaisedButton(
                    child: Text('Return to Home'),
                    color: Colors.lightBlueAccent,
                    textColor: Colors.white,

                    padding: new EdgeInsets.all(25.0),
                    onPressed: (){

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                ),
              )
            ],
          ),
        ));
  }
}