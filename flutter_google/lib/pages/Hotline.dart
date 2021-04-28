import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Hotline extends StatefulWidget {
  @override
  _HotlineState createState() => _HotlineState();
}

class _HotlineState extends State<Hotline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('Hotline Numbers').snapshots(),
        builder: (context, snapshot){
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder:(context, index){
              DocumentSnapshot course = snapshot.data.documents[index];
              return ListTile(
                title: Text(course['Name Of Hotline'],style: TextStyle(fontSize: 18, fontFamily: 'Times')),
                subtitle: Text(course['Phone Number'].toString(), style: TextStyle(fontSize: 17, fontFamily: 'Times')),
                trailing: Text(course['Category'], style: TextStyle(fontSize: 20, fontFamily: 'Times')),

              );
            },


          );
        },
      )
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: StreamBuilder(
        stream: Firestore.instance.collection('Hotline Numbers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }


          return ListView(
            children: snapshot.data.documents.map((document){
              return Center(


                child: Container(


                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/7,
                    child: Text.rich(
                        TextSpan(
                        text: document['Name Of Hotline'], style: TextStyle(fontSize: 20),
                          children:<TextSpan>[
                            TextSpan(text: '\n'),
                            TextSpan(text: "Category: " + document['Category'], style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20)),
                            TextSpan(text: '\n'),
                            TextSpan(text: document['Phone Number'].toString(), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],

                        ),
                    )

                ),
              );
            }).toList(),
          );


        }
      ),
    );
  }

 */
}


