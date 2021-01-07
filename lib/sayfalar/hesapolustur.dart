import 'package:flutter/material.dart';
import 'package:mobile_project/servisler/yetkilendirmeservisi.dart';

class HesapOlustur extends StatefulWidget {
  @override
  _HesapOlusturState createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  //animasyonun gösterilip gösterilmeyeceğini belirleyen nitelik.
  bool yukleniyor = false;
  //formun metodlarını çalıştırabilmek için form anahtarı oluşturuyorum.
  final _formAnahtari = GlobalKey<FormState>();
  //kullnıcı adı,mail ve şifre için tanımlamalar yapıyoruz.
  String kullaniciAdi, email, sifre;
  //hata kodunu snacbar içinde göstermek istiyoruz.Scaffold un olduğu için tanımlıyoruz.
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        appBar: AppBar(
          title: Text("Hesap Oluştur"),
        ),
        body: ListView(
          children: <Widget>[
            yukleniyor ? LinearProgressIndicator() : SizedBox(),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formAnahtari,
                child: Column(
                  children: [
                    TextFormField(
                        //klavyede bizim için tamamlar
                        autocorrect: true,
                        decoration: InputDecoration(
                          //ipucu text i
                          hintText: "Kullanıcı adınızı girin",
                          //Kullanıcı Text alanına tıkladığında label textler küçülüp hint textler gelecek.
                          labelText: "Kullanıcı Adı:",
                          //hata mesajlarının boyutunu belirledik
                          errorStyle: TextStyle(fontSize: 16.0),
                          prefixIcon: Icon(Icons.mail),
                        ),
                        //İstenilen türden bilgiler girilmediğinde hata mesajı vermek için.
                        validator: (girilenDeger) {
                          if (girilenDeger.isEmpty) {
                            return "Kullanıcı alanı boş bırakılamaz!";
                            //Girilen değerde @ sembolü yoksa hata ver.
                          } else if (girilenDeger.trim().length < 4 ||
                              girilenDeger.trim().length > 10) {
                            return "En az 4 en fazla 10 karakter olabilir!";
                          }
                          return null;
                        },
                        //onsaved fonksiyonu text e girilen değeri belirlenen değerlere atıyor.
                        onSaved: (girilenDeger) {
                          kullaniciAdi = girilenDeger;
                        }),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                        //klavyede @ simgesini getirir.
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          //ipucu text i
                          hintText: "Lütfen mail adresini giriniz",
                          labelText: "Mail:",
                          //hata mesajlarının boyutunu belirledik
                          errorStyle: TextStyle(fontSize: 16.0),
                          prefixIcon: Icon(Icons.mail),
                        ),
                        //İstenilen türden bilgiler girilmediğinde hata mesajı vermek için.
                        validator: (girilenDeger) {
                          if (girilenDeger.isEmpty) {
                            return "Email alanı boş bırakılamaz!";
                            //Girilen değerde @ sembolü yoksa hata ver.
                          } else if (!girilenDeger.contains("@")) {
                            return "Girilen değer mail formatında olmalı!";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) {
                          email = girilenDeger;
                        }),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      //kalvyede yazılanları gizler
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Lütfen şifrenizi giriniz",
                          labelText: "Şifre:",
                          errorStyle: TextStyle(fontSize: 16.0),
                          prefixIcon: Icon(Icons.lock)),
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Şifre alanı boş bırakılamaz!";
                          //4 karakterden az şifre girilirse hata mesajı verilir.
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
                      height: 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: _kullaniciOlustur,
                        child: Text(
                          "Hesap Oluştur",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Theme.of(this.context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void _kullaniciOlustur() async {
    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();
      setState(() {
        yukleniyor = true;
      });
      //hata durumunu kontrol için.
      try {
        //kayıt işlemi bitene kadar beklemek için await
        //yetkilendirme servisi objesi oluşturmak yerine provider ın sağladığı yetkilendirme servisi objesini yazıyoruz.
        await YetkilendirmeServisi().mailIleKayit(email, sifre);
        //kayıt bittikten sonra bir önceki sayfaya dönmek için
        Navigator.pop(context);
      } catch (hata) {
        //hata mesajı gösteriminde yükleniyor animasyona gerek kalmadığı için.
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
      hataMesaji = "Girdiğiniz email geçersiz!";
    } else if (hataKodu == "email-already-in-use") {
      hataMesaji = "Zaten böyle bir email kayıtlı!";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Daha zor bir şifre tercih edin!";
    } else if (hataKodu == "operation-not-allowed") {
      hataMesaji = "Erişime izin verilmiyor";
    }
    //snackbar da hatayı göstermek istiyoruz
    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
