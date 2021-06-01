import 'package:custom_cupertino_date_textbox/custom_cupertino_date_textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remedium/jarvis.dart';

class chatbot_data_collect extends StatefulWidget {
  const chatbot_data_collect({Key key}) : super(key: key);

  @override
  _chatbot_data_collectState createState() => _chatbot_data_collectState();
}

class _chatbot_data_collectState extends State<chatbot_data_collect> {
  String gender='';
  List issues=[];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:  Color(0xFF202125),
          shadowColor: Colors.blue,
          elevation: 5,
          title: Text('Jarvis'),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/chatbot_data_collect.jpg"
                  ),
                  fit: BoxFit.cover
              )
          ),
        child: ListView(

          children: [


            Padding(
              padding: const EdgeInsets.only(left:25.0,right:180,top: 50),
              child: TextFormField(

                decoration: InputDecoration(
                    border: UnderlineInputBorder(

                    ),

                    labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black)

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 180,top: 25),
              child: CustomizableCupertinoDateTextBox(
                initialValue: DateTime.now(),
                hintText: "Date",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Do you have issues with?',
                    style: TextStyle(
                      //color: CupertinoColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),

                  ),
                ],
              ),
            ),
            Container(

              child: GridView.count(
                ///harresement :work place, street, schools, /physical violence:home parents, siblings, children's, husband/employee bullying boss
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
             shrinkWrap: true,
             childAspectRatio:3.8,

             children: <Widget>[
                  RaisedButton(
                    onPressed: () {

                      setState(() {
                      if(issues.contains('parents'))
                        issues.remove('parents');
                        else
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
               RaisedButton(
                 onPressed: () {
                   setState(() {
                     if(issues.contains('siblings'))
                       issues.remove('siblings');
                     else
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
               RaisedButton(
                 onPressed: () {
                   setState(() {
                     if(issues.contains('children'))
                       issues.remove('children');
                     else
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
               RaisedButton(
                 onPressed: () {
                   setState(() { if(issues.contains('husband/wife'))
                     issues.remove('husband/wife');
                   else
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Did you suffered any Harassment at?',
                    style: TextStyle(
                      //color: CupertinoColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),

                  ),
                ],
              ),
            ),
            Container(

              child: GridView.count(
                ///harresement :work place, street, schools, /physical violence:home parents, siblings, children's, husband/employee bullying boss
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio:3.8,

                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() { if(issues.contains('Work place'))
                        issues.remove('Work place');
                      else
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
                  RaisedButton(
                    onPressed: () {
                      setState(() { if(issues.contains('street'))
                        issues.remove('street');
                      else
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
                  ),RaisedButton(
                    onPressed: () {
                      setState(() {if(issues.contains('schools'))
                        issues.remove('schools');
                      else
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
                  ),RaisedButton(
                    onPressed: () {
                      setState(() {if(issues.contains('physical violence'))
                        issues.remove('physical violence');
                      else
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
                ],
              ),
            ),

          ],
        ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => jarvis()
              ),
            );
          },
          label: Text('Continue'),
          icon: Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
