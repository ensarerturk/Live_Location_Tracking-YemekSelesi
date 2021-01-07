import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/servisler/yetkilendirmeservisi.dart';

class YoneticiCrud extends StatefulWidget {
  @override
  _YoneticiCrudState createState() => _YoneticiCrudState();
}

class _YoneticiCrudState extends State<YoneticiCrud> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: GestureDetector(
              onTap: () => YetkilendirmeServisi().cikisYap(),
              child: Text("YONETİCİ SAYFASI"))),
    );
  }
}
