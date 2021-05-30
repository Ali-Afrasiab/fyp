import 'package:bottom_bar/bottom_bar.dart';
import 'package:bubble/bubble.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:remedium/jarvis.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

class chatbot_report extends StatefulWidget {
  final List messages;
  const chatbot_report({Key key, this.messages}) : super(key: key);

  @override
  _chatbot_reportState createState() =>
      _chatbot_reportState(messages: messages);
}

class _chatbot_reportState extends State<chatbot_report> {
  final List messages;
  final sentiment = Sentiment();
  _chatbot_reportState({this.messages});



  int negative_words (){
    int words=0;
    List<double> data = List();
    for(int i =0;i<messages.length;i++)
    {
      if(messages[i]['data']==1)
        {
          words = words+sentiment.analysis(messages[i]['message'],emoji: true)['badword'].length;

        }
    }
 return words;
  }

  void negative_score (){
    List<double> data = List<double>();
    for(int i =0;i<messages.length;i++)
    {
      if(messages[i]['data']==1 && messages[i]['data']!=null)
        {
            // print(sentiment.analysis(messages[i]['message'],emoji: true)['badword'][0][1]);
          List a=sentiment.analysis(messages[i]['message'],emoji: true)['badword'];

            if (a!=null && a.isNotEmpty) {
             data.add(sentiment.analysis(messages[i]['message'],emoji: true)['badword'][0][1].toDouble().abs()/10);
            print('negative word caught');
            }


        }
    }

    setState(() {
if(data.length<=20 && data.length>0)
  label_y=['0','5','10','15','20'];

else if(data.length<=40 && data.length>20)
  label_y=['0','10','20','30','40'];

   else if(data.length<=80 && data.length>40)
  label_y=['0','20','40','60','80'];
else if(data.length<=120 && data.length>80)
  label_y=['0','30','60','90','120'];


    });

setState(() {
  negative_features.add(
    Feature(
    title: "Negative Words",
    color: Colors.red,
    data: data,
  ),);
  features.add(
    Feature(
    title: "Negative Words",
    color: Colors.red,
    data: data,
  ),);
});

  }
  void positive_score (){
    List<double> data = List<double>();
    for(int i =0;i<messages.length;i++)
    {
      if(messages[i]['data']==1 && messages[i]['data']!=null)
        {
            // print(sentiment.analysis(messages[i]['message'],emoji: true)['badword'][0][1]);
          List a=sentiment.analysis(messages[i]['message'],emoji: true)['good words'];

            if (a!=null && a.isNotEmpty) {
             data.add(a[0][1].toDouble()/10);

            }


        }
    }



setState(() {
  positive_features.add(
    Feature(
    title: "Positive Words",
    color: Colors.green,
    data: data,
  ),);
  features.add(
    Feature(
    title: "Positive Words",
    color: Colors.green,
    data: data,
  ),);

});

  }


  List<Feature> negative_features = List<Feature>();
  List<Feature> positive_features = List<Feature>();
  List<Feature> features = List<Feature>();
  List<String>  label_y = List<String>();
  String selected_card='';
  bool select=false;

  int positive_words (){
    int words=0;

    for(int i =0;i<messages.length;i++)
    {
      if(messages[i]['data']==1)
        {
          words = words+sentiment.analysis(messages[i]['message'],emoji: true)['good words'].length;
        }
    }

 return words;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    negative_score();
    positive_score();
  }
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            RaisedButton(
              onPressed: () {
               if(select==false){
                 Navigator.pop(context);
               }
               else setState(() {
                 select=!select;
               });
              },
              color: Colors.transparent,
              child: Row(
                children: [
                  Text(
                    'Report',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                  Icon(
                    Icons.analytics_outlined,
                    color: CupertinoColors.white,
                  )
                ],
              ),
            )
          ],
          title: Text(
            "Report",
          ),
          backgroundColor: Color(0xFF202125),
        ),
        bottomNavigationBar: TabBar(
            indicatorColor: Colors.blue,
            isScrollable: true,
            labelColor: Color(0xFF202125),
            tabs: [

              Tab(
                text: 'Word-by-word Analysis',
                icon: Icon(
                  Icons.account_tree_outlined,
                ),
              ),
              Tab(
                text: 'Graphical Analysis',
                icon: Icon(
                  Icons.analytics_outlined,
                ),
              ),
              Tab(
                text: 'Chat Analysis',
                icon: Icon(
                  Icons.wysiwyg,
                ),
              ),
            ]),
        body: TabBarView(
          children: [






            select==false? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(

                  child: Padding(
                    padding:  EdgeInsets.all(100.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlatButton(
                          onPressed: (){setState(() {
                            select=true;
                            selected_card='negative';
                          });},
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            //color: Colors.blue,

                            child: Card(

                              elevation: 50,


                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(
                                      color: Colors.red
                                  )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Negative Words'),
                                      Icon(Icons.mood_bad),
                                    ],
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Total Words: ${negative_words()}'),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: (){setState(() {
                            select=true;
                            selected_card='positive';
                          });},
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            //color: Colors.blue,

                            child: Center(
                              child: Card(

                                elevation: 50,


                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(
                                        color: Colors.green
                                    )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Positive Words'),
                                        Icon(Icons.mood_rounded),
                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Total Words: ${positive_words()}'),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ],
            ):
            Container(color: Colors.blue,),
        ListView(
padding: EdgeInsets.all(50),
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64.0),
              child: Text(
                "Graphical Representation",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            LineGraph(
              features: features,

              size: Size(350, 450),
              //     labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
              labelX: label_y,
              labelY: ['10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'],
              showDescription: true,
              graphColor: Colors.blue,
              graphOpacity: 0.2,
              verticalFeatureDirection: true,
              descriptionHeight: 130,
            ),
            SizedBox(
              height: 50,
            ),
            LineGraph(
              features: negative_features,

              size: Size(350, 450),
         //     labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
            labelX: label_y,
              labelY: ['10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'],
              showDescription: true,
              graphColor: Colors.red,
              graphOpacity: 0.2,
              verticalFeatureDirection: true,
              descriptionHeight: 130,
            ),
            SizedBox(
              height: 50,
            ),
            LineGraph(
              features: positive_features,

              size: Size(350, 450),
              //     labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
              labelX: label_y,
              labelY: ['10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'],
              showDescription: true,
              graphColor: Colors.green,
              graphOpacity: 0.2,
              verticalFeatureDirection: true,
              descriptionHeight: 130,
            ),

          ],
        ),
            Container(
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) => chat(
                          messages[index]["message"].toString(),
                          messages[index]["data"]),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Colors.deepOrange : Colors.orangeAccent,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(
                          data == 0 ? "assets/bot.png" : "assets/user.png"),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                        child: Text(
                      message,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
               data==1? Text('${sentiment.analysis(message, emoji: true)}'):Container(),
              ],
            ),
          )),
    );
  }
}
