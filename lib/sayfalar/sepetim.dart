import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:mobile_project/kurye/marker.dart';
import 'package:mobile_project/sayfalar/takipet.dart';

class SepetimCrud extends StatefulWidget {
  @override
  _SepetimCrudState createState() => _SepetimCrudState();
}

class _SepetimCrudState extends State<SepetimCrud> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEPETİM"),
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
              icon: Icon(Icons.motorcycle_sharp),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MusteriTakip()))),
          /*IconButton(
            icon: Icon(Icons.access_alarm),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MarkerTakip()));
            },
          )*/
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("yayınlanan")
            .where("shop", isEqualTo: true)
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
                                  doc.data()["recipe"],
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
                                    icon: Icon(
                                      Icons.shopping_basket,
                                      color: map["shop"] == true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    color: Colors.red,
                                    onPressed: () {
                                      bool shopping;
                                      shopping = true;
                                      if (map["shop"] == true) {
                                        shopping = false;
                                      }
                                      var ref = doc.reference;
                                      ref.update({"shop": shopping});
                                    }),
                                IconButton(
                                    icon: Icon(Icons.playlist_add_rounded,
                                        color: Colors.indigo),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Sipariş alınmıştır"),
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
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text("EVET"),
                                                  onPressed: () {
                                                    AlertDialog(
                                                      title: Text(
                                                          "Sipariş alınmıştır"),
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
                                                    bool shopping = true;
                                                    bool siparis = false;
                                                    if (map["shop"] == true) {
                                                      shopping = false;
                                                    }
                                                    if (map["siparis"] ==
                                                        false) {
                                                      siparis = true;
                                                    }
                                                    ref.update(
                                                      {
                                                        "shop": shopping,
                                                        "siparis": siparis
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
