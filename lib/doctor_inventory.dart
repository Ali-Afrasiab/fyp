import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remedium/create_patient.dart';
import 'package:remedium/doctor_message.dart';
import 'package:remedium/nav_drawer.dart';
import 'package:remedium/patient_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;


class doctor_inventory extends StatefulWidget {
  @override
  _doctor_inventoryState createState() => _doctor_inventoryState();
}

class _doctor_inventoryState extends State<doctor_inventory> {
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
String search='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: nav_drawer(),

      appBar: new PreferredSize(
        child: new Container(

          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(1,10,1,10),
            child: Row(
              children: [IconButton(

                  icon: Icon(Icons.menu,color: CupertinoColors.white,),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),),
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

                            border: OutlineInputBorder(
                            ),
                            hintText: 'Search Patient by Name'
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  color: Color(0xFF3C4043),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0)),
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => doctor_message()),
                  );},

                  padding: EdgeInsets.fromLTRB(1, 10, 1, 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: CupertinoColors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          decoration: new BoxDecoration(
              color: Color(0xFF202125),
              boxShadow: [
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
        child: Expanded(
          child: Container(
            // width: double.infinity,
            // height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF202125),
            ),
            child: Column(

            //    color: Color(0xFF202125),

              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                search.isNotEmpty?MessagesStream(search: search,):MessagesStream(),
              ],
            ),
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
            MaterialPageRoute(builder: (context) => create_patient()),
          );
        },
        label: Text('Add Patient'),
        icon: Icon(Icons.add),

      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
 final String search;
  List<MessageBubble> messageBubbles = [];

MessagesStream({Key key, this.search}) : super(key: key);





  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('patient').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;




        for (var message in messages) {
          final String last_name = message.data['last_name'];
          final String first_name = message.data['first_name'];
          final gender = message.data['gender'];
          final date = message.data['date'];
          final email = message.data['email'];
         // message.data['result']="negative";
          String result = message.data['result'];
          String image = message.data['image'];
        //  print("result is : ${result}");
          String color;
          final name = first_name.toLowerCase() +' '+ last_name.toLowerCase();

          Color colour;
          if (result == null) {
            result = "pending";
            colour=Colors.yellowAccent;
          }
          else if( result=='Positive')
            colour=Colors.red;
          else
            colour=Colors.green;


          final uid = message.data['doctor_uid'];
          final String id =message.documentID;

          final currentUser = loggedInUser.uid;

          if(currentUser == uid && search==null){
            print(search);

            final messageBubble = MessageBubble(
              image: image,
              first_name: first_name,
              last_name:last_name,
              gender: gender,
              date: date,
              result: result,
              email: email,
              doc_id: id,
              colour: colour,
            );

            messageBubbles.add(messageBubble);
          }
          else if(currentUser == uid && name.contains(search.toLowerCase()) ){
            print(search);

            final messageBubble = MessageBubble(
              image: image,
              first_name: first_name,
              last_name:last_name,
              gender: gender,
              date: date,
              result: result,
              email: email,
              colour: colour,
              doc_id: id,
            );

            messageBubbles.add(messageBubble);

          }
        }
        return  StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('consultation').snapshots(),
          builder: (context, snapshot) {

            final messagez = snapshot.data.documents;

            for (var messagea in messagez) {
              final String patient_last_name = messagea.data['patient_last_name'];
              final String patient_first_name = messagea.data['patient_first_name'];
              final patient_gender = messagea.data['patient_gender'];
              final patient_date = messagea.data['patient_date'];
              final doc_email = messagea.data['email'];
              final patient_email = messagea.data['patient_email'];
              final request = messagea.data['request'];
              final payment = messagea.data['payment'];

              // message.data['result']="negative";

              String patient_result = messagea.data['patient_result'];
              String patient_image = messagea.data['patient_image'];
              //  print("result is : ${result}");
              Color colour;
              Color p_colour;
              if (patient_result == 'pending') {

colour=Colors.yellowAccent;
              }
              else if( patient_result=='Positive')
                colour=Colors.red;
              else
                colour=Colors.green;

              if(payment=='Not Paid')
                p_colour=Colors.red;
              else if(payment=='Paid')
                p_colour==Colors.green;

              final uid = messagea.data['doctor_uid'];
              final  id =messagea.documentID;

              final currentUser = loggedInUser.uid;

              if(currentUser ==id && request=="accepted" && search==null){
                final messageBubble = MessageBubble(
                  image: patient_image,
                  first_name: patient_first_name,
                  last_name:patient_last_name,
                  gender: patient_gender,
                  date: patient_date,
                  result: patient_result,
                  email: patient_email,
                  doc_id: id,
                  colour: colour,
                  payment: payment,
                  p_colour: p_colour,
                );

                messageBubbles.add(messageBubble);
              }
              else if(currentUser ==doc_email && request=="accepted" && patient_first_name.contains(search) ){
                final messageBubble = MessageBubble(
                  image: patient_image,
                  first_name: patient_first_name,
                  last_name:patient_last_name,
                  gender: patient_gender,
                  date: patient_date,
                  result: patient_result,
                  email: patient_email,
                  doc_id: id,
                  colour: colour,
                  payment: payment,
                  p_colour: p_colour,
                );

                messageBubbles.add(messageBubble);
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
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.doc_id,this.email,this.image, this.first_name, this.gender, this.date, this.result, this.last_name, this.colour, this.p_colour, this.payment});
  final String email;
  final String first_name;
  final String last_name;
  final String gender;
  final String date;
  final String result;
  final String image;
  final String doc_id;
  final Color colour;
  final Color p_colour;
  final payment;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => patient_profile(
                   doc_id: doc_id ,
                  )),
        );
      },
      child: Card(
        color: Color(0XFF3E3F43),
        elevation: 15,
        shadowColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${first_name}${last_name}",style:TextStyle(color: CupertinoColors.white)),
                  Text("Gender: ${gender}",style:TextStyle(color: CupertinoColors.white)),
                  Text("Test Date: ${date}",style:TextStyle(color: CupertinoColors.white)),
                  Row(
                    children: [
                      Text("COVID-19 Status:",style:TextStyle(color: CupertinoColors.white)),

                      Text(" ${result}",style:TextStyle(color: colour,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  payment ==null?Container(width: 0,height: 0,):Row(
                    children: [
                      Text("Payment:",style:TextStyle(color: CupertinoColors.white)),

                      Text(" ${payment}",style:TextStyle(color:payment=='Paid'?Colors.green:Colors.red,fontWeight: FontWeight.bold)),
                    ],
                  ),

                ],
              ),
            ),
            Column(
              children: [
                CircularProfileAvatar(
                  image,
                  //child: FlutterLogo(),
                  cacheImage: true,
                  borderColor: colour,
                  borderWidth: 5,
                  elevation: 2,
                  radius: 50,
                ),
                Text("id:",style:TextStyle(color: CupertinoColors.white))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
