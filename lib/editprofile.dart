import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gender_selector/gender_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remedium/doctor_inventory.dart';
import 'package:remedium/patient_inventory.dart';
import 'consultation.dart';
import 'doctor_sign_in.dart';
import 'dart:math';

final _firestore = Firestore.instance;
final _auth = Firestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

//final user = FirebaseAuth.instance.currentUser.;
//final _auth = FirebaseAuth.instance;
String email;
String password;

class Settings extends StatelessWidget {
  final sender;

  const Settings({Key key, this.sender}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditProfile(sender:sender),
    );
  }
}

class EditProfile extends StatefulWidget {
final sender ;

  const EditProfile({Key key, this.sender}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState(sender:sender);
}

class _EditProfileState extends State<EditProfile> {
  final sender;

String docUrl;
  File _image;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String first_name;
  String last_name;
  String age;
  String gender;
  String zip_code;
  String telephone;
  String degree;
  String experience;
  String description;

  _EditProfileState({this.sender});

  Future inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid;
print('uid in editing: $uid');
print('sender in editing: $sender');
  sender=='patient'||sender=='consultation'?Firestore.instance
        .collection("Patient")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        if ( uid== result['patient_id']) {
          Firestore.instance
              .collection('Patient')
              .document(result.documentID)
              .updateData({
            "first_name": first_name,
            'last_name': last_name,
            'email': email,
            'Age': age,
            'Phone': telephone,
            'image':docUrl,
          }).then((_) {
            print("success!");
          });
        }
      });
    }):
  Firestore.instance
      .collection("doctor")
      .getDocuments()
      .then((querySnapshot) {
    querySnapshot.documents.forEach((result) {

      if ( uid== result['doc_id']) {
        Firestore.instance
            .collection('doctor')
            .document(result.documentID)
            .updateData({
          "first_name": first_name,
          'last_name': last_name,
          'email': email,
          'Age': age,
          'Phone': telephone,
          'image':docUrl,
        }).then((_) {
          print("success!");
        });
      }
    });
  });


    // Firestore.instance.collection('doctor').document(uid).get().then((value) =>value!=null?
    // Firestore.instance
    //               .collection('Patient')
    //               .document(uid)
    //               .updateData({
    //             "first_name": first_name,
    //             'last_name': last_name,
    //             'email': email,
    //             'Age': age,
    //             'Phone': telephone,
    //           }).then((_) {
    //             print("success!");
    //           }):
    // Firestore.instance.collection('Patient').document(uid).get().then((value) => value!=null? Firestore.instance
    //     .collection('Patient')
    //     .document(uid)
    //     .updateData({
    //   "first_name": first_name,
    //   'last_name': last_name,
    //   'email': email,
    //   'Age': age,
    //   'Phone': telephone,
    // }).then((_) {
    //   print("success!");
    // }):print('failure'))
    // );
  }

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

  Future get_data() async{

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
     String uid = user.uid;
    print('uid in editing: $uid');
    print('sender in editing: $sender');
    sender=='patient'||sender=='consultation'?
    Firestore.instance
        .collection("Patient")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {

        if ( uid== result.documentID) {
setState(() {
  first_name=result['first_name'];
  last_name=result['last_name'];
  age=result['age'];
  telephone=result['telephone'];
  first_name=result['first_name'];
  email=user.email;
  docUrl=result['image'];
});


        }
      });
    })
        :
    Firestore.instance
        .collection("doctor")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {

        if ( uid== result.documentID) {
          setState(() {
            first_name=result['first_name'];
            last_name=result['last_name'];
            age=result['age'];
            telephone=result['telephone'];
            first_name=result['first_name'];
            email=user.email;
            docUrl=result['image'];
          });

         // print('image : $docUrl');
        }
      });
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF202125),
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xFF202125),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () =>
         sender=='patient'|| sender == 'consultation'? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => patient_inventory()),
          ): Navigator.push(
           context,
           MaterialPageRoute(
               builder: (context) => doctor_inventory()),
         ),
        ),
        shadowColor: Colors.blue,
        /*actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: (){} ,
          ),
        ],*/
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 15, right: 16),
        child: ListView(

          children: [
            /*Text(
              'Edit Profile',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
            ),*/
            SizedBox(
              height: 15,
            ),
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.blueGrey,
                      child: _image != null
                          ? ClipOval(
                              //borderRadius: BorderRadius.circular(30),
                              child: Image.file(
                                _image, width: 100,
                                height: 100,
                                fit: BoxFit.cover,

                                // fit: BoxFit.contain,
                              ),
                            )
                          : ClipOval(
                        //borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          docUrl, width: 100,
                          height: 100,
                          fit: BoxFit.cover,

                          // fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Color(0xFF202125)),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35,
            ),
            TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: 'First Name',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: first_name,
                    hintStyle: TextStyle(color: Colors.white30,)
                ),
                style:  TextStyle(color: Colors.white,),
                onChanged: (value) {
                  first_name = value;
                }),
            SizedBox(
              height: 35,
            ),
            TextField(

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: 'Last Name',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: last_name,
                    hintStyle: TextStyle(color: Colors.white30,),

                ),  style:  TextStyle(color: Colors.white,),
                onChanged: (value) {
                  last_name = value;
                }),
            SizedBox(
              height: 35,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              style: TextStyle(color: Colors.white, ),
              decoration: InputDecoration(
                  hintText:  email,
                  hintStyle: TextStyle(color: Colors.white30,),
                  contentPadding: EdgeInsets.only(bottom: 3),
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(
              height: 35,
            ),
            TextField(
                decoration: InputDecoration(
                  hintText:   age,
                    hintStyle: TextStyle(color: Colors.white30,),
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: 'Age',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                style:  TextStyle(color: Colors.white,),
                onChanged: (value) {
                  age = value;
                }),
            SizedBox(
              height: 35,
            ),
            TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText:   telephone,
                    hintStyle: TextStyle(color: Colors.white30,)
                ),   style:  TextStyle(color: Colors.white,),
                onChanged: (value) {
                  telephone = value;
                }),
            /*TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            )*/
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    if(sender=='patient'|| sender=='consultation')
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => patient_inventory()),
                    );
                    else

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => doctor_inventory()),
                      );

                  },
                  child: Text('CANCEL',
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      )),
                ),
                RaisedButton(
                    color: Color(0XFF3C4043),
                    padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () async {
                      try {
                        if(sender=='patient'|| sender=='consultation') {
                          StorageReference reference =
                              _storage.ref().child("patient_profile/${email}");

                          //Upload the file to firebase
                          StorageUploadTask uploadTask =
                              reference.putFile(_image);
                          setState(() async {
                            docUrl = await (await uploadTask.onComplete)
                                .ref
                                .getDownloadURL();
                          });

                          // Random random = new Random();
                          inputData();
                          //
                          // int random_number = random.nextInt(100);
                          //
                          FirebaseUser user = await FirebaseAuth.instance.currentUser();
user.updateEmail(email);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => patient_inventory()),
                          );

                        }
                        else
                        {
                          StorageReference reference =
                          _storage.ref().child("doctor_profile/${email}");

                          //Upload the file to firebase
                          StorageUploadTask uploadTask =
                          reference.putFile(_image);
                          setState(() async {
                            docUrl = await (await uploadTask.onComplete)
                                .ref
                                .getDownloadURL();
                          });

                          // Random random = new Random();
                          inputData();
                          //
                          // int random_number = random.nextInt(100);
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => doctor_inventory()),
                          );

                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child:
                        Text("Submit", style: TextStyle(color: Colors.white)))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
