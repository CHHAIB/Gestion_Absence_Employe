//import 'dart:convert';
//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter_email_sender/flutter_email_sender.dart';
//import 'firebase_api.dart';
import 'button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:path/path.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  runApp(MarquerPresence());
}

class MarquerPresence extends StatefulWidget {
  @override
  MarquerPresenceState createState() => MarquerPresenceState();
}

Future alertEntree(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Marquage'),
        content: const Text('Votre Entrée est bien Entregistrée'),
        actions: [
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future alertSortie(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Marquage'),
        content: const Text('Votre Sortie est bien Entregistrée'),
        actions: [
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class MarquerPresenceState extends State<MarquerPresence> {
  int countSortie = 1;
  int countEntrer = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marquer l'entré et la sortie"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 215, 67, 67),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Marquer l\'entrée',
                icon: Icons.add_to_home_screen_rounded,
                onClicked: () async {
                  //if (countEntrer == 1) {
                  await marquerEntrer();
                  // countEntrer--;
                  alertEntree(context);
                  //}
                },
              ),
              SizedBox(height: 8),
              SizedBox(height: 48),
              ButtonWidget(
                text: 'Marquer la sortie',
                icon: Icons.add_to_home_screen,
                onClicked: () async {
                  // if (countSortie == 1) {
                  await marquerSortie();
                  //countSortie--;
                  alertSortie(context);
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formaDtate2(String time) {
    String hours;
    if (time != "today") {
      var date = time.substring(0, 10);
      hours = time.substring(11, 16);
      var today = DateTime.now().toString();
      if (date == today.substring(0, 10)) {
        return Text(
          date + " à " + hours,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 32, 224, 38),
              fontWeight: FontWeight.bold),
        );
      } else if (date != today.substring(0, 10)) {
        return Text(
          "No record",
          textAlign: TextAlign.center,
        );
      } else {
        return Text(
          date + " à " + hours,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        );
      }
    } else {
      return Text(
        "No record",
        textAlign: TextAlign.center,
      );
    }
  }

  Future marquerEntrer() async {
    DateTime checkin = new DateTime.now();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid; // current user uploader ID
    try {
      DocumentReference documentReference1 =
          FirebaseFirestore.instance.collection("Employee").doc(uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(documentReference1, {
          "check in": checkin.toString(),
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future marquerSortie() async {
    DateTime checkout = new DateTime.now();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid; // current user uploader ID
    try {
      DocumentReference documentReference1 =
          FirebaseFirestore.instance.collection("Employee").doc(uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(documentReference1, {
          "check out": checkout.toString(),
        });
      });

      setAttendeceHistory(checkout, uid!);

      return true;
    } catch (e) {
      return false;
    }
  }
}

Future<void> setAttendeceHistory(DateTime checkout, String uid) async {
  var toDouble;
  FirebaseFirestore.instance
      .collection('Employee')
      .where("uid", isEqualTo: uid)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      String checkin = doc["check in"];
      print("Check in : " + doc["check in"]);
      Duration difference = checkout.difference(DateTime.parse(checkin));

      print(difference.inHours);

      if (!difference.isNegative) {
        var diff = difference.inSeconds
            .toString(); // for now set as seconds(demo purpose)
        print(diff);
        var hours = double.parse(diff);
        var total = hours * 3;
        var ftotal = total.toStringAsFixed(2);
        toDouble = double.parse(ftotal);
        print(total);
        print(ftotal);
      }

      FirebaseFirestore.instance
          .collection("Employee")
          .doc(uid)
          .collection("History")
          .add({
        "check in": checkin.toString(),
        "check out": checkout.toString(),
        "current amount": toDouble,
      });
    });

    // var value = double.parse(Amount);
    DocumentReference documentReference1 =
        FirebaseFirestore.instance.collection("Employee").doc(uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot1 = await transaction.get(documentReference1);

      if (!snapshot1.exists) {
        documentReference1.set({"Total Amount": toDouble});
        return true;
      } else {
        var newAmount =
            (snapshot1.data() as Map<String, dynamic>)["Total Amount"]! +
                toDouble;

        transaction.update(documentReference1, {"Total Amount": newAmount});

        return true;
      }
    });
  });
}
