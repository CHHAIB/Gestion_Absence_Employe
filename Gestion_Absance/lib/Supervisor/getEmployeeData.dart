import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<String> cout = [];
List<String> cin = [];
List<String> currentAmount = [];

class GetEmployeeData extends StatefulWidget {
  final String uid;

  GetEmployeeData(this.uid);

  @override
  State<GetEmployeeData> createState() => _GetEmployeeDataState();
}

class _GetEmployeeDataState extends State<GetEmployeeData> {
  @override
  void initState() {
    cin.clear();
    cout.clear();
    currentAmount.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Employee")
                  .doc(widget.uid)
                  .collection("History")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.yellow[900],
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Container(
                    child: Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        var checkIn = (document.data()
                            as Map<String, dynamic>)["check in"];
                        var checkOut = (document.data()
                            as Map<String, dynamic>)["check out"];
                        var currentAmount = (document.data()
                                as Map<String, dynamic>)["current amount"]
                            .toString();

                        getinfo(checkIn, checkOut, currentAmount);

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                formatDateSupervisor(checkOut),
                                formatDateSupervisor(checkIn),
                                formatDateSupervisor(checkOut),
                                Text(currentAmount),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                }

                return Text("No data");
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget formatDateSupervisor(String time) {
  String formattedTime;
  if (time != "today") {
    formattedTime = time.substring(2, 10);
    return Text(
      formattedTime,
    );
  } else {
    return Text(
      "No Data",
      style: TextStyle(fontSize: 19),
    );
  }
}

void getinfo(String checkIn, String checkOut, String amount) {
  if (checkIn != "") {
    cin.add(checkIn);
    cout.add(checkOut);
    currentAmount.add(amount);
  } else {
    print("No data found");
  }
}
