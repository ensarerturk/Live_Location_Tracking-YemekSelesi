import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/servisler/firestorservisi.dart';
import 'package:mobile_project/servisler/storageservisi.dart';

class YoneticiCrud extends StatefulWidget {
  @override
  _YoneticiCrudState createState() => _YoneticiCrudState();
}

class _YoneticiCrudState extends State<YoneticiCrud> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Yonetici",
      theme: ThemeData(primarySwatch: Colors.green),
      home: Yonetici(),
    );
  }
}

class Yonetici extends StatefulWidget {
  @override
  _YoneticiState createState() => _YoneticiState();
}

class _YoneticiState extends State<Yonetici> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PickedFile imageURI;
  final ImagePicker _picker = ImagePicker();
  bool yukleniyor = false;
  //textformfield ı kaydetmek için önceden onSaved kullandık bu sefer textformfield ların controllerı nı kullanıcaz.
  TextEditingController infoTextiKumandasi = TextEditingController();
  TextEditingController aciklamaTextiKumandasi = TextEditingController();
  TextEditingController fiyatTextiKumandasi = TextEditingController();

  Future getImageorGaleri(bool isCamera) async {
    var image = await _picker.getImage(
        source: (isCamera == true) ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      imageURI = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: imageURI == null ? akis() : gonderiFormu(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "hero1",
            onPressed: () {
              getImageorGaleri(true);
            },
            child: Icon(Icons.camera),
          ),
          SizedBox(
            height: 15.0,
          ),
          FloatingActionButton(
            heroTag: "hero2",
            onPressed: () {
              getImageorGaleri(false);
            },
            child: Icon(Icons.photo_album),
          )
        ],
      ),
    );
  }

  Widget gonderiFormu() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          "Ürün yükleme",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              imageURI = null;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.black,
            onPressed: _gonderiOlustur,
          ),
        ],
      ),
      body: ListView(
        children: [
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          //gelecek resmin en boy oranını belirlemek için.
          AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.file(
                File(imageURI.path),
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: infoTextiKumandasi,
            decoration: InputDecoration(
                hintText: "info",
                contentPadding: EdgeInsets.only(left: 15.0, right: 15.0)),
          ),
          TextFormField(
            controller: aciklamaTextiKumandasi,
            decoration: InputDecoration(
                hintText: "Açıklama",
                contentPadding: EdgeInsets.only(left: 15.0, right: 15.0)),
          ),
          TextFormField(
            controller: fiyatTextiKumandasi,
            decoration: InputDecoration(
                hintText: "Ücreti",
                contentPadding: EdgeInsets.only(left: 15.0, right: 15.0)),
          ),
        ],
      ),
    );
  }

  void _gonderiOlustur() async {
    if (!yukleniyor) {
      setState(() {
        yukleniyor = true;
      });
      String resimUrl =
          await StorageServisi().gonderiResimiYukle(File(imageURI.path));
      FireStoreServisi().gonderiOlustur(
          aciklama: aciklamaTextiKumandasi.text,
          fiyat: int.parse(fiyatTextiKumandasi.text),
          gonderiResmiURL: resimUrl,
          info: infoTextiKumandasi.text);

      setState(() {
        yukleniyor = false;
        infoTextiKumandasi.clear();
        aciklamaTextiKumandasi.clear();
        fiyatTextiKumandasi.clear();
        imageURI = null;
      });
    }
  }

  Widget akis() {
    return Center(
      child: Text("selam"),
    );
  }
}
