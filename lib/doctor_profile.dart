import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remedium/consultation.dart';
import 'package:remedium/covid.dart';
import 'package:remedium/doctor_inventory.dart';
import 'package:remedium/patient_inventory.dart';
import 'package:remedium/report_generate.dart';
import 'doctor_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM-dd');
final String formatted = formatter.format(now);
FirebaseStorage _storage = FirebaseStorage.instance;

final _firestore = Firestore.instance;

FirebaseUser loggedInUser;

class doctor_profile extends StatefulWidget {
  final doc_id;
  doctor_profile({this.doc_id});

  @override
  _doctor_profileState createState() => _doctor_profileState(doc_id: doc_id);
}

class _doctor_profileState extends State<doctor_profile> {
  _doctor_profileState({this.doc_id});
  final String doc_id;
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

  @override
  Widget build(BuildContext context) {
    var _value;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new PreferredSize(
        child: new Container(
          //padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          padding: EdgeInsets.all(20),
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
                      MaterialPageRoute(builder: (context) => consultation()),
                    );
                  }),
              Text("Doctor Profile",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
          decoration: new BoxDecoration(color: Color(0xFF202125), boxShadow: [
            new BoxShadow(
              color: Colors.blue,
              blurRadius: 20.0,
              spreadRadius: 1.0,
            ),
          ]),
        ),
        preferredSize: new Size(MediaQuery.of(context).size.width, 50.0),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(doc_id: doc_id),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({this.doc_id});

  final String doc_id;
  String fav_id;
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
  String description;
  String experience;
  String degree;
  String image;

  String patient_email;
  String patient_first_name;
  String patient_last_name;
  String patient_gender;
  String patient_condition;
  String patient_telephone;
  String patient_result;
  String patient_age;
  String patient_date;

  String patient_image;
  String patient_id;
  String symptoms;

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
        // List<MessageBubble> messageBubbles = [];

        for (var message in messages) {
          if (message.documentID == doc_id) {
            email = message.data['email'];
            first_name = message.data['first_name'];
            last_name = message.data['last_name'];
            gender = message.data['gender'];
            description = message.data['description'];
            experience = message.data['experience'];
            telephone = message.data['telephone'];
            age = message.data['age'];
            degree = message.data['degree'];
            image = message.data['image'];

            fav_id = message.data['doc_id'];
          }
        }

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Patient')
              .where('patient_id', isEqualTo: loggedInUser.uid)
              .snapshots(),
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

            for (var message in messages) {


              patient_email = message.data['email'];
              patient_first_name = message.data['first_name'];
              patient_last_name = message.data['last_name'];
              patient_gender = message.data['gender'];
              patient_telephone = message.data['telephone'];
              patient_age = message.data['age'];
              patient_image = message.data['image'];
              patient_id = message.data['patient_id'];
            }

