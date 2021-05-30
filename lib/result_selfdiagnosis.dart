import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/widgets.dart';
import 'package:remedium/signin.dart';
import 'package:flutter/foundation.dart';

class result_selfdiagnosis extends StatelessWidget {

  int result = 0;

  result_selfdiagnosis(result) {
    this.result = int.parse(result);
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: new PreferredSize(
          child: new Container(
            padding: new EdgeInsets.only(top: MediaQuery
                .of(context)
                .padding
                .top),
            child: new Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 20.0, bottom: 20.0),
              child: Center(
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => signin()),
                          );
                        }),
                    //SizedBox(
                    //width: 90,
                    //),
                    new Text(
                      'Your Diagnosis Result',
                      style: new TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            decoration: new BoxDecoration(color: Color(0xFF202125),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.blue,
                    blurRadius: 20.0,
                    spreadRadius: 1.0,
                  ),
                ]),
          ),
          preferredSize: new Size(MediaQuery
              .of(context)
              .size
              .width, 80.0),
        ),
        body:
        Center(
          child: Container( decoration: const BoxDecoration(
            color: Color(0xFF202125),
            //color: Colors.white,
  ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ), if(result == 0)
                    Container(
                      height: 190,
                      width: 200,
                      margin: new EdgeInsets.fromLTRB(0, 200, 0, 0),
                      // padding: new EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                            "On the basis of your symptoms, chances that you have contracted covid-19 are very high ",
                            style: TextStyle(color: Color(0xFFADD8F3),
                                fontSize: 25, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center),

                      ),
                    ),
                  if(result == 1)
                    Container(
                      height: 190,
                      width: 200,
                      margin: new EdgeInsets.fromLTRB(0, 200, 0, 0),
                      // padding: new EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                            "On the basis of your symptoms, your chances of contracting covid-19 are very low.",
                            style: TextStyle(color: Color(0xFFADD8F3),
                                fontSize: 25, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center),

                      ),
                    ),
                  if(result == 2)
                    Container(
                      height: 190,
                      width: 200,
                      margin: new EdgeInsets.fromLTRB(0, 200, 0, 0),
                      // padding: new EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                            "On the basis of your symptoms, chances that you have contracted covid-19 are moderate ",
                            style: TextStyle(color: Color(0xFFADD8F3),
                                fontSize: 25, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center),

                      ),
                    ),
                  if(result == 3)
                    Container(
                      height: 190,
                      width: 200,
                      margin: new EdgeInsets.fromLTRB(0, 200, 0, 0),
                      // padding: new EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                            "On the basis of your symptoms, chances that you have contracted covid-19 are very low ",
                            style: TextStyle(color: Color(0xFFADD8F3),
                                fontSize: 25, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center),

                      ),
                    ),
                  if(result == 4)
                    Container(
                      height: 190,
                      width: 200,
                      margin: new EdgeInsets.fromLTRB(0, 200, 0, 0),
                      // padding: new EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                            "On the basis of your symptoms, chances that you have contracted covid-19 are high ",
                            style: TextStyle(color: Color(0xFFADD8F3),
                                fontSize: 25, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center),

                      ),
                    ),
                  if(result == 5)
                    Container(
                      height: 190,
                      width: 200,
                      margin: new EdgeInsets.fromLTRB(0, 200, 0, 0),
                      // padding: new EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                            "All of your symptoms indicate that you may have contracted Covid-19 ",
                            style: TextStyle(color: Color(0xFFADD8F3),
                                fontSize: 25, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center),

                      ),
                    ),
                  if(result == 6)
                    Container(
                      height: 190,
                      width: 200,
                      margin: new EdgeInsets.fromLTRB(0, 200, 0, 0),
                      // padding: new EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                            "On the basis of your symptoms, chances that you have contracted covid-19 are high ",
                            style: TextStyle(color: Color(0xFFADD8F3),
                                fontSize: 25, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center),

                      ),
                    ),

                ],

              ),
            ),
          ),
        ),

      );
}
