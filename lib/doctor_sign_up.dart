import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gender_selector/gender_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:remedium/doctor_inventory.dart';
import 'doctor_sign_in.dart';
import 'doctor_info.dart';

final _firestore = Firestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

class doctor_sign_up extends StatefulWidget {
  @override
  _doctor_sign_upState createState() => _doctor_sign_upState();
}

class _doctor_sign_upState extends State<doctor_sign_up> {

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

  File _image;
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }
  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }
  bool loading=false;
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
        }
    );
  }

 /* Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('doctor_profile/${_image.path}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    var _value;
    String  _uploadedFileURL;
    return Stack(

      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: new PreferredSize(
            child: new Container(
              padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: new Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
                  child: Row(
                    children: [
                      IconButton(

                          icon: Icon(Icons.arrow_back,color: CupertinoColors.white,),
                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => doctor_sign_in()),
                            );
                          }),
                      Column(
                        children: [
                          Text("Let\'s get you set up!                      ",
                              style: TextStyle(fontSize: 20, color: CupertinoColors.white)),
                          Text(
                              " Fill out the form below so we can get you started.",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white70)),
                        ],
                      ),
                    ],
                  )),
              decoration: new BoxDecoration(

                  color: Color(0xFF202125),

                  boxShadow: [
                    new BoxShadow(
                      color: Colors.blue,
                      blurRadius: 20.0,
                      spreadRadius: 1.0,
                    ),
                  ]
              ),
            ),
            preferredSize: new Size(MediaQuery.of(context).size.width, 80.0),
          ),
          body: Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF202125),
              ),
              child: ListView(
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
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Personal Information                                        ",
                              style: TextStyle(fontSize: 20,color: CupertinoColors.white)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(style: TextStyle(color: Colors.white),
                                  onChanged: (value){
                                    first_name=value;
                                  },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),

                                    filled: true,
                                    hintStyle:
                                    new TextStyle(color: Color(0XFFDCDDE1)),
                                    hintText: "First Name",
                                    fillColor: Color(0xFF3C4043),),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(style: TextStyle(color: Colors.white),
                                  onChanged: (value){
                                    last_name=value;
                                  },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    new TextStyle(color: Color(0XFFDCDDE1)),
                                    hintText: "Last Name",

                                    fillColor: Color(0xFF3C4043),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(style: TextStyle(color: Colors.white),
                                  onChanged: (value){
                                    age=value;
                                  },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    new TextStyle(color: Color(0XFFDCDDE1)),
                                    hintText: "Age",
                                    fillColor: Color(0xFF3C4043),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: DropdownButton(
                                  hint: Text('gender'),
                                  iconDisabledColor: Color(0xFF3C4043),
                                  onChanged: (value) {value==1?gender="male":gender="female";},
                                  value: 1,
                                  dropdownColor: Color(0xFF3C4043),

                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Male" ,
                                          style: TextStyle(color: Colors.white), ),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(

                                      child: Text("Female",
                                        style: TextStyle(color: Colors.white),),
                                      value: 2,
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Contact Info                                        ",
                              style: TextStyle(fontSize: 24,color: CupertinoColors.white)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(style: TextStyle(color: Colors.white),
                                  onChanged: (value){
                                    password=value;
                                  },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    new TextStyle(color: Color(0XFFDCDDE1)),
                                    hintText: "Password",
                                    fillColor: Color(0xFF3C4043),),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(style: TextStyle(color: Colors.white),
                                  onChanged: (value){
                                    email=value;
                                  },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    new TextStyle(color: Color(0XFFDCDDE1)),
                                    hintText: "Email",
                                    fillColor: Color(0xFF3C4043),),




                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(style: TextStyle(color: Colors.white),onChanged: (value){
                                  zip_code=value;
                                },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    new TextStyle(color: Color(0XFFDCDDE1)),
                                    hintText: "Zip Code",
                                    fillColor: Color(0xFF3C4043),),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child:TextField(style: TextStyle(color: Colors.white),onChanged: (value){
                                  telephone=value;
                                },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    new TextStyle(color: Color(0XFFDCDDE1)),
                                    hintText: "Jazz cash Number",
                                    fillColor: Color(0xFF3C4043),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Qualifications                                        ",
                              style: TextStyle(fontSize: 24,color: CupertinoColors.white)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(style: TextStyle(color: Colors.white),
                                  onChanged: (value){
                                    degree=value;
                                  },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    new TextStyle(color: Color(0XFFDCDDE1)),
                                    hintText: "Degree",
                                    fillColor: Color(0xFF3C4043),),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(style: TextStyle(color: Colors.white),
                                  onChanged: (value){
                                    experience=value;
                                  },
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    new TextStyle(color: Color(0XFFDCDDE1)),
                                    hintText: "Experience",
                                    fillColor: Color(0xFF3C4043),),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(style: TextStyle(color: Colors.white),
                      onChanged: (value){
                        description=value;
                      },
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(50.0),
                          ),
                        ),
                        filled: true,
                        hintStyle:
                        new TextStyle(color: Color(0XFFDCDDE1)),
                        hintText: "Description",
                        fillColor: Color(0xFF3C4043),),
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                        color: Color(0XFF3C4043),
                        padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                        shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed:() async{
                          setState(() {
                            loading =true;
                          });
                          try{
                            if(telephone!=null && telephone.length==11){
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
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
                              //final newUser = await _auth.createUserWithEmailAndPassword(email: email , password: password);
                              Random random = new Random();

                              int random_number = random.nextInt(100);
                              _firestore
                                  .collection('doctor')
                                  .document(newUser.uid)
                                  .setData({
                                'first_name': first_name,
                                'email': email,
                                'last_name': last_name,
                                'age': age,
                                'gender': gender,
                                'zip_code': zip_code,
                                'telephone': telephone,
                                'degree': degree,
                                'experience': experience,
                                'description': description,
                                'image': docUrl,
                                'unique_id': random_number,
                                'doc_id': newUser.uid,
                                'availability':'',
                                'base_price':''
                              });

                              if (newUser != null)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => doctor_info(doc_id: newUser.uid,)
                                  ),
                                );
                            }
                            else {
                              setState(() {
                                loading=false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Color(0XFF3E3F43),
                                      elevation: 10,

                                      //shadowColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      title: Text(
                                        'Kindly add a valid Jazz cash account number',
                                        style: TextStyle(
                                            color: CupertinoColors.white),
                                      ),
                                      content: Text(
                                        'A jazz cash account must be added to recieve payments',
                                        style: TextStyle(
                                            color: CupertinoColors.white),
                                      ),

                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          }
                          catch(e){

                          setState(() {
                            loading=false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Color(
                                      0XFF3E3F43),
                                  elevation: 10,

                                  //shadowColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        25.0),
                                  ),
                                  title:
                                  Text(
                                    'Email or Password is invalid',style: TextStyle(color: CupertinoColors.white),),
                                  content:   Text(
                                    'Password should be at least 6 characters, 3 words and 3 letters',style: TextStyle(color: CupertinoColors.white),),

                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                       Navigator.pop(context);
                                      },
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              });
                          }
                        },
                        child: Text("Submit",style:TextStyle(color: Colors.white))),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading== true?Center(
          child: Expanded(
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.black.withOpacity(0.5)
              ),
              width: double.infinity,
              height: double.infinity,
              child: LoadingBouncingGrid.square(
                borderColor: Colors.lightBlue,
                borderSize: 3.0,
                size: 70.0,
                backgroundColor: Colors.blue,
                duration: Duration(milliseconds: 500),
              ),
            ),
          ),
        ):Container(width: 0,height: 0,)
      ],
    );
  }
}











