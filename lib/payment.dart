import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class payment1 extends StatefulWidget {
  const payment1({Key key}) : super(key: key);

  @override
  _payment1State createState() => _payment1State();
}

class _payment1State extends State<payment1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFF202125),
        shadowColor: Colors.blue,
        elevation: 5,
        title: Text('Payment'),
      ),
      body:
      Container(
        color: Color(0xFF202125),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'By Credit Card',
                  style: TextStyle(color: CupertinoColors.white,
                  fontWeight: FontWeight.w500,
                    fontSize: 20
                  ),
                ),


              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bank :',
                  style: TextStyle(color: CupertinoColors.white,
                      fontWeight: FontWeight.w500,

                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Card number :',
                  style: TextStyle(color: CupertinoColors.white,
                      fontWeight: FontWeight.w500,

                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
