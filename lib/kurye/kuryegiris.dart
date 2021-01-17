import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:mobile_project/kurye/kuryetakip.dart';

class KuryeGiris extends StatefulWidget {
  @override
  _KuryeGirisState createState() => _KuryeGirisState();
}

class _KuryeGirisState extends State<KuryeGiris> {
  //Formun state ine girebilmek için anahtara ihtiyaç var.
  final _formAnahtari = GlobalKey<FormState>();
  //animasyon için
  bool yukleniyor = false;
  //girilen değerler
  String email, sifre;
  //hata kontrolü
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        appBar: AppBar(
          title: Text("Kurye GİRİŞ"),
        ),
        body: Stack(
          children: [
            _sayfaElemanlari(),
            _yuklemeAnimasyonu(),
          ],
        ));
  }

  Widget _yuklemeAnimasyonu() {
    if (yukleniyor) {
      return Center(child: CircularProgressIndicator());
    } else {
      //diğer türlü hiçbir şey yapma demek
      return Center();
    }
  }

  Widget _sayfaElemanlari() {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
        children: <Widget>[
          Image.asset(
            "assets/kurye.jpg",
            height: 150,
          ),
          SizedBox(height: 90.0),
          TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: "Email adresinizi girin",
                errorStyle: TextStyle(fontSize: 16.0),
                prefixIcon: Icon(Icons.mail)),
            validator: (girilenDeger) {
              if (girilenDeger.isEmpty) {
                return "Email alanı boş bırakılamaz!";
                //Girilen değerde @ sembolü yoksa hata ver.
              } else if (!girilenDeger.contains("@kurye.com")) {
                return "Girilen değer mail kurye formatında olmalı!";
              }
              return null;
            },
            onSaved: (girilenDeger) {
              email = girilenDeger;
            },
          ),
          SizedBox(
            height: 40.0,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Şifresiniz girin",
                errorStyle: TextStyle(fontSize: 16.0),
                prefixIcon: Icon(Icons.lock)),
            validator: (girilenDeger) {
              if (girilenDeger.isEmpty) {
                return "Şifre alanı boş bırakılamaz!";
                //Girilen değerde @ sembolü yoksa hata ver.
              } else if (girilenDeger.trim().length < 4) {
                return "Şifre 4 karakterden az olamaz!";
              }
              return null;
            },
            onSaved: (girilenDeger) {
              sifre = girilenDeger;
            },
          ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FlatButton(
                    onPressed: _girisYap,
                    child: Text(
                      "Giriş Yap",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.yellow[800]),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  void _girisYap() async {
    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        //kullanıcının giriş yapmak istediğini güvenlik merkezine söylemek için
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: sifre);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => KuryeTakip()));
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code);
      }
    }
  }

  //farklı hata kodları için farklı mesajlar gösterilmesini sağlayacak.
  //yetkilendirme servisinde createUserWithEmailAndPassword un açıklama kısmında hata kodları ve açıklamaları mevcut.
  uyariGoster({hataKodu}) {
    String hataMesaji;
    if (hataKodu == "invalid-email") {
      hataMesaji = "Böyle bir kullanıcı bulunmuyor!";
    } else if (hataKodu == "user-disabled") {
      hataMesaji = "Girdiğiniz mail adresi geçersiz!";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Girilen şifre hatalı!";
    } else if (hataKodu == "user-not-found") {
      hataMesaji = "Kullanıcı bulunamadı";
    } else {
      hataMesaji = "Tanımlanamayan bir hata oluştu $hataKodu";
    }
    //snackbar da hatayı göstermek istiyoruz
    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
