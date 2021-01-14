import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; //for date format

File image;
String fileName;

class YoneticiCrudUpdate extends StatefulWidget {
  final DocumentSnapshot ds;

  const YoneticiCrudUpdate({Key key, this.ds}) : super(key: key);

  @override
  _YoneticiCrudUpdateState createState() => _YoneticiCrudUpdateState();
}

class _YoneticiCrudUpdateState extends State<YoneticiCrudUpdate> {
  TextEditingController fiyatTextiKumandasi = TextEditingController();

  TextEditingController recipeInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;
  String productImage;

  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String recipe;
  int fiyat;

  pickerCam() async {
    // ignore: deprecated_member_use
    File img = await ImagePicker.pickImage(source: ImageSource.camera);

    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    // ignore: deprecated_member_use
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    recipeInputController =
        new TextEditingController(text: widget.ds.data()["recipe"]);
    nameInputController =
        new TextEditingController(text: widget.ds.data()["name"]);

    productImage = widget.ds.data()["image"];
    print(productImage);
  }

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    // ignore: deprecated_member_use
    QuerySnapshot qn = await firestore.collection("yayınlanan").getDocuments();
    // ignore: deprecated_member_use
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    getPosts();
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Sayfası"),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    new Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.blueAccent),
                      ),
                      padding: new EdgeInsets.all(5.0),
                      child: image == null
                          ? Text("Yükleme Yapın")
                          : Image.file(image),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.2),
                      child: new Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.blueAccent)),
                        padding: new EdgeInsets.all(5.0),
                        child: productImage == ""
                            ? Text('Edit')
                            : Image.network(productImage + '?alt=media',
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                return Text('Your error widget...');
                              }),
                      ),
                    ),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.camera_alt), onPressed: pickerCam),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.image), onPressed: pickerGallery),
                  ],
                ),
                new Container(
                  child: TextFormField(
                    controller: nameInputController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name",
                      fillColor: Colors.grey,
                      filled: true,
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Lütfen aynı texti bir daha girin";
                      }
                    },
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    controller: fiyatTextiKumandasi,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Fiyat",
                      fillColor: Colors.grey,
                      filled: true,
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Lütfen aynı texti bir daha girin";
                      }
                    },
                    onSaved: (value) {
                      fiyat = int.parse(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    controller: recipeInputController,
                    maxLines: 7,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Açıklama",
                      fillColor: Colors.grey,
                      filled: true,
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Lütfen aynı texti bir daha girin";
                      }
                    },
                    onSaved: (value) {
                      recipe = value;
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('Update'),
                onPressed: () {
                  DateTime now = DateTime.now();
                  String atilmaZaman = DateFormat('kk:mm:ss:MMMMd').format(now);
                  var fullImageName = 'atilma-$atilmaZaman' + '.jpg';
                  var fullImageName2 = 'atilma-$atilmaZaman' + '.jpg';

                  final Reference ref =
                      FirebaseStorage.instance.ref().child(fullImageName);
                  final UploadTask task = ref.putFile(image);
                  var part1 =
                      'https://firebasestorage.googleapis.com/v0/b/apprecetas-cfd25.appspot.com/o/';

                  var fullPathImage = part1 + fullImageName2;
                  print(fullPathImage);
                  _formKey.currentState.save();
                  FirebaseFirestore.instance
                      .collection('yayınlanan')
                      // ignore: deprecated_member_use
                      .document(widget.ds.documentID)
                      // ignore: deprecated_member_use
                      .updateData({
                    'name': nameInputController.text,
                    'recipe': recipeInputController.text,
                    'fiyat': fiyat,
                    'image': '$fullPathImage'
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
