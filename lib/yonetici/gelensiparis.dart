import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

class GelenSiparis extends StatefulWidget {
  @override
  _GelenSiparisState createState() => _GelenSiparisState();
}

class _GelenSiparisState extends State<GelenSiparis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GELEN SİPARİŞ"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("yayınlanan")
            .where("siparis", isEqualTo: true)
            .snapshots(),
        builder:
            // ignore: missing_return
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text("Loading ..."));
          }
          // ignore: deprecated_member_use
          int lenght = snapshot.data.documents.length;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0.1,
                childAspectRatio: 0.800),
            itemCount: lenght,
            padding: EdgeInsets.all(2.0),
            // ignore: missing_return
            itemBuilder: (_, int index) {
              // ignore: deprecated_member_use
              final DocumentSnapshot doc = snapshot.data.documents[index];
              var gelenSiparis = doc.id;

              final map = doc.data();
              return new Container(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                              child: new Container(
                            child: Image.network(
                              "${doc.data()["image"]}" + "?alt=media",
                            ),
                            width: 170,
                            height: 120,
                          )),
                        ],
                      ),
                      Expanded(
                        child: ListTile(
                            title: Text(
                              doc.data()["name"],
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 19.0),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.id,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                                Text(
                                  doc.data()["fiyat"].toString() + " TL",
                                  style: TextStyle(),
                                )
                              ],
                            )),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: new Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.wallet_travel,
                                        color: Colors.indigo),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  " ${gelenSiparis} id numaralı kişiden sipariş alınmıştır"),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: [
                                                    Text(
                                                        "Siparişinizi onaylıyor musunuz?")
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text("Hayır"),
                                                  onPressed: () {
                                                    var ref = doc.reference;
                                                    bool shopping = false;
                                                    bool siparis = true;

                                                    if (map["shop"] == false) {
                                                      shopping = true;
                                                    }
                                                    if (map["siparis"] ==
                                                        false) {
                                                      siparis = true;
                                                    }

                                                    ref.update(
                                                      {
                                                        "shop": shopping,
                                                        "siparis": siparis,
                                                      },
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text("EVET"),
                                                  onPressed: () {
                                                    AlertDialog(
                                                      title: Text("Sipariş "),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                          children: [
                                                            Text(
                                                                "Siparişinizi onaylıyor musunuz?")
                                                          ],
                                                        ),
                                                      ),
                                                    );

                                                    var ref = doc.reference;

                                                    bool siparis = true;
                                                    bool kurye = false;

                                                    if (map["siparis"] ==
                                                        true) {
                                                      siparis = false;
                                                    }
                                                    if (map["kurye"] == false) {
                                                      kurye = true;
                                                    }
                                                    ref.update(
                                                      {
                                                        "siparis": siparis,
                                                        "kurye": kurye
                                                      },
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
