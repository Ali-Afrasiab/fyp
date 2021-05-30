import 'package:bubble/bubble.dart';
import 'package:custom_cupertino_date_textbox/custom_cupertino_date_textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:remedium/chatbot_report.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

class jarvis extends StatefulWidget {
  const jarvis({Key key}) : super(key: key);

  @override
  _jarvisState createState() => _jarvisState();
}

class _jarvisState extends State<jarvis> {
  response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/jarvis-kseo-0e7ecfbc60c8.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();
  bool data_gathered = false;
  String gender = '';
  List issues = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => chatbot_report(
                          messages: messsages,
                        )),
              );
            },
            color: Colors.transparent,
            child: Row(
              children: [
                Text(
                  'Report',
                  style: TextStyle(color: CupertinoColors.white),
                ),
                Icon(
                  Icons.analytics_outlined,
                  color: CupertinoColors.white,
                )
              ],
            ),
          )
        ],
        title: Text(
          "Jarvis",
        ),
        backgroundColor: Color(0xFF202125),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            data_gathered == true
                ? Flexible(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messsages.length,
                      itemBuilder: (context, index) => chat(
                          messsages[index]["message"].toString(),
                          messsages[index]["data"]),
                    ),
                  )
                : Flexible(
                    child: ListView(
                      reverse: true,
                      children: [
                        ///harresement :work place, street, schools, /physical violence:home parents, siblings, children's, husband/employee bullying boss
                       RaisedButton(

                         onPressed: (){
                         setState(() {
                           data_gathered=true;
                         });
                       },
                         color: Colors.blue,
                       child: Text('All Done!'),),
                        Card(
                          elevation: 8,
                          //shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),

                          child: Column(
                            children: [
                              Text(
                                'Do you have any issues with family?',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              issues.add('parents');
                                            });
                                          },
                                          color: issues.contains('parents')
                                              ? Colors.blue
                                              : Colors.grey,
                                          child: Text(
                                            'Parents',
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              issues.add('siblings');
                                            });
                                          },
                                          color: issues.contains('siblings')
                                              ? Colors.blue
                                              : Colors.grey,
                                          child: Text(
                                            'Siblings',
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              issues.add('children');
                                            });
                                          },
                                          color: issues.contains('children')
                                              ? Colors.blue
                                              : Colors.grey,
                                          child: Text(
                                            'Children',
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              issues.add('husband/wife');
                                            });
                                          },
                                          color: issues
                                              .contains('husband/wife')
                                              ? Colors.blue
                                              : Colors.grey,
                                          child: Text(
                                            'Husband/Wife',
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 8,
                          //shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),

                          child: Column(
                            children: [
                              Text(
                                'Did you suffered any Harassment at?',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              issues.add('Work place');
                                            });
                                          },
                                          color: issues.contains('Work place')
                                              ? Colors.blue
                                              : Colors.grey,
                                          child: Text(
                                            'Work place',
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              issues.add('street');
                                            });
                                          },
                                          color: issues.contains('street')
                                              ? Colors.blue
                                              : Colors.grey,
                                          child: Text(
                                            'Street',
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              issues.add('schools');
                                            });
                                          },
                                          color: issues.contains('schools')
                                              ? Colors.blue
                                              : Colors.grey,
                                          child: Text(
                                            'School',
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              issues.add('physical violence');
                                            });
                                          },
                                          color: issues
                                                  .contains('physical violence')
                                              ? Colors.blue
                                              : Colors.grey,
                                          child: Text(
                                            'Physical violence',
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CustomizableCupertinoDateTextBox(
                            initialValue: DateTime.now(),
                            hintText: "Date",
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          //   color: Colors.blue,
                          child: Column(
                            children: [
                              Text('Kindly fill the following Information!'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          gender = 'Male';
                                        });
                                      },
                                      color: gender == 'Female'
                                          ? Colors.grey
                                          : Colors.blue,
                                      child: Text(
                                        'Male',
                                        style: TextStyle(
                                            color: CupertinoColors.white),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          gender = 'Female';
                                        });
                                      },
                                      color: gender == 'Male'
                                          ? Colors.grey
                                          : Colors.pink,
                                      child: Text(
                                        'Female',
                                        style: TextStyle(
                                            color: CupertinoColors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            Divider(
              height: 5.0,
              color: Color(0xFF202125),
            ),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                    controller: messageInsert,
                    decoration: InputDecoration.collapsed(
                        hintText: "Send your message",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0)),
                  )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 30.0,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            print("empty message");
                          } else {
                            setState(() {
                              messsages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Colors.deepOrange : Colors.orangeAccent,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(
                      data == 0 ? "assets/bot.png" : "assets/user.png"),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Text(
                  message,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
              ],
            ),
          )),
    );
  }
}
