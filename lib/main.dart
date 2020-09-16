import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'LazySleeper.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.red,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: SleepingProcessHome(),
  ));
}

class SleepingProcessHome extends StatefulWidget {
  @override
  _SleepingProcessHomeState createState() => _SleepingProcessHomeState();
}

class _SleepingProcessHomeState extends State<SleepingProcessHome> {
  List<int> processList = [];
  int count = 0;
  LazySleeper bindings;

  @override
  void initState() {
    bindings = LazySleeper((int id) {
      print("Removing process with ID: $id\n");
      setState(() {
        processList.remove(id);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Equalitie"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children:
            processList.map((process) => getRow(process.toString())).toList(),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Second argument is the sleep time.
          bindings.startSleeping(++count, 5);
          setState(() {
            processList.add(count);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getRow(String s) {
    return Card(
        color: Colors.grey[200],
        margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text(
                  "Process ID: $s",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SpinKitFadingCircle(
                color: Colors.deepOrange,
                size: 25.0,
              ),
            ],
          ),
        ));
  }
}
