import 'package:flutter/material.dart';
import 'package:mobile_project/modeller/kullanici.dart';
import 'package:mobile_project/sayfalar/anasayfa.dart';
import 'package:mobile_project/sayfalar/girissayfasi.dart';
import 'package:mobile_project/servisler/yetkilendirmeservisi.dart';

class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: YetkilendirmeServisi().durumTakipcisi,
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          Kullanici aktifkullanici = snapshot.data;
          return AnaSayfa();
        } else {
          return GirisSayfasi();
        }
      },
    );
  }
}
