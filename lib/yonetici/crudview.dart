import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/yonetici/crudupdate.dart';
import 'package:mobile_project/yonetici/gelensiparis.dart';
import 'package:mobile_project/yonetici/yoneticicrud.dart';

class CrudSayfasi extends StatefulWidget {
  @override
  _CrudSayfasiState createState() => _CrudSayfasiState();
}

class _CrudSayfasiState extends State<CrudSayfasi> {
  TextEditingController recipeInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;
  TextEditingController fiyatTextiKumandasi = TextEditingController();

  String id;
  final db = FirebaseFirestore.instance;
  //final _formKey = GlobalKey<FormState>();

  String name;
  String recipe;
  String gosFiy;

  void deleteData(DocumentSnapshot doc) async {
    // ignore: deprecated_member_use
    await db.collection("yayınlanan").document(doc.documentID).delete();
    setState(() {
      id = null;
    });
  }

  navigateToDetail(DocumentSnapshot ds) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => YoneticiCrudUpdate(
              ds: ds,
            )));
  }

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            tooltip: "List",
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GelenSiparis()));
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("yayınlanan").snapshots(),
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
              return new Container(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                              onTap: () => navigateToDetail(doc),
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
                            subtitle: Text(
                              doc.data()["recipe"],
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 12.0),
                            ),
                            onTap: () => navigateToDetail(doc)),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: new Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    deleteData(doc);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_red_eye),
                                  color: Colors.blueAccent,
                                  onPressed: () {},
                                )
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.ad_units,
          color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => YoneticiCrud()));
        },
      ),
    );
  }
}