            return Expanded(
                child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF202125),
              ),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Color(0XFF3E3F43),
                          elevation: 10,
                          //shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: CircularProfileAvatar(
                                  image==null?'':image,
                                  borderColor: Colors.blueGrey,
                                  borderWidth: 2,
                                  elevation: 5,
                                  radius: 80,
                                  cacheImage: true,
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  color: Color(0XFF3E3F43),
                                  // elevation: 50,

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Name : ",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            "${first_name} ${last_name}",
                                            style: TextStyle(
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Gender : ",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            "${gender}",
                                            style: TextStyle(
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Age : ",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            "${age}",
                                            style: TextStyle(
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Card(
                            color: Color(0XFF3E3F43),
                            elevation: 10,

                            //shadowColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: //add to favourite
                                Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                fav_card(
                                    doc_id: fav_id, patient_id: patient_id),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Card(
                            color: Color(0XFF3E3F43),
                            elevation: 10,

                            //shadowColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Email : ",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            "${email}",
                                            style: TextStyle(
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Phone : ",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            "${telephone}",
                                            style: TextStyle(
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Experience : ",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            "${experience}",
                                            style: TextStyle(
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Degree : ",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            "${degree}",
                                            style: TextStyle(
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
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
                        Column(
                          children: [
                            Text(
                              "Description: ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.white),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Card(
                            color: Color(0XFF3E3F43),
                            elevation: 10,

                            //shadowColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("${description}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: CupertinoColors.white)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("STATUS: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: CupertinoColors.white)),
                                Text("Available",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: CupertinoColors.white)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Color(0XFF3C4043),
                    focusColor: Colors.blue,
                    focusElevation: 100,
                    splashColor: CupertinoColors.white,
                    onPressed: () async {
                      try {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Color(0XFF3E3F43),
                                elevation: 10,

                                //shadowColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                title: Text('Confirm your details'),
                                content: Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "First Name : ",
                                              style: TextStyle(),
                                            ),
                                            // Text("${email}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                            Container(
                                              width: 150,
                                              child: TextField(
                                                onChanged: (value) =>
                                                    first_name = value,
                                                decoration: InputDecoration(
                                                    hintText: '$first_name'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Last Name : ",
                                              style: TextStyle(),
                                            ),
                                            // Text("${email}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                            Container(
                                              width: 150,
                                              child: TextField(
                                                onChanged: (value) =>
                                                    last_name = value,
                                                decoration: InputDecoration(
                                                    hintText: '$last_name'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Email : ",
                                              style: TextStyle(),
                                            ),
                                            // Text("${email}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                            Container(
                                              width: 150,
                                              child: TextField(
                                                onChanged: (value) =>
                                                    email = value,
                                                decoration: InputDecoration(
                                                    hintText: '$email'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Phone : ",
                                              style: TextStyle(),
                                            ),
                                            // Text("${email}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                            Container(
                                              width: 150,
                                              child: TextField(
                                                onChanged: (value) =>
                                                    telephone = value,
                                                decoration: InputDecoration(
                                                    hintText: '$telephone'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Symptoms : ",
                                              style: TextStyle(),
                                            ),
                                            // Text("${email}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                            Container(
                                              width: 150,
                                              child: TextField(
                                                onChanged: (value) =>
                                                    symptoms = value,
                                                decoration: InputDecoration(
                                                    hintText: 'Symptoms'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        add_pic()
                                      ],
                                    ),
                                  ),
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      StorageReference reference = _storage
                                          .ref()
                                          .child("doctor_profile/${email}");

                                      //Upload the file to firebase
                                      StorageUploadTask uploadTask =
                                          reference.putFile(_image);
                                      String docUrl =
                                          await (await uploadTask.onComplete)
                                              .ref
                                              .getDownloadURL();
                                      _firestore
                                          .collection('consultation')
                                          .document(doc_id)
                                          .setData({
                                        'first_name': first_name,
                                        'email': email,
                                        'last_name': last_name,
                                        'age': age,
                                        'gender': gender,
                                        'degree': degree,
                                        'telephone': telephone,
                                        'request': "awaiting",
                                        'experience': experience,
                                        'description': description,
                                        'image': image,
                                        'doctor_doc_id': doc_id,
                                        'patient_id': patient_id,
                                        'patient_first_name':
                                            patient_first_name,
                                        'patient_email': patient_email,
                                        'patient_last_name': patient_last_name,
                                        'patient_age': patient_age,
                                        'patient_gender': patient_gender,
                                        'patient_telephone': patient_telephone,
                                        'request': "awaiting",
                                        'patient_image': patient_image,
                                        'date': formatted,
                                        'symptoms': symptoms,
                                        'x-ray': docUrl,
                                        'patient_result': 'pending',
                                        'payment':'Not Paid',
                                      });

                                      AlertDialog(
                                        backgroundColor: Color(0XFF3E3F43),
                                        elevation: 10,

                                        //shadowColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        title:
                                            Text('Your request has been sent!'),

                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                patient_inventory()),
                                      );
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            });
                      } catch (e) {
                        print(e);
                      }
                    },
                    label: Text('Send Request'),
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ));
          },
        );
      },
    );
  }
}

File _image;

class fav_card extends StatefulWidget {
  final patient_id;
  final doc_id;

  const fav_card({Key key, this.patient_id, this.doc_id}) : super(key: key);

  @override
  _fav_cardState createState() =>
      _fav_cardState(doc_id: doc_id, patient_id: patient_id);
}

List favourites;

class _fav_cardState extends State<fav_card> {
  final patient_id;
  final doc_id;
  var liked = false;

  _fav_cardState({this.patient_id, this.doc_id});
  Future<void> get_fav() async {
    List a;

    await _firestore.collection('favourites').document(patient_id).get().then(
        (value) =>
            value.exists ? a = value['liked'] : print('favourites is null'));
    setState(() {
      favourites = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    get_fav();
    return Row(
      children: [
        favourites != null && favourites.contains('$doc_id')
            ? Text(
                'Already in Favourites',
                style: TextStyle(color: CupertinoColors.white),
              )
            : Text(
                'Add to Favourites',
                style: TextStyle(color: CupertinoColors.white),
              ),
        IconButton(
          onPressed: () {
            if (FirebaseAuth.instance.currentUser == null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Sign in to add to favourites.'),
                      actions: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('OK'),
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              print('initial : ${favourites}');

              if (favourites == null) {
                favourites = ['${doc_id}'];
                _firestore
                    .collection('favourites')
                    .document(patient_id)
                    .setData({'liked': FieldValue.arrayUnion(favourites)});
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(milliseconds: 1000), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        title: Text('Added to favourites'),
                      );
                    });
                setState(() {
                  liked = true;
                });
              } else if (!favourites.contains(doc_id)) {
                // favourites.add('doc_id');

                favourites = [...favourites, '$doc_id'];
                _firestore
                    .collection('favourites')
                    .document(patient_id)
                    .setData({'liked': FieldValue.arrayUnion(favourites)});
                print('favourites after added');
                print(favourites);
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(milliseconds: 1000), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        title: Text('Added to favourites'),
                      );
                    });
                setState(() {
                  liked = true;
                });
              } else {
                favourites[favourites.indexOf(doc_id)] = '';
                if (favourites.isEmpty) {
                  _firestore
                      .collection('favourites')
                      .document(patient_id)
                      .delete()
                      .whenComplete(() => print('deleted'));
                } else {
                  _firestore
                      .collection('favourites')
                      .document(patient_id)
                      .setData({
                    'liked': FieldValue.arrayUnion(favourites)
                  }).whenComplete(() => print('removed'));
                }
                print('favourites after removed');
                print(favourites);
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(milliseconds: 1000), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        title: Text('removed from favourites'),
                      );
                    });
                setState(() {
                  liked = false;
                });
              }
              // Scaffold.of(context).showSnackBar(snackBar);

            }

            print(favourites);
          },
          icon: favourites != null && favourites.contains('$doc_id')
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          color: Colors.red,
        ),
      ],
    );
  }
}

class add_pic extends StatefulWidget {
  const add_pic({Key key}) : super(key: key);

  @override
  _add_picState createState() => _add_picState();
}

class _add_picState extends State<add_pic> {
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Text("Select X-Ray image",
              style: TextStyle(color: CupertinoColors.white)),
          SizedBox(
            width: 8,
          ),
          Card(
            color: Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: IconButton(
                icon: Icon(
                  Icons.add_a_photo_sharp,
                  color: CupertinoColors.white,
                ),
                onPressed: () {
                  _showPicker(context);
                }),
          ),
        ],
      ),
    );
  }
}
