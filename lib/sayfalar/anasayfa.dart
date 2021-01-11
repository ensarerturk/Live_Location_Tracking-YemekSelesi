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
          FlatButton(
            child: Text("Çıkış Yap"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GirisSayfasi()));
            },
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
        children: <Widget>[AkisSayfasi(), Sepetim()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktifSayfa,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.green,
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
