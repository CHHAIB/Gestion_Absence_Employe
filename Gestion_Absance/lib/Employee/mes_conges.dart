import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp8());

class MyApp8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Mesconges(),
    );
  }
}

class Mesconges extends StatefulWidget {
  @override
  _MescongesState createState() => _MescongesState();
}

class _MescongesState extends State<Mesconges> {
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "La date choisie pour votre congé est :",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            Text(
              DateFormat('dd / MM / yyyy').format(currentDate),
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 215, 67, 67),
              ),
              onPressed: () => _selectDate(context),
              child: Text(
                'Sélectionner une date',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
