

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remedium/ChangePassword.dart';
import 'package:remedium/doctor_sign_in.dart';
import 'package:remedium/patient_inventory.dart';
import 'consultation.dart';
import 'doctor_inventory.dart';
import 'editprofile.dart';
import 'main.dart';

class nav_drawer extends StatelessWidget {
  final sender;

   nav_drawer({this.sender});
  @override
  Widget build(BuildContext context) {
    print('sender for drawer : $sender');
    return Drawer(
      child: Container(
        child: ListView(

          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(decoration: new BoxDecoration(
                color: Color(0xFF202125),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.blue,
                    blurRadius: 20.0,
                    spreadRadius: 1.0,
                  ),
                ]),
              child: DrawerHeader(
                child: Center(
                  child: Text(
                    'Remedium',
                    style: TextStyle(color: Colors.white, fontSize: 25, letterSpacing: 2.2),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Color(0xFF202125),
                    /*image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/cover.jpg'))*/
                ),
              ),
            ),

            ListTileTheme(
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Color(0xFF202125),
              child: ListTile(
                leading: Icon(Icons.inventory),
                title: sender!=null && sender=='consultation'|| sender=='patient'?Text('Reports Inventory'):Text('Patients Inventory'),

                onTap: () => {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => sender!=null && sender=='consultation'|| sender=='patient'?patient_inventory():doctor_inventory(),
                    ),
                  ),
                },
              ),
            ),
            sender!=null && sender=='consultation'|| sender=='patient'?ListTileTheme(
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Color(0xFF202125),
              child: ListTile(
                leading: Icon(Icons.favorite_outlined),
                title: Text('Favourites'),
                onTap: () => {

                     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => consultation(sender:'favourites'),
                    ),
                  ),
                },
              ),
            ):Container(width:0,height:0),
            ListTileTheme(
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Color(0xFF202125),
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () => {
                  print('sender : $sender'),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(
                        sender:sender
                      ),
                    ),
                  ),
                },
              ),
            ),

            /*ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Profile'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),*/
            ListTileTheme(
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Color(0xFF202125),
              child: ListTile(
                //tileColor: Colors.blueGrey,
                leading: Icon(Icons.vpn_key),
                title: Text('Change Password'),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(),
                    ),
                  );
                },
              ),
            ),
            ListTileTheme(
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Color(0xFF202125),
              child: ListTile(
              //tileColor: Colors.blueGrey,
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
            ),
            ),
            Column(
              children: [

              Container(
                width: 500,
                height: 1000,

                decoration: new BoxDecoration(
                    color: Color(0xFF202125),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.blue,
                        blurRadius: 20.0,
                        spreadRadius: 1.0,
                      ),
                    ]),



              )
            ],)
          ],
        ),
      ),
    );
  }

}




