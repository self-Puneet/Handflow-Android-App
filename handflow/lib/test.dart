import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build (BuildContext context) {
    return const MaterialApp(
      home: MainAppBody(),
    );
  }
}

class MainAppBody extends StatefulWidget {
  const MainAppBody({super.key});

  @override
  _MainAppBodyState createState() => _MainAppBodyState();
}

class _MainAppBodyState extends State<MainAppBody> {

  // array depecting the state of all the sub UI classes
  List<List<int>> arr = [
    [0, 0],
    [0, 0]
  ];

  // updating the array and state of UI (refresing the UI)
  void updateArray(int row, int col) {
    setState(() {
      arr[row][col] += 1;
    });
  }


  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Class1 (arr: arr[0], onupdate: updateArray),
          Class2 (arr: arr[0]),
        ],
      ),
    );
  }
}


class Class1 extends StatefulWidget {
  final List<int> arr;
  final Function(int, int) onupdate;

  Class1({required this.arr, required this.onupdate});

  @override
  _Class1State createState() => _Class1State();
}

class _Class1State extends State<Class1> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => widget.onupdate(0, 0), 
          child: Text(widget.arr[0].toString()),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => widget.onupdate(0, 1), 
          child: Text(widget.arr[1].toString()),
        ),
      ],
    );
  }
}

class Class2 extends StatefulWidget {
  final List<int> arr;

  Class2({required this.arr});

  @override
  _Class2State createState() => _Class2State();
}

class _Class2State extends State<Class2> {
  @override
  Widget build (BuildContext context) {
    return Row(
      children: [
        Text(widget.arr[0].toString()),
        SizedBox(width: 10),
        Text(widget.arr[1].toString()),
      ],
    );
  }
}