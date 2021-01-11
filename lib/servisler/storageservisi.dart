import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageServisi {
  Reference _storage = FirebaseStorage.instance.ref();
  String resimID;

  Future<String> gonderiResimiYukle(File resimDosyasi) async {
    //resimlerin benzersiz isimleri olamsı gerekir
    resimID = Uuid().v4();
    //uploadTask yükleme sürecini takip etmeyi ve yönetmeyi sağlar.
    UploadTask yuklemeYoneticisi =
        _storage.child("resimler/gönderi_$resimID.jpg").putFile(resimDosyasi);

    TaskSnapshot snapShot = await yuklemeYoneticisi;
    String yuklenenResimUrl = await snapShot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }
}
