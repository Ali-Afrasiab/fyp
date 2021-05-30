import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remedium/patient_inventory.dart';

class jazz_cash extends StatefulWidget {
final doc_id;

  const jazz_cash({Key key, this.doc_id}) : super(key: key);


  @override
  _jazz_cashState createState() => _jazz_cashState(doc_id);
}

class _jazz_cashState extends State<jazz_cash> {
  String sender_number;
  String amount;
  final doc_id;
  bool num=false;

  _jazz_cashState(this.doc_id);
  payment() async{
    var digest;
    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss").format(DateTime.now().add(Duration(days: 1)));
    String tre = "T"+dateandtime;
    String pp_Amount=amount;
    String pp_BillReference="billRef";
    String pp_Description="Description";
    String pp_Language="EN";
    String pp_MerchantID="MC20268";
    String pp_Password="4945t8g6u7";

    String pp_ReturnURL="https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
    String pp_ver = "1.1";
    String pp_TxnCurrency= "PKR";
    String pp_TxnDateTime=dateandtime.toString();
    String pp_TxnExpiryDateTime=dexpiredate.toString();
    String pp_TxnRefNo=tre.toString();
    String pp_TxnType="MWALLET";
    String ppmpf_1=sender_number;
    String IntegeritySalt = "355eu2s3gz";
    String and = '&';
    String superdata=
        IntegeritySalt+and+
            pp_Amount+and+
            pp_BillReference +and+
            pp_Description +and+
            pp_Language +and+
            pp_MerchantID +and+
            pp_Password +and+
            pp_ReturnURL +and+
            pp_TxnCurrency+and+
            pp_TxnDateTime +and+
            pp_TxnExpiryDateTime +and+
            pp_TxnRefNo+and+
            pp_TxnType+and+
            pp_ver+and+
            ppmpf_1
    ;



    var key = utf8.encode(IntegeritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = new Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    var url = 'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

    var response = await http.post(url, body: {
      "pp_Version": pp_ver,
      "pp_TxnType": pp_TxnType,
      "pp_Language": pp_Language,
      "pp_MerchantID": pp_MerchantID,
      "pp_Password": pp_Password,
      "pp_TxnRefNo": tre,
      "pp_Amount": pp_Amount,
      "pp_TxnCurrency": pp_TxnCurrency,
      "pp_TxnDateTime": dateandtime,
      "pp_BillReference": pp_BillReference,
      "pp_Description": pp_Description,
      "pp_TxnExpiryDateTime":dexpiredate,
      "pp_ReturnURL": pp_ReturnURL,
      "pp_SecureHash": sha256Result.toString(),
      "ppmpf_1":"03024544784"
    });

    print("response=>");
    print('Status ${response.statusCode}');
    print(response.body);



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new PreferredSize(
        child: new Container(

          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(


                  icon: Icon(Icons.arrow_back_rounded,color: CupertinoColors.white,),
                  onPressed: () {

                  num!=false?  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>patient_inventory()),
                  ):  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>jazz_cash()),
                  );
                  }
              ),
                SizedBox(
                  width: 80,
                ),
                Text("Pay by Jazzcash",style:TextStyle(fontSize: 20,color:CupertinoColors.white,

                ),),


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


      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF202125),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right:150.0),
              child: Text(num!=false?'Enter Amount':"Jazzcash mobile",
                  style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
           num==false? Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                style: TextStyle(color: Colors.white),


                onChanged: (value) {

                  sender_number=value;

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
                  hintText: "E.g: 03001234567",
                ),
              ),
            ): Padding(
             padding: EdgeInsets.all(10),
             child: TextField(
               style: TextStyle(color: Colors.white),


               onChanged: (value) {

                 amount=value;

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
            num==false?RaisedButton(
                color:Color(0XFF3C4043),
                padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: (){
                  if(sender_number!=null && sender_number.length==11 && !sender_number.contains('-'))
                    setState(() {
                      num=true;
                    });
                  else showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Wrong Input!'),
                          content: Text('Mobile number should be 11 digits without space or special character'),
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
                child: Text(num!=false?'Pay':"NEXT",
                    style: TextStyle(color: CupertinoColors.white))):RaisedButton(
                color:Color(0XFF3C4043),
                padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: (){
                  if(amount!=null && amount.isNotEmpty && int.parse(amount)>999) {
                        setState(() {
                          payment();

                        });
                        Firestore.instance.collection('consultation').document(doc_id).updateData({
                          'payment':'Paid'
                        });

                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Payment Successful!'),
                                content: Text('Try again to view results'),
                                actions: [
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>patient_inventory()),
                                        );
                                      },
                                      child: Text('OK'),
                                    ),
                                  ),
                                ],
                              );
                            });


                      } else showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Wrong Amount!'),
                          content: Text('Enter a correct amount greater than base amount, R.s 999'),
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
                child: Text('Pay',
                    style: TextStyle(color: CupertinoColors.white))),

          ],
        ),
      ),
    );
  }
}
