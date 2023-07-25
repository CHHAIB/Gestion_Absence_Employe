import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  void _setateless() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Image.asset("images/ensias.png")),
              Center(child: Image.asset("images/chatbot.png")),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.chat),
        label: Text('Lancer le chatBot'),
        onPressed: () async {
          try {
            dynamic conversationObject = {
              'appId': '193521d059b613ca2dc4df0c1ee72c396',
              'authenticationTypeId': 1,
              'name': 'Bot Absence', // Modifier le nom de l'utilisateur
              'userName':
                  'Fatima Chhaib', // Modifier l'adresse e-mail de l'utilisateur
              'email': 'chhaibfatima1@gmail.com',
              // Remplacez par votre APP_ID Kommunicate
            };
            String? clientConversationId =
                await KommunicateFlutterPlugin.buildConversation(
                    conversationObject);
            print("Conversation builder success : $clientConversationId");
          } catch (error) {
            print("Conversation builder error : $error");
          }
        },
      ),
    );
  }
}
