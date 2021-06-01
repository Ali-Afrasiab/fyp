import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:remedium/patient_inventory.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remedium/covid.dart';
import 'package:remedium/patient_profile.dart';

final _firestore = Firestore.instance;

class recieved_result extends StatefulWidget {
  final doc_id;
  recieved_result({this.doc_id});
  @override
  _recieved_resultState createState() => _recieved_resultState(doc_id: doc_id);
}

class _recieved_resultState extends State<recieved_result> {
  _recieved_resultState({this.doc_id});
  final String doc_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new PreferredSize(
        child: new Container(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: new Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
            child: Center(
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: CupertinoColors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => patient_inventory()),
                        );
                      }),
                  new Text(
                    'Result',
                    style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          decoration: new BoxDecoration(color: Color(0xFF202125), boxShadow: [
            new BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 20.0,
              spreadRadius: 1.0,
            ),
          ]),
        ),
        preferredSize: new Size(MediaQuery.of(context).size.width, 80.0),
      ),
      body: SafeArea(

        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(doc_id: doc_id),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({this.doc_id});

  final String doc_id;

  String email;
  String first_name;
  String last_name;
  String gender;
  String condition;
  String telephone;
  String result;
  String age;
  String date;
  Color colour;
  String x_ray;
  String profile_pic;
String prescription;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('consultation').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        // List<MessageBubble> messageBubbles = [];
        //print(recieved);

        for (var message in messages) {
          if (message.documentID == doc_id) {
            email = message.data['patient_email'];
            first_name = message.data['patient_first_name'];
            last_name = message.data['patient_last_name'];
            gender = message.data['patient_gender'];
            condition = message.data['comments'];
            //final date = message.data['date'];
            telephone = message.data['patient_telephone'];
            age = message.data['patient_age'];
            date = message.data['date'];
            result = message.data['patient_result'];
            profile_pic= message.data['patient_image'];
            x_ray=message.data['x-ray'];
            prescription= message.data['comments'];
            if (result =='pending') {
              result = "pending";
              colour = Colors.yellowAccent;
            }
            if (result == "Negative") {
              colour = Colors.green;
            }
            if (result == "Positive") colour = Colors.red;
          }
        }

        return result!='pending'?Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF202125),
            ),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top:15.0,left: 15,right: 15,bottom: 80),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: CircularProfileAvatar(
                                profile_pic==null?'':profile_pic,
                                borderColor: colour,
                                borderWidth: 5,
                                elevation: 2,
                                radius: 80,
                                cacheImage: true,
                              ),
                            ),
                          ],
                        ),
                        Column(

                          children: [
                            Row(
                              children: [
                                Text(
                                  "Name ",
                                  style: TextStyle(color: CupertinoColors.white),
                                ),
                                Text(
                                 '${first_name} ${last_name}' ,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Age: ",
                                  style: TextStyle(color: CupertinoColors.white),
                                ),
                                Text(
                                  age==null?'null':age,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Gender ",
                                  style: TextStyle(color: CupertinoColors.white),
                                ),
                                Text(
                                  gender==null?'null':gender,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),


                Expanded(
                  child: Container(

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            topLeft: Radius.circular(50.0)),
                        gradient: LinearGradient(
                              colors: [Colors.grey, Colors.blueGrey],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Expanded(
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            "Result Summary",
                            style:
                                TextStyle(fontSize: 25, color: CupertinoColors.white),
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Test Date :",
                                              style: TextStyle(
                                                  color: CupertinoColors.white),
                                            ),
                                            Text(
                                             date==null?'': date,
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),

                                        Column(
                                          children: [
                                            Text(
                                              "Doctors Comments:",
                                              style: TextStyle(
                                                  color: CupertinoColors.white),
                                            ),
                                            Text(

                                              prescription==null?'You dont have covid .':prescription,
                                              maxLines: 5,
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                        Container(
                                          height: 180,
                                          width: 180,
                                          child: Card(
                                              elevation: 5,
                                              margin: EdgeInsets.all(2),
                                              color: Colors.yellow,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              semanticContainer: true,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Image.network(
                                               'https://firebasestorage.googleapis.com/v0/b/remedium-4f8f3.appspot.com/o/doctor_profile%2Faliafrasiab44%40gmail.com?alt=media&token=1c07b86e-d09e-4f1b-9dd6-c177e8b33acf',
                                                fit: BoxFit.fill,
                                              )),
                                        ),

                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Status :",
                                      style: TextStyle(
                                          fontSize: 25, color: CupertinoColors.white),
                                    ),
                                    Text(
                                     result==null?'':result,
                                      style:
                                          TextStyle(fontSize: 25, color: colour),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ):Container(width: 0,height: 0,);
      },
    );
  }
}
