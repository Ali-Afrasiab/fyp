
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
//import 'package:pdf/widgets.dart';
import 'package:remedium/symptoms.dart';
import 'package:flutter/material.dart';
import 'package:remedium/result_selfdiagnosis.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:remedium/signin.dart';



const MaterialColor kPrimaryColor = const MaterialColor(
  0xFF2196F3,
  const <int, Color>{
    50: const Color(0xFF2196F3),
    100: const Color(0xFF2196F3),
    200: const Color(0xFF2196F3),
    300: const Color(0xFF2196F3),
    400: const Color(0xFF2196F3),
    500: const Color(0xFF2196F3),
    600: const Color(0xFF2196F3),
    700: const Color(0xFF2196F3),
    800: const Color(0xFF2196F3),
    900: const Color(0xFF2196F3),
  },
);

class selfdiagnosis extends StatelessWidget {
  final String title = 'Symptoms';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: kPrimaryColor),
    home: MainPage(title: title),
  );

}


class MainPage extends StatefulWidget {

  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String value='';
  final values=[0,0,0,0,0,0,0,0,0];
  final allowNotifications = symptomdata(title: 'All symptoms');

  final notifications = [
    symptomdata(title: 'Fever'),
    symptomdata(title: 'Tiredness'),
    symptomdata(title: 'Dry-Cough'),
    symptomdata(title: 'Difficulty-in-Breathing'),
    symptomdata(title: 'Sore-Throat'),
    symptomdata(title: 'Pains'),
    symptomdata(title: 'Nasal-Congestion'),
    symptomdata(title: 'Runny-Nose'),
    symptomdata(title: 'Diarrhea'),
    //symptomdata(title: 'Body ache'),
    //symptomdata(title: 'Chills'),
    //symptomdata(title: 'Loss of smell'),
    //symptomdata(title: 'Loss of taste'),
    //symptomdata(title: 'Loss of appetite'),
    //symptomdata(title: 'Headache'),
    //symptomdata(title: 'Foot rash'),
    //symptomdata(title: 'Blue lips/face'),
  ];


  @override

  Widget build(BuildContext context) => Scaffold(
     appBar: new PreferredSize(
      child: new Container(
      padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: new Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
          child: Center(
            child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
  ),
                onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => signin()),
  );
  }),

              new Text(
                'Select Your Symptoms',
            style: new TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.w500,
                color: Colors.white),
  ),
  ],
  ),
  ),
  ),
          decoration: new BoxDecoration(color: Color(0xFF202125),
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
        //color: Colors.white,
      ),
      child: ListView(

        children: [
          buildToggleCheckbox(allowNotifications),
          Divider(),
          ...notifications.map(buildSingleCheckbox).toList(),
          Container(//decoration: const BoxDecoration(
  //color: Color(0xFF202125),
  //color: Colors.white,),
            child: Column(
              children: [
              SizedBox(
              height: 20,
              ),
                RaisedButton(
                color: Colors.blue,
                padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed:() async{
                String val='';
                for(var i =0; i <values.length; i++) {
                  if (values[i] == 1) {
                    val += '1';
                  }
                  else if (values[i] == 0 ) {
                    val += '0' ;
                  }
                  if(i<values.length-1){
                    val+=',';
                  }
                }
                String url='https://10.0.2.2:5000/predict_covid/$val';
                // debugPrint('$val,$url');
                final res = await http.get(url);

                final  decoded = json.decode(res.body) ;
                debugPrint("cluster:  $decoded");
                String x=decoded.toString();
                print(x.runtimeType);

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => result_selfdiagnosis(x)),
                );



              },
                  child: Text("SUBMIT",
                    style:TextStyle(
                        color: Colors.white,
                  fontSize: 20),)
                ),
                SizedBox(
                  height: 20,
                ),
  ],

          ),
          ),],

      ),
    ),

  );

  Widget buildToggleCheckbox(symptomdata notification) => buildCheckbox(
      notification: notification,
      onClicked: () {
        final newValue = !notification.value;

        setState(() {
          allowNotifications.value = newValue;
          int i=0;
          notifications.forEach((notification) {
            notification.value = newValue;
            if(newValue){
              values[i]=1;
            }
            else{
              values[i]=0;
            }

            int c=values[i];
            // debugPrint('priting: $i, $c');
            i+=1;
          });
        });
      });

  Widget buildSingleCheckbox(symptomdata notification) => buildCheckbox(
    notification: notification,

    onClicked: () {
      setState(() {
        final newValue = !notification.value;
        notification.value = newValue;

        if (!newValue) {
          allowNotifications.value = false;
        } else {
          final allow =
          notifications.every((notification) => notification.value);
          allowNotifications.value = allow;
        }
      });
      int i=0;
      notifications.forEach((notification) {
        bool x=notification.value;

        if(x){
        values[i]=1;
        }
        else{
          values[i]=0;
        }

        int c=values[i];
        // debugPrint('priting: $i, $c');
        i=i+1;
      });
    },
  );

  Widget buildCheckbox({
    @required symptomdata notification,
    @required VoidCallback onClicked,
  }) =>
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF202125),
  //color: Colors.white,
  ),
        child: ListTile(
          onTap: onClicked,
          leading: Checkbox(
            value: notification.value,
            onChanged: (value) => onClicked(),
          ),
          title: Text(
            notification.title,
            style: TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
}

/*class gender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            child: Text("abcdef")
        )
    );
  }
}*/


/*class selfdiagnosis extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Myselfdiagnosis(title: '',
      ),
    );
  }
}

class Myselfdiagnosis extends StatefulWidget {
  Myselfdiagnosis({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _Myselfdiagnosis createState() => _Myselfdiagnosis();
}

class _Myselfdiagnosis extends State<Myselfdiagnosis> {
bool value = false;

final symptoms = [
  symptomdata(title: 'Fever'),
  symptomdata(title: 'Dry Cough'),
  symptomdata(title: 'Sore throat'),
  symptomdata(title: 'Pain in chest with deep breaths'),
  symptomdata(title: 'Shortness of breath'),
  symptomdata(title: 'Body ache'),
  symptomdata(title: 'Chills'),
  symptomdata(title: 'Loss of smell'),
  symptomdata(title: 'Loss of taste'),
  symptomdata(title: 'Loss of apetite'),
  symptomdata(title: 'Fatigue or tiredness'),
  symptomdata(title: 'Headache'),
  symptomdata(title: 'Runny nose'),
  symptomdata(title: 'Runny stomach'),
  symptomdata(title: 'Foot rash'),
  symptomdata(title: 'Blue lips/face'),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202125) ,
      appBar: AppBar(
        title: Text('Symptomatic Diagnosis'),
        backgroundColor: Color(0xFF202125),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => {Navigator.of(context).pop()},
        ),
        shadowColor: Colors.blue,
      ),

      body: ListView(
        children: [
          ...symptoms.map((data) => null).toList(),
          //buildCheckbox(),
        ],
      )

    );
  }
Widget buildSingleCheckbox(symptomdata data) => buildCheckbox(
    data: data,
    onClicked: (){
      setState(() {
        final newvalue = !data.value;
        data.value = value;
      });
    }
);

  //buildCheckbox(

      //);
  Widget buildCheckbox({
    @required symptomdata data,
    @required VoidCallback onClicked,
  }) => ListTile(
    onTap: onClicked,
      leading: Checkbox(
      value: value,
      onChanged: (value) => onClicked(),
),
      title: Text(
      'Flu',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)

  ),
  );
}*/


