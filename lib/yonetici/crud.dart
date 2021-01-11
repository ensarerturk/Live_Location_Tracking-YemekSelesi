import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrudSayfasi extends StatefulWidget {
  @override
  _CrudSayfasiState createState() => _CrudSayfasiState();
}

class _CrudSayfasiState extends State<CrudSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Değişim"),
      ),
    );
  }
}
