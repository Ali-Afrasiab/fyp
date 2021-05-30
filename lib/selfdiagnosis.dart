
import 'package:remedium/symptoms.dart';
import 'package:flutter/material.dart';
import 'package:remedium/patient_sign_in.dart';


const MaterialColor kPrimaryColor = const MaterialColor(
  0xFF7c4dff,
  const <int, Color>{
    50: const Color(0xFF7c4dff),
    100: const Color(0xFF7c4dff),
    200: const Color(0xFF7c4dff),
    300: const Color(0xFF7c4dff),
    400: const Color(0xFF7c4dff),
    500: const Color(0xFF7c4dff),
    600: const Color(0xFF7c4dff),
    700: const Color(0xFF7c4dff),
    800: const Color(0xFF7c4dff),
    900: const Color(0xFF7c4dff),
  },
);
class selfdiagnosis extends StatelessWidget {
  final String title = 'Symptoms';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: kPrimaryColor),
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
  final allowNotifications = symptomdata(title: 'All symptoms');

  final notifications = [
    symptomdata(title: 'Fever'),
    symptomdata(title: 'Dry-Cough'),
    symptomdata(title: 'Sore-Throat'),
    symptomdata(title: 'Pains'),
    symptomdata(title: 'Difficulty-in-Breathing'),
    symptomdata(title: 'Tiredness'),
    symptomdata(title: 'Runny-Nose'),
    symptomdata(title: 'Nasal-Congestion'),
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
  //               Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => MainPage()),
  // );
  }),
              SizedBox(
              width: 90,
  ),
              new Text(
                'Symptoms',
            style: new TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.w500,
                color: Colors.white),
  ),
  ],
  ),
  ),
  ),
          decoration: new BoxDecoration(color: Color(0xFF7c4dff),
            boxShadow: [
            new BoxShadow(
            color: Color(0xFF7c4dff),
            blurRadius: 20.0,
            spreadRadius: 1.0,
  ),
  ]),
  ),
  preferredSize: new Size(MediaQuery.of(context).size.width, 80.0),
  ),
    body: ListView(
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
              color: Color(0xFF7c4dff),
              padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
              shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              onPressed:(){Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => patient_sign_in()),
              );},
                child: Text("SUBMIT",style:TextStyle(color: Colors.white,
                fontSize: 20),)),
              SizedBox(
                height: 20,
              ),
  ],

        ),
        ),],

    ),

  );

  Widget buildToggleCheckbox(symptomdata notification) => buildCheckbox(
      notification: notification,
      onClicked: () {
        final newValue = !notification.value;

        setState(() {
          allowNotifications.value = newValue;
          notifications.forEach((notification) {
            notification.value = newValue;
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
    },
  );

  Widget buildCheckbox({
    @required symptomdata notification,
    @required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(
          value: notification.value,
          onChanged: (value) => onClicked(),
        ),
        title: Text(
          notification.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );


}


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


