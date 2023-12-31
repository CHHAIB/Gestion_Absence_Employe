import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({Key? key}) : super(key: key);

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  String variable = "check out";
  bool sort = true;
  String Sort = "Ascending";
  Widget icon = Icon(Icons.arrow_circle_up);

  String formatDate(String date) {
    // Function to format the date
    // Implement your own logic here
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                "L'information financière",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Employee")
                      .where("uid",
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      child: Column(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          return Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      elevation: 12,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 20, 20, 10),
                                            child: Text(
                                              (document.data() as Map<String,
                                                          dynamic>)
                                                      .cast<String, dynamic>()[
                                                          "Total Amount"]
                                                      ?.toString() ??
                                                  "" + " DH",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 168, 31, 84),
                                                fontSize: 45,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Montant total",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Historique des revenus",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 47, 170, 16),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: TextButton.icon(
                                label: Text(
                                  "Date",
                                  style: TextStyle(fontSize: 20),
                                ),
                                icon: icon,
                                onPressed: () {
                                  if (sort == true) {
                                    setState(() {
                                      sort = false;
                                      Sort = "Descending";
                                      icon = Icon(Icons.arrow_circle_down);
                                    });
                                  } else if (sort == false) {
                                    setState(() {
                                      sort = true;
                                      Sort = "Ascending ";
                                      icon = Icon(Icons.arrow_circle_up);
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.black,
                                  splashFactory: NoSplash.splashFactory,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextButton.icon(
                                label: Text(
                                  "Montant",
                                  style: TextStyle(fontSize: 20),
                                ),
                                icon: icon,
                                onPressed: () {
                                  if (sort == true) {
                                    setState(() {
                                      sort = false;
                                      Sort = "Descending";
                                      icon = Icon(Icons.arrow_circle_up);
                                    });
                                  } else if (sort == false) {
                                    setState(() {
                                      sort = true;
                                      Sort = "Ascending ";
                                      icon = Icon(Icons.arrow_circle_down);
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.black,
                                  splashFactory: NoSplash.splashFactory,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Employee")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection("History")
                                .orderBy(variable, descending: sort)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.yellow[900],
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                return Container(
                                  child: Column(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      String? checkout = (document.data()
                                          as Map<String, dynamic>)["check out"];

                                      String? amount = (document.data() as Map<
                                              String,
                                              dynamic>?)?["current amount"]
                                          ?.toString();

                                      return Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    formatDate(checkout!),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 30),
                                                  child: Text(
                                                    amount ?? "",
                                                    style:
                                                        TextStyle(fontSize: 19),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }

                              return Text("No data");
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
