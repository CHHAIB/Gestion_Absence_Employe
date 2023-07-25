import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_app_flutter/Employee/updateUserProfile.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  late File _image;
  // final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    void _showUpdatePannel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            child: UpdateUserProfle(),
          );
        },
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Employee")
                      .where("uid", isEqualTo: uid)
                      .snapshots(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Container(
                      child: Column(
                        children: snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            return Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              50,
                                              8,
                                              8,
                                              8,
                                            ),
                                            child: ClipOval(
                                              child: Container(
                                                child: SizedBox(
                                                  width: 180,
                                                  height: 180,
                                                  child: checkprofile(
                                                    (document.data() as Map<
                                                            String, dynamic>)[
                                                        "profile pic"],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 80),
                                            child: IconButton(
                                              icon: Icon(
                                                  Icons.camera_alt_outlined),
                                              onPressed: () async {
                                                // ImagePicker pick = ImagePicker();
                                                // _image = (await pick.getImage(source: ImageSource.gallery)) as File;

                                                String filename =
                                                    basename(_image.path);
                                                var storage = FirebaseStorage
                                                    .instance
                                                    .ref()
                                                    .child(filename);
                                                var url = await storage
                                                    .getDownloadURL();
                                                FirebaseFirestore.instance
                                                    .collection("Employee")
                                                    .doc(uid)
                                                    .update({
                                                  "profile pic": url,
                                                });

                                                setState(() {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "pic uploaded")),
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      child: Text(
                                        "${(document.data() as Map<String, dynamic>)["Fullname"]?.toString().toUpperCase() ?? ""}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Card(
                                      shadowColor: Colors.amber[600],
                                      elevation: 8.5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Icon(Icons.email_outlined),
                                            SizedBox(width: 45),
                                            Text(
                                              "${(document.data() as Map<String, dynamic>)["email"]}",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      shadowColor: Colors.amber[600],
                                      elevation: 8.5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Icon(Icons.location_on),
                                            SizedBox(width: 45),
                                            Text(
                                              "${(document.data() as Map<String, dynamic>)["address"]}",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      shadowColor: Colors.amber[600],
                                      elevation: 8.5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(width: 45),
                                            Text(
                                              "${(document.data() as Map<String, dynamic>)["phone"]}",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      shadowColor: Colors.amber[600],
                                      elevation: 8.5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Icon(Icons.person_outline_outlined),
                                            SizedBox(width: 45),
                                            Text(
                                              "${(document.data() as Map<String, dynamic>)["role"]}",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: ElevatedButton(
                      child: Text("Mise à jour des infos"),
                      onPressed: () => _showUpdatePannel(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget checkprofile(String url) {
  if (url == "") {
    return Image(image: AssetImage("images/profile.jpg"));
  }
  return Image.network(url);
}
