import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

import 'doctor_inventory.dart';

class doctor_info extends StatefulWidget {
  doctor_info({Key key, this.doc_id}) : super(key: key);
  final doc_id;
  @override
  _doctor_infoState createState() => _doctor_infoState(doc_id);
}

class _doctor_infoState extends State<doctor_info> {
  final doc_id;

  _doctor_infoState(this.doc_id);
String base_amount;
bool loading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF202125),
        elevation: 15,
        shadowColor: Colors.blue,
        title: Text('One more Step to go!'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF202125),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:150.0),
                  child: Text('Enter Base Fee Amount',
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                ),
                 Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    style: TextStyle(color: Colors.white),


onChanged: (value){
                      setState(() {
                        base_amount= value;
                      });
},
                    // obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF3C4043),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                      ),
                      hintStyle: new TextStyle(color: Color(0XFFDCDDE1)),
                      hintText: "E.g: 1000",
                    ),
                  ),
                ),

              ],
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
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () async {
        if(base_amount!=null) {
          setState(() {
            loading=true;
          });
              await Firestore.instance
                  .collection('doctor')
                  .document(doc_id)
                  .updateData({'base_amount': base_amount});
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>doctor_inventory()),
          );
            }
        else {

              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor:Color(0XFF3C4043),
                      title: Text('Input base fee!',style: TextStyle(color: CupertinoColors.white)),
                      content: Text(
                          'Input a appropriate base fee to attract more customers',style: TextStyle(color: CupertinoColors.white)),
                      actions: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('OK',style: TextStyle(color: CupertinoColors.white),),
                          ),
                        ),
                      ],
                    );
                  });
            }
          }, icon:Icon(Icons.navigate_next),backgroundColor: Color(0XFF3C4043),label: Text('Finish',style: TextStyle(color: CupertinoColors.white),)),
    );
  }
}
