import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'home.dart';

class VerifyPage extends StatefulWidget {
  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String generateOTP() {
    Random random = Random();
    int otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }

  Future<void> sendEmail(String userEmail, String urlDownload) async {
    final serviceId = 'service_zmt05gj';
    final templateId = 'template_dca139q';
    final userId = 'eRWWHd200lqdnOe1k';
    var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      var response = await http.post(
        url,
        headers: {
          'origin': "http://localhost",
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            "from_name": userEmail,
            "message": _otpController.text
          }
        }),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully');
      } else {
        print('Failed to send email');
      }
    } catch (error) {
      print('Error sending email: $error');
    }
  }

  Future<void> sendOTP() async {
    String otp = generateOTP();
    _otpController.text = otp;
    await sendEmail(_emailController.text, otp);
  }

  void verifyOTP() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Verification d'Email"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "images/email.png",
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Entrez l'e-mail",
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter OTP",
                      labelText: "OTP",
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    child: Text("Send OTP"),
                    onPressed: () async {
                      await sendOTP();
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    child: Text("Verifier OTP"),
                    onPressed: verifyOTP,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
