import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remedium/create_patient.dart';
import 'package:remedium/jazz_cash.dart';
import 'package:remedium/nav_drawer.dart';
import 'package:remedium/patient_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:remedium/payment.dart';

import 'consultation.dart';
import 'recieved_result.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class patient_inventory extends StatefulWidget {
  @override
  _doctor_inventoryState createState() => _doctor_inventoryState();
}

class _doctor_inventoryState extends State<patient_inventory> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  String search='';
  String dropdownValue='Show All';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: nav_drawer(sender: 'patient',),
      appBar: new PreferredSize(
        child: new Container(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: CupertinoColors.white,
                    ),

                      onPressed: () => _scaffoldKey.currentState.openDrawer(),
                    ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Container(

                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        onChanged: (value){setState(() {
                        search=value;
                        });},
                        decoration: InputDecoration(
                            fillColor: CupertinoColors.white,
                            prefixIcon: Icon(
                              Icons.search
                            ),
                            border: OutlineInputBorder(
                            ),
                            hintText: 'Search Report by Doctor',

                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child:  new DropdownButton<String>(
                    hint: Text(dropdownValue,style: TextStyle(color: CupertinoColors.white),),
                    dropdownColor: Color(0xFF202125),

                    icon:  Icon(Icons.filter_alt_outlined,color: CupertinoColors.white,),
                    items: <String>['Show All','Request Accepted','Result Pending','Positive Results', 'Negative Results'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value,style: TextStyle(color: CupertinoColors.white),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue=value;
                      });
                     // print('filter : $dropdownValue');
                    },
                  ),
                ),
              ],
            ),
          ),
          decoration: new BoxDecoration(color: Color(0xFF202125), boxShadow: [
            new BoxShadow(
              color: Colors.blue,
              blurRadius: 20.0,
              spreadRadius: 1.0,
            ),
          ]),
        ),
        preferredSize: new Size(MediaQuery.of(context).size.width, 80.0),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/patient_inventory.jpg"
                  ),
                  fit: BoxFit.cover
              )
          ),
          child: Column(
            //    color: Color(0xFF202125),

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              search.isNotEmpty?MessagesStream(search: search,filter: dropdownValue, ):MessagesStream(filter: dropdownValue,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0XFF3C4043),
        focusColor: Colors.blue,
        focusElevation: 100,
        splashColor: CupertinoColors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => consultation()),
          );
        },
        label: Text(' consultation'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final search;
  final filter;

  const MessagesStream({Key key, this.search,this.filter}) : super(key: key);
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
        List<MessageBubble> messageBubbles = [];

        for (var message in messages) {
          String first_name = message.data['patient_first_name'];
          String last_name = message.data['patient_last_name'];
          final experience = message.data['experience'];
          final degree = message.data['degree'];
          final email = message.data['patient_email'];
          final image = message.data['patient_image'];
          final request=message.data['request'];
          final payment= message.data['payment'];
          final age= message.data['patient_age'];
          final phone= message.data['patient_telephone'];


          final doctor_approved =message.data['doctor_approved'];

          final uid = message.data['patient_id'];

          final currentUser = loggedInUser.uid;

          final result = message.data['patient_result'];
          Color colour;
          Color p_colour;
          Color r_colour;
          if(result=='Positive')
            colour=Colors.red;
          else if(result=='pending')
            colour = Colors.yellow;
          else
            colour==Colors.green;

          if(payment=='Not Paid')
            p_colour=Colors.red;
          else if(payment=='Paid')
            p_colour==Colors.green;

          if(request=='accepted')
            r_colour=Colors.green;
          else if(request=='awaiting')
            r_colour = Colors.yellow;
          else
            r_colour==Colors.red;

          if(first_name==null)
            first_name='';
          if(last_name==null)
            last_name='';

          String name =
              first_name.toLowerCase() + ' ' + last_name.toLowerCase();

          if(filter=='Show All'){
            if (currentUser == uid && search == null) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            } else if (currentUser == uid &&
                name.contains(search.toLowerCase())) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            }
          }
          if(filter=='Positive Results' && result=='Positive'){
            if (currentUser == uid && search == null) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            } else if (currentUser == uid &&
                name.contains(search.toLowerCase())) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            }
          }
          if(filter=='Negative Results' && result=='Negative'){
            if (currentUser == uid && search == null) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            } else if (currentUser == uid &&
                name.contains(search.toLowerCase())) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            }
          }
          if(filter=='Request Accepted' && request=='accepted'){
            if (currentUser == uid && search == null) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            } else if (currentUser == uid &&
                name.contains(search.toLowerCase())) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            }
          }
          if(filter=='Result Pending' && result=='pending'){
            if (currentUser == uid && search == null) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            } else if (currentUser == uid &&
                name.contains(search.toLowerCase())) {
              final messageBubble = MessageBubble(
                first_name: first_name,
                last_name: last_name,
                experience: experience,
                degree: degree,
                email: email,
                image: image,
                request: request,
                result: result,
                colour: colour,
                doc_id: message.documentID,
                payment: payment,
                r_colour: r_colour,
                p_colour: p_colour,
                doctor_approved: doctor_approved,
                age: age,
                phone: phone,
              );

              messageBubbles.add(messageBubble);
            }
          }
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {


  MessageBubble({this.payment,this.doc_id,this.image,this.email,this.experience, this.last_name, this.degree, this.first_name, this.request, this.result, this.colour, this.p_colour, this.r_colour, this.doctor_approved, this.age, this.phone, });
  final String first_name;
  final String email;
  final String last_name;
  final String experience;
  final String degree;
  final String image;
  final String doc_id;
  final age;
  final phone;
final result;
final Color colour;
final String request;
final payment;
final p_colour;
final r_colour;
final doctor_approved;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {

        print('doc_id in recieved: $doc_id');

        if(request=='accepted')
          {
            if(result!='pending' && payment=='Paid' && doctor_approved=='approved')
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => recieved_result(doc_id: doc_id,)),
              );
            else
              showDialog(context: context, builder: (context) {return
                payment=='Paid'? AlertDialog(
                  backgroundColor:
                  Color(0xFF202125),
                  elevation: 10,

                  //shadowColor: Colors.blue,

                  title: Center(child: Text('Result is Pending!\nTry again later.',style: TextStyle(color: CupertinoColors.white),)),

                  actions: [

                    TextButton(

                      onPressed: () {Navigator.of(context).pop(true);
                      },
                      child: Text('Ok',style: TextStyle(color: CupertinoColors.white)),
                    ),

                  ],
                ):AlertDialog(
                  backgroundColor:
                  Color(0xFF202125),
                  elevation: 10,

                  //shadowColor: Colors.blue,

                  title: Center(child: Text('Payment is Pending!\nPay to view.',style: TextStyle(color: CupertinoColors.white),)),

                  actions: [
                    TextButton(
                      onPressed: () {

                        Navigator.of(context).pop(true);
                      },
                      child: Text('Pay Later',style: TextStyle(color: CupertinoColors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => jazz_cash(doc_id: doc_id,)),
                        );

                      },
                      child: Text('Pay Now',style: TextStyle(color: Colors.green)),
                    ),

                  ],
                );
              });



          }
        else
          AlertDialog(
            backgroundColor:
            Color(0xFF202125),
            elevation: 10,

            //shadowColor: Colors.blue,

            title: Center(child: Text('Request is pending.',style: TextStyle(color: CupertinoColors.white),)),

            actions: [
              TextButton(
                onPressed: () {

                  Navigator.of(context).pop(true);
                },
                child: Text('OK',style: TextStyle(color: CupertinoColors.white)),
              ),


            ],
          );
      },
      child: Card(
        color: Color(0XFF3E3F43),
        //elevation: 15,
        //shadowColor: Colors.blue,
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),*/
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${first_name} ${last_name} ",style:TextStyle(color: CupertinoColors.white)),
                  Text("Age: ${age}",style:TextStyle(color: CupertinoColors.white)),
                  Text("Phone: ${phone}",style:TextStyle(color: CupertinoColors.white)),
                  Row(
                    children: [
                      Text("Request: ",style:TextStyle(color: CupertinoColors.white)),
                      Text("$request ",style:TextStyle(color: r_colour)),
                    ],
                  ), Row(
                    children: [
                      Text("Payment: ",style:TextStyle(color: CupertinoColors.white)),
                      Text("$payment ",style:TextStyle(color: payment=='Paid'?Colors.green:Colors.red)),
                    ],
                  ),
                  payment=='Paid'?Row(
                    children: [
                      Text("Result: ",style:TextStyle(color: CupertinoColors.white)),
                      Text("$result ",style:TextStyle(color: colour)),
                    ],
                  ):Container(width:0,height: 0,),

                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProfileAvatar(
                    image,

                    borderColor: Colors.green,
                    borderWidth: 5,
                    elevation: 2,
                    radius: 50,
                    cacheImage: true,
                  ),
                ),
                Text("id:1233",style:TextStyle(color: CupertinoColors.white))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
