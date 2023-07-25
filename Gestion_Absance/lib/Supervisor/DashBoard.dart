import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app_flutter/Supervisor/addemployee.dart';
import 'package:my_app_flutter/Supervisor/info.dart';
import 'package:my_app_flutter/Supervisor/profile.dart';
import 'package:my_app_flutter/Supervisor/listofemployee.dart';
import '../main.dart';

class Dashboard extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pop(context);
      FirebaseAuth.instance.currentUser;
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      AlertDialog(
        title: Text("Déconnectez-vous à nouveau"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: MaterialButton(
                      elevation: 10,
                      height: 100.0,
                      minWidth: 150.0,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("Profile"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profile()),
                        );
                      },
                      splashColor: Colors.redAccent,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: MaterialButton(
                      elevation: 10,
                      height: 100.0,
                      minWidth: 150.0,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("Présence"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Attendance()),
                        );
                      },
                      splashColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: MaterialButton(
                      elevation: 10,
                      height: 100.0,
                      minWidth: 150.0,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("Se déconnecter"),
                      onPressed: () {
                        Navigator.pop(context);
                        _logout(context);
                      },
                      splashColor: Colors.redAccent,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: MaterialButton(
                      elevation: 10,
                      height: 100.0,
                      minWidth: 150.0,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("À propos de"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => About()),
                        );
                      },
                      splashColor: Color.fromARGB(255, 215, 67, 67),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: MaterialButton(
                      elevation: 10,
                      height: 100.0,
                      minWidth: 150.0,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("Ajouter un employé"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEmployee()),
                        );
                      },
                      splashColor: Colors.redAccent,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
