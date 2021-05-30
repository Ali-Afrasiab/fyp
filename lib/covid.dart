import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remedium/editimage.dart';
import 'package:remedium/patient_profile.dart';
import 'package:remedium/report_generate.dart';
import 'package:tflite/tflite.dart';


final _firestore = Firestore.instance;

class covid extends StatefulWidget {
  final doc_id;
  final sender;
final pic;
final edited_image;
  covid({this.doc_id, this.pic, this.sender, this.edited_image});
  @override

  _covidState createState() => _covidState(doc_id:doc_id,pic:pic,sender: sender,edited_image: edited_image);
}

class _covidState extends State<covid> {
  _covidState({this.edited_image,this.sender,this.doc_id,this.pic});
  final doc_id;
  final pic;
  List _outputs;
  File _image;
  bool _loading = false;
  final sender;
  final edited_image;
  @override
  void initState() {
    super.initState();
    _loading = true;
    if(edited_image!=null)
      _image = edited_image;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  new PreferredSize(
        child: new Container(
          //padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          padding:  EdgeInsets.all(30),
          child: Row(

            children: [
              IconButton(

                  icon: Icon(Icons.arrow_back,color: CupertinoColors.white,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => report_generate(doc_id: doc_id,
                        ),),
                    );

                  }),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Covid-19 X-Ray Image Diagnosis",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ),
            ],
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
        preferredSize: new Size(MediaQuery.of(context).size.width, 65.0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF202125),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // edited_image==null? Image.network(pic):Image.file(edited_image),
            _image!=null?Image.file(_image):Container(width: 0,height: 0,),
            SizedBox(
              height: 20   ,
            ),
            Column(
                  children: [
                    _outputs != null
                        ? Text(
              "${_outputs[0]["label"]}",
              style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 20.0,

              ),
            ):Container(width: 0,height: 0,),
                    sender=='self_created'?
                    RaisedButton(
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      onPressed: (){
                        String result;
                        double confidence;
                        if(_outputs[0]["label"]=="1 positive") {
                                  result = "Positive";
confidence=_outputs[0]['confidence'];
                                }
                        if(_outputs[0]["label"]=="0 negative")
                           result="Negative";
                       // print("doc_id :${doc_id}");
                        Firestore.instance
                            .collection('patient')
                            .document(doc_id)
                            .updateData({
                          "result":result
                        });
                        Firestore.instance
                            .collection('patient')
                            .document(doc_id)
                            .updateData({"accuracy": confidence});

                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => report_generate(doc_id: doc_id,
                            ),),
                      );},
                      child: Text("Return to report creation",style:TextStyle(color:CupertinoColors.white)),
                    ):RaisedButton(
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      onPressed: () async {
                        if(_outputs!=null){
                            String result;
                            double confidence;
                            if (_outputs[0]["label"] == "1 positive") {
                              result = "Positive";
                              confidence = _outputs[0]['confidence'];
                            }
                            if (_outputs[0]["label"] == "0 negative")
                              result = "Negative";
                         //   print("Patient doc_id :${doc_id}");
                            Firestore.instance
                                .collection('consultation')
                                .document(doc_id)
                                .updateData({"patient_result": result});
                            Firestore.instance
                                .collection('consultation')
                                .document(doc_id)
                                .updateData({"accuracy": confidence});
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => report_generate(
                                  doc_id: doc_id,
                                ),
                              ),
                            );
                          }
                        else if(_outputs==null){
                          var image;
                          var url = "$pic"; // <-- 1
                          var response = await get(url); // <--2
                          var documentDirectory = await getApplicationDocumentsDirectory();
                          var firstPath = documentDirectory.path + "/images/x-ray";
                          var filePathAndName =
                              documentDirectory.path + '/images/x-ray/$doc_id.jpg';
                          //comment out the next three lines to prevent the image from being saved
                          //to the device to show that it's coming from the internet
                          await Directory(firstPath).create(recursive: true); // <-- 1
                          File file2 = new File(filePathAndName); // <-- 2
                          file2.writeAsBytesSync(response.bodyBytes);
                          List a=[file2];
                         // print('file2 : $file2');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>   editimage(arguments: file2,pic:pic ,sender: sender,doc_id: doc_id,)
                          ));

                        }

                        },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_outputs!=null?"Return to report creation":"Edit X-ray ",style:TextStyle(color:CupertinoColors.white)),
                        Padding(
                          padding:  EdgeInsets.only(left:2.0),
                          child: Icon(
                           Icons.edit_rounded
                               ,color: Colors.white,
                          ),
                        ),
                        ],
                      ),
                    ),
                  ],
                )

          ],
        ),
      ),

      floatingActionButton: sender=='self_created'?
          FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        onPressed: pickImage,
        label: Text('Select or Capture X-ray Image'),
        icon: Icon(Icons.image),
      ):   FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        onPressed: pickImage,
        label: Text('Procces the X-ray Image'),
        icon: Icon(Icons.view_array_outlined),
      ),
    );
  }

  pickImage() async {
    if(
    sender=='self_created'
    ){
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      setState(() {
        _loading = true;
        _image = image;
      });
      classifyImage(image);
    }
   else if(
    sender =='recieved' && edited_image==null
    )
   {
      var image;

      var url = "$pic"; // <-- 1
      var response = await get(url); // <--2
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/images/x-ray";
      var filePathAndName =
          documentDirectory.path + '/images/x-ray/$doc_id.jpg';
      //comment out the next three lines to prevent the image from being saved
      //to the device to show that it's coming from the internet
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(response.bodyBytes); // <-- 3
      setState(() {
        image = file2;
        _image = image;
        _loading = true;
      });
      classifyImage(image);
    }
   else if (edited_image!=null){
      setState(() {

        _image = edited_image;
        _loading = true;
      });
      classifyImage(_image);
    }

  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}

