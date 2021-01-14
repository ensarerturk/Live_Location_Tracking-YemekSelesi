import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class KuryeTakip extends StatefulWidget {
  @override
  _KuryeTakipState createState() => _KuryeTakipState();
}

class _KuryeTakipState extends State<KuryeTakip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KURYE TAKİP"),
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
            .where("kurye", isEqualTo: true)
            .snapshots(),
        builder:
            // ignore: missing_return
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                    icon: Icon(Icons.airplanemode_active,
                                        color: Colors.indigo),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Sipariş Var"),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: [
                                                    Text(
                                                        "Sipariş yola çıkıyor mu?")
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
                                                    bool shopping = false;
                                                    bool siparis = false;
                                                    bool kurye = true;

                                                    if (map["shop"] == true) {
                                                      shopping = false;
                                                    }
                                                    if (map["siparis"] ==
                                                        true) {
                                                      siparis = false;
                                                    }
                                                    if (map["kurye"] == true) {
                                                      kurye = false;
                                                    }
                                                    ref.update(
                                                      {
                                                        "shop": shopping,
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
