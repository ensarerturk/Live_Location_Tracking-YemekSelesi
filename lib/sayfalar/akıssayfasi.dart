import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class AkisSayfasi extends StatefulWidget {
  @override
  _AkisSayfasiState createState() => _AkisSayfasiState();
}

class _AkisSayfasiState extends State<AkisSayfasi> {
  String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("yayınlanan").snapshots(),
        builder:
            // ignore: missing_return
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          id = FirebaseFirestore.instance.collection("yayınlanan").id;
          if (!snapshot.hasData) {
            return Text("Loading ...");
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
                                      shopping = false;
                                      if (map["shop"] == false) {
                                        shopping = true;
                                      }
                                      var ref = doc.reference;
                                      ref.update({"shop": shopping});
                                      print(shopping);
                                    }),
                              ],
                            ),
                          )
                        ],
                      )
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
