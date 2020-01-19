import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlipCardTestPage extends StatefulWidget {
  @override
  _FlipCardTestPageState createState() => _FlipCardTestPageState();
}

class _FlipCardTestPageState extends State<FlipCardTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FlipCardTestPage'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Card(
                elevation: 0.0,
                margin: EdgeInsets.only(
                    left: 32.0, right: 32.0, top: 80.0, bottom: 0.0),
                // color: Colors.grey,
                child: FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  speed: 1000,
                  onFlipDone: (status) {
                    print(status);
                  },
                  front: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFF006666),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Front',
                            style: Theme.of(context).textTheme.headline),
                        Text('Click here to flip back',
                            style: Theme.of(context).textTheme.body1),
                      ],
                    ),
                  ),
                  back: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFF336633),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Back',
                            style: Theme.of(context).textTheme.headline),
                        Text('Click here to flip front',
                            style: Theme.of(context).textTheme.body1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.transparent,
              ),
            )
          ],
        ));
  }
}
