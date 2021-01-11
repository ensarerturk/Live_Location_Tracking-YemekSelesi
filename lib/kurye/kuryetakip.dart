import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KuryeTakip extends StatefulWidget {
  @override
  _KuryeTakipState createState() => _KuryeTakipState();
}

class _KuryeTakipState extends State<KuryeTakip> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Kurye Takip"),
    ));
  }
}
