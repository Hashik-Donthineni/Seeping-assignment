import 'package:flutter/material.dart';

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

  @override
  void initState() {
    //TODO: Initialize the sleeper
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
          //TODO:Start the sleeper
          setState(() {
            processList.add(++count);
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
                  "Process ID:$s",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
