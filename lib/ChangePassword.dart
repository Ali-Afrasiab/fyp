import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:remedium/patient_inventory.dart';


class ChangePassword extends StatefulWidget {

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>{


  bool recently_logged_in=false;
  String new_password;
   String confirm_password;
   String old_password;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF202125),
      appBar: AppBar(
        backgroundColor: Color(0xFF202125),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CupertinoColors.white,
          ),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => patient_inventory(

                ),
              ),
            );
          },
        ),
          title: Text("Password Settings"),
        shadowColor: Colors.blue,
    ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 15, right: 16),
        child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 150, right: 16),
            child: Center(child: Text(
              recently_logged_in==true?"Create new Password":'Confirm your old Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 2.2,
                //fontFamily: "Source Sans Pro",
              ),
            )),
          ),
          SizedBox(
          height: 50,
        ),
         recently_logged_in==false?
         TextField(
            onChanged:(value)=>old_password=value ,
            style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.only(bottom: 20),
    labelText: 'old Password',
    labelStyle: TextStyle(
    color: Colors.white,
    fontSize: 20
    ),
    //floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    ):
          TextField(
            onChanged:(value)=>new_password=value ,
            style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.only(bottom: 20),
    labelText: 'New Password',
    labelStyle: TextStyle(
    color: Colors.white,
    fontSize: 20
    ),
    //floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    ),
          SizedBox(
          height: 40,
    ),

         recently_logged_in==true?
         TextField(
            onChanged:(value)=>confirm_password=value ,
            style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.only(bottom: 20),
    labelText: 'Re-enter new Password',
    labelStyle: TextStyle(
    color: Colors.white,
    fontSize: 20
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    ):Container(width: 0,height: 0,),
          SizedBox(
            height: 35,
        ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              RaisedButton(
                color: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 65),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                onPressed: () async {
                  FirebaseUser current = await FirebaseAuth.instance.currentUser();
                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: current.email, password: old_password).onError((error, stackTrace) =>  showDialog(

                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('wrong old password.'),
                          actions: [
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChangePassword(

                                      ),
                                    ),
                                  );
                                },
                                child: Text('OK'),
                              ),
                            ),
                          ],
                        );
                      }))
                      .whenComplete(() async {
                    setState(() {
                      recently_logged_in=true;
                    });
                  } );
                  if(new_password==confirm_password && new_password.length>=6)
                  {



                    await current.updatePassword(new_password);

                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Password Changed Successfully.'),
                            actions: [
                              Center(
                                child: TextButton(
                                  onPressed: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => patient_inventory(

                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('OK'),
                                ),
                              ),
                            ],
                          );
                        });

                  }
                  else if(new_password!=confirm_password)
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Password does not match.'),
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
                  else
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Must be 6 characters long'),
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


                },
                child: Text(recently_logged_in==true?'CONFIRM PASSWORD CHANGES':'CONFIRM OLD PASSWORD',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 2.2,
                      color: Colors.white,
                    )
                ),
              ),
      ]
          ),

  ]),
    ),
    );
  }
}