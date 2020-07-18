import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Contador de pessoas',
    home: Stack(
      children: <Widget>[
        Image.asset(
          'images/restaurant.jpg',
          fit: BoxFit.cover,
          height: double.maxFinite,
        ),
        Home(),
      ],
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _peapleCount = 0;
  String _information = 'Pode entrar!';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Pessoas: $_peapleCount',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: FlatButton(
                child: Text(
                  '+1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                onPressed: () => _changePeaple(1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FlatButton(
                child: Text(
                  '-1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                onPressed: () => _changePeaple(-1),
              ),
            ),
          ],
        ),
        Text(
          '$_information',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontSize: 30,
          ),
        ),
      ],
    );
  }

  void _changePeaple(int value) {
    setState(() {
      _peapleCount += value;

      if (_peapleCount < 0)
        _information = 'Como assim!?';
      else if (_peapleCount <= 10)
        _information = 'Pode entrar!';
      else
        _information = 'Lotado!';
    });
  }
}
