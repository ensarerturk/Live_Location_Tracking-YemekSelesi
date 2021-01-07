import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile_project/modeller/kullanici.dart';

class YetkilendirmeServisi {
  final _firebaseAuth = FirebaseAuth.instance;

  Kullanici _kullaniciOlustur(User kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Stream<Kullanici> get durumTakipcisi {
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }

  //istenilen şartlar sağlandığında AuthResult anahtarını almış olduk ve girisKartımıza atadık.
  //Kayıt olma işlemi gerçekleştiğinde authStateChanges sayesinde kendini dinleyen tüm widgetlar tarafına iletilir.
  //Yani yönlendirme sayfasındaki streamBuilder kullanıcıyı anasayfaya yönlendirir.
  Future<Kullanici> mailIleKayit(String eposta, String sifre) async {
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici> mailIleGiris(String eposta, String sifre) async {
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void> cikisYap() {
    return _firebaseAuth.signOut();
  }
}
