import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app_flutter/Employee/home_screen_drawer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String role = "role";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool checkEmployeeValidate(value) {
    print("This is " + value.toString());
    role = value.toString();
    try {
      if (role == "Employee") {
        return true;
      } else {
        throw Exception("You are not Employee");
      }
    } catch (exception) {
      showError(exception.toString());
      return false;
    }
  }

  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  Future<bool> signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        var usr = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        var uid = usr.user?.uid;
        print(uid);
        DocumentReference docu =
            FirebaseFirestore.instance.collection("Employee").doc(uid);

        String test = "test";

        var hello = docu.get().then((value) {
          if (value.exists) {
            test = (value.data() as Map<String, dynamic>)["role"];
            return test;
          }
        });

        var x = hello.then((value) => checkEmployeeValidate(value));

        return x;
      } catch (exception) {
        print(exception);
        showError(exception.toString());
        return false;
      }
    }
    return false;
  }

  void showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 400,
                child: Image(image: AssetImage("images/login.jpg")),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          child: TextFormField(
                            controller: _emailField,
                            validator: (emailInput) {
                              if (emailInput!.isEmpty) {
                                return "Entrez correctement l'e-mail";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: "email@email.com",
                            ),
                            onSaved: (email) =>
                                _emailField = email as TextEditingController,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _passwordField,
                            validator: (passwordInput) {
                              if (passwordInput!.length < 6) {
                                return "Entrez au moins 6 caractères";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Mot de passe",
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                              hintText: "password123",
                            ),
                            onSaved: (password) => _passwordField =
                                password as TextEditingController,
                            obscureText: true,
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 215, 67, 67),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      ),
                      child: Text(
                        "Connexion",
                        strutStyle: StrutStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                        // style: GoogleFonts.getFont("Lato",
                        //     fontWeight: FontWeight.bold,
                        //     color: Color.fromARGB(255, 215, 67, 67)Accent[700]),
                      ),
                      onPressed: () async {
                        bool shouldNavigate =
                            await signIn(_emailField.text, _passwordField.text);
                        if (shouldNavigate) {
                          Navigator.pop(context);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
