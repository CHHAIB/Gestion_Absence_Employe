import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Employee")
          .where("uid", isEqualTo: uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          child: Column(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Container(
                color: Color.fromARGB(255, 215, 67, 67),
                width: double.infinity,
                height: 200,
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 190, 3),
                      child: greetings(),
                    ),
                    Text(
                      (document.data() as Map<String, dynamic>)["Fullname"],
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Text(
                      (document.data() as Map<String, dynamic>)["role"],
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    ));
  }
}

Widget greetings() {
  DateTime now = DateTime.now();
  var hour = now.hour;
  if (hour < 12) {
    return Text(
      "Bonjour,",
      style: TextStyle(fontSize: 20),
    );
  } else if (hour == 12) {
    return Text("Bonne après-midi,");
  } else
    return Text("Bonsoir,");
}
