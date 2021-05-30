import 'dart:io';
import 'package:flutter/material.dart';
import 'package:remedium/data/data.dart';
import 'package:remedium/jarvis.dart';
import 'package:remedium/jazz_cash.dart';
//import 'dart:convert';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:remedium/patient_sign_in.dart';
//import 'package:http/http.dart' as http;
//import 'consultation.dart';
import 'signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: "App Onborading",
      home: home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List<slidermodel> slides = new List<slidermodel>();
  int currentindex = 0;
  PageController pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    slides = getslides();
  }

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
          color: isCurrentPage ? Colors.grey : Colors.grey[300],
          borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
          controller: pageController,
          itemCount: slides.length,
          onPageChanged: (val) {
            setState(() {
              currentindex = val;
            });
          },
          itemBuilder: (context, index) {
            return slidertile(
              imageAssetPath: slides[index].getImageAssetPath(),
              title: slides[index].getTitle(),
              description: slides[index].getDesc(),
            );
          }),
      bottomSheet: currentindex != slides.length - 1
          ? Container(
              height: Platform.isAndroid ? 70 : 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      pageController.animateToPage(slides.length - 1,
                          duration: Duration(microseconds: 400),
                          curve: Curves.linear);
                    },
                    child: Text("SKIP"),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < slides.length; i++)
                        currentindex == i
                            ? pageIndexIndicator(true)
                            : pageIndexIndicator(false)
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      pageController.animateToPage(currentindex + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    child: Text("NEXT"),
                  ),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: Platform.isAndroid ? 70 : 60,
              color: Colors.blue[800],
              child: FlatButton(
                //shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => signin()),
                  );
                },
                color: Color(0x7f3ff8),
                // padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                child: Text(
                  "GET STARTED NOW",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }
}

class slidertile extends StatelessWidget {
  String imageAssetPath, title, description;
  slidertile({this.imageAssetPath, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageAssetPath),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}

/* @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remedium',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Welcome to Remedium',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String greetings = '';

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      appBar: new PreferredSize(
        child: new Container(
          padding: new EdgeInsets.only(
              top: MediaQuery.of(context).padding.top
          ),
          child: new Padding(
            padding: const EdgeInsets.only(
                left: 30.0,
                top: 20.0,
                bottom: 20.0
            ),
            child: Center(
              child: new Text(
                'Welcome to Remedium',
                style: new TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              ),
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
              ]
          ),
        ),
        preferredSize: new Size(
            MediaQuery.of(context).size.width,
            80.0
        ),
      ),

      body:

      Container(decoration: const BoxDecoration(
        color: Color(0xFF202125),

      ),
        child: Center(
          child: Column(

          children: [
            Text(greetings, style: TextStyle(fontSize: 23.0)),
            SizedBox(height: 120,),
            Expanded(
                flex: 1,

                child: Center(
                  child: Container(
                        height: 25,
                      child:Text("SIGN IN AS",style: TextStyle(fontSize: 25,color: Colors.white),)),
                )),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  children: [
                    RaisedButton(

                        shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: (){Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => doctor_sign_in()),
                        );},
                        color: Color(0xFF3C4043),


                        padding: EdgeInsets.fromLTRB(80, 20, 80, 20),

                        child: Text("Doctor",
                        style:TextStyle(color: Colors.white))),

                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                        color: Color(0xFF3C4043),
                        padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                        shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed:(){Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => patient_sign_in()),
                        );},
                        child: Text("Patient",style:TextStyle(color: Colors.white))),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                        color: Color(0xFF3C4043),
                        padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                        shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed:() async{
                        final res = await http.get("http://192.168.10.2/127.0.0.1:5000/");
                        final decoded = json.decode(res.body) as Map <String, dynamic>;

                          setState(() {
                            greetings = decoded['greetings'];
                          });

                        },

                        child: Text("Chatbot",style:TextStyle(color: Colors.white))),


                  ],
                ),
              ),
            ),

          ],
          ),
        ),
      ),


    );
  }
}*/
