import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_project/modeller/kullanici.dart';
import 'package:uuid/uuid.dart';

class FireStoreServisi {
  String kullaniciID;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final DateTime zaman = DateTime.now();

  Future<void> kullaniciOlustur({id, email, kullaniciAdi}) async {
    // ignore: deprecated_member_use
    await _firestore.collection("kullanıcılar").document(id).setData({
      "kullaniciAdi": kullaniciAdi,
      "email": email,
      "olusturulmaZamani": zaman
    });
  }

  Future<void> gonderiOlustur({gonderiResmiURL, info, aciklama, fiyat}) async {
    kullaniciID = Uuid().v4();
    await _firestore.collection("gonderiler").add({
      "gonderiResmiURL": gonderiResmiURL,
      "info": info,
      "açıklama": aciklama,
      "fiyat": fiyat,
      "yayınlayanID": kullaniciID,
      "zaman": zaman
    });
  }

  gonderileriGetir() async {
    QuerySnapshot snapshot =
        // ignore: deprecated_member_use
        await _firestore.collection("gonderiler").getDocuments();

    List<Kullanici> gonderiler =
        // ignore: deprecated_member_use
        snapshot.documents.map((doc) => Kullanici.dokumandanUret(doc)).toList();
    return gonderiler;
  }
}
