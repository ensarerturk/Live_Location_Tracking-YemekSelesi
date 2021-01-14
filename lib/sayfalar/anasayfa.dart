import 'package:flutter/material.dart';
import 'package:mobile_project/sayfalar/ak%C4%B1ssayfasi.dart';
import 'package:mobile_project/sayfalar/girissayfasi.dart';

import 'package:mobile_project/sayfalar/sepetim.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _aktifSayfa = 0;
  PageController sayfaKumanda;

  @override
  void initState() {
    super.initState();
    sayfaKumanda = PageController();
  }

//performans sotunlarını önlemek için.
  @override
  void dispose() {
    sayfaKumanda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ANA SAYFA"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: PageView(
        onPageChanged: (acilanSayfaNo) {
          setState(() {
            _aktifSayfa = acilanSayfaNo;
          });
        },
        //controller PageController tipinde biz de sayfa değişimi istiyoruz.
        controller: sayfaKumanda,
        children: <Widget>[AkisSayfasi(), SepetimCrud()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktifSayfa,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Akış")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              // ignore: deprecated_member_use
              title: Text("Sepetim")),
        ],
        onTap: (secilenSayfaNo) {
          setState(() {
            sayfaKumanda.jumpToPage(secilenSayfaNo);
          });
        },
      ),
    );
  }
}
