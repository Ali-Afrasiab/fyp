import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remedium/create_patient.dart';
import 'package:remedium/nav_drawer.dart';
import 'package:remedium/patient_inventory.dart';
import 'package:remedium/patient_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'doctor_profile.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;


class consultation extends StatefulWidget {
  final sender;

 consultation({Key key, this.sender}) : super(key: key);

  @override
  _consultationState createState() => _consultationState(sender: sender);
}
List a;


class _consultationState extends State<consultation> {

  Future<void> get_fav() async {

final current_user= loggedInUser;
    await _firestore
        .collection('favourites')
        .document(current_user.uid)
        .get()
        .then((value) => value.exists
        ? a = value['liked']
        : print('favourites is null'));
    print('a $a');
  }

  final sender;
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  _consultationState({this.sender});

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
  String dropdownValue = 'name';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    get_fav();
    return Scaffold(
      key: _scaffoldKey,
      drawer: nav_drawer(sender: 'consultation',),
      appBar: new PreferredSize(
        child: new Container(

          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(

                  icon: Icon(Icons.more_vert,color: CupertinoColors.white,),
                  onPressed: ()=> _scaffoldKey.currentState.openDrawer(),),
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
                            hintText:
                            sender!=null &&sender =='favourites'?'Search favourites by $dropdownValue':'Search Doctors by $dropdownValue'
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                new DropdownButton<String>(
hint: Text(''),
                  dropdownColor: Color(0xFF202125),

                  icon:  Icon(Icons.filter_alt_outlined,color: CupertinoColors.white,),
                  items: <String>['name', 'degree',].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value,style: TextStyle(color: CupertinoColors.white),),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue=value;
                    });
                    print('filter : $dropdownValue');
                  },
                ),

              ],
            ),
          ),
          decoration: new BoxDecoration(
              color: Color(0xFF202125),
              boxShadow: [
                new BoxShadow(
                  color: sender!=null && sender=='favourites'?Colors.pinkAccent:Colors.blue,
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                ),
              ]),
        ),
        preferredSize: new Size(MediaQuery.of(context).size.width, 80.0),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF202125),
          ),
          child: Column(
            //    color: Color(0xFF202125),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              search.isNotEmpty?MessagesStream(search: search,filter:dropdownValue,sender: sender,):MessagesStream(sender: sender,),
            ],
          ),
        ),
      ),
    /*  floatingActionButton: FloatingActionButton.extended(
        backgroundColor:Color(0XFF3C4043),
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

      ),*/
      floatingActionButton: sender!=null&& sender=='favourites'?FloatingActionButton.extended(
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
      ):FloatingActionButton.extended(
        backgroundColor: Color(0XFF3C4043),
    focusColor: Colors.blue,
    focusElevation: 100,
    splashColor: CupertinoColors.white,
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => patient_inventory()),
    );
    },
    label: Text('Report Inventory'),
    icon: Icon(Icons.inventory),
    ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String search;
  final String filter;
  final sender;
  List<MessageBubble> messageBubbles = [];
   MessagesStream({Key key, this.search, this.filter,this.sender}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('doctor').snapshots(),
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
print('doc_id ${message.data['doc_id']}');
            String first_name = message.data['first_name'];
            String last_name = message.data['last_name'];
            final experience = message.data['experience'];
            final String degree = message.data['degree'];
            final email = message.data['email'];
            final image = message.data['image'];
            final doc_id = message.documentID;

            //print(image);
            if(first_name==null)
              first_name='';
            if(last_name==null)
              last_name='';

            String name =
                first_name.toLowerCase() + ' ' + last_name.toLowerCase();

            if(sender!='favourites')

            {
              print('!=condition working');
            if (search == null) {

              final messageBubble = MessageBubble(
                  first_name: first_name,
                  last_name: last_name,
                  experience: experience,
                  degree: degree,
                  email: email,
                  image: image,
                  doc_id: doc_id,
              sender: sender,);

              messageBubbles.add(messageBubble);
            }
            else if (filter == 'name' &&
                name.contains(search.toLowerCase())) {
              print(search);
              final messageBubble = MessageBubble(
                  first_name: first_name,
                  last_name: last_name,
                  experience: experience,
                  degree: degree,
                  email: email,
                  image: image,
                  doc_id: doc_id,
                sender: sender,);

              messageBubbles.add(messageBubble);
            } else if (filter == 'degree' &&
                degree.contains(search.toLowerCase())) {
              print(search);
              final messageBubble = MessageBubble(
                  first_name: first_name,
                  last_name: last_name,
                  experience: experience,
                  degree: degree,
                  email: email,
                  image: image,
                  doc_id: doc_id,
                sender: sender,);

              messageBubbles.add(messageBubble);
            }
          }
            else if(a!=null && a.contains(message.data['doc_id']))
            {
              print('condition working');
              if (search == null) {
                final messageBubble = MessageBubble(
                    first_name: first_name,
                    last_name: last_name,
                    experience: experience,
                    degree: degree,
                    email: email,
                    image: image,
                    doc_id: doc_id,
                  sender: sender,);

                messageBubbles.add(messageBubble);
              } else if (filter == 'name' &&
                  name.contains(search.toLowerCase())) {
                print(search);
                final messageBubble = MessageBubble(
                    first_name: first_name,
                    last_name: last_name,
                    experience: experience,
                    degree: degree,
                    email: email,
                    image: image,
                    doc_id: doc_id,
                  sender: sender,);

                messageBubbles.add(messageBubble);
              } else if (filter == 'degree' &&
                  degree.contains(search.toLowerCase())) {
                print(search);
                final messageBubble = MessageBubble(
                    first_name: first_name,
                    last_name: last_name,
                    experience: experience,
                    degree: degree,
                    email: email,
                    image: image,
                    doc_id: doc_id,
                  sender: sender,);

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


  MessageBubble({this.sender,this.doc_id,this.image,this.email,this.experience, this.last_name, this.degree, this.first_name, });
  final String first_name;
  final String sender;
  final String email;
  final String last_name;
  final String experience;
  final String degree;
  final String image;
  final String doc_id;


  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => doctor_profile(doc_id: doc_id,
              )),
        );

      },
      child: Card(
        color: Color(0XFF3E3F43),
        elevation: 15,
        shadowColor: sender!=null && sender=='favourites'?Colors.pinkAccent:Colors.blue,
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
                  Text("Name: ${first_name}${last_name} ",style:TextStyle(color: CupertinoColors.white)),
                  Text("Degree: ${degree}",style:TextStyle(color: CupertinoColors.white)),
                  Text("Experience: ${experience}",style:TextStyle(color: CupertinoColors.white)),


                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProfileAvatar(
                   image,

                    borderColor: Colors.purpleAccent,
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











