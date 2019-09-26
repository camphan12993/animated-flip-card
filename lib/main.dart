import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: AnimatedFlipCard(),
      ),
    );
  }
}

class AnimatedFlipCard extends StatefulWidget {
  @override
  _AnimatedFlipCardState createState() => _AnimatedFlipCardState();
}

class _AnimatedFlipCardState extends State<AnimatedFlipCard>
    with TickerProviderStateMixin {
  AnimationController _flipCardController;
  Animation<double> _frontAnimation;
  Animation<double> _backAnimation;
  @override
  void initState() {
    super.initState();

    _flipCardController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    // play from 0  to 0.5s
    _frontAnimation = Tween<double>(begin: 0.0, end: 0.5 * pi).animate(
        CurvedAnimation(parent: _flipCardController, curve: Interval(0, 0.5)));

    // delay in 0.5s(wait for the front flip completed) and then play
    _backAnimation = Tween<double>(begin: 1.5 * pi, end: 2 * pi).animate(
        CurvedAnimation(parent: _flipCardController, curve: Interval(0.5, 1)));
  }

  @override
  void dispose() {
    _flipCardController.dispose();
    super.dispose();
  }

  void flipCard() {
    if (_flipCardController.isDismissed) {
      _flipCardController.forward();
    } else {
      _flipCardController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            AnimatedBuilder(
                child: GestureDetector(
                  child: CustomCard('Back', Colors.white),
                  onTap: flipCard,
                ),
                animation: _backAnimation,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    alignment: FractionalOffset.center,
                    child: child,
                    transform: Matrix4.identity()
                      ..rotateY(_backAnimation.value),
                  );
                }),
            AnimatedBuilder(
                child: GestureDetector(
                  child: CustomCard('Front', Colors.orangeAccent),
                  onTap: flipCard,
                ),
                animation: _frontAnimation,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    alignment: FractionalOffset.center,
                    child: child,
                    transform: Matrix4.identity()
                      ..rotateY(_frontAnimation.value),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final Color color;
  CustomCard(this.title, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            new BoxShadow(
                color: Colors.black26,
                offset: new Offset(10.0, 10.0),
                blurRadius: 20.0,
                spreadRadius: 0.0)
          ]),
      width: 300.0,
      height: 400.0,
      child: Center(
        child: Text(
          this.title,
          style: TextStyle(
              color: Colors.black54,
              fontSize: 40.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
