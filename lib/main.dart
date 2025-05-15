import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'voice.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = false; // Loading state to control full-screen loader
  String espStatus = "no";
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    setState(() {
      _isLoading = true;
    });

    await _database.child("espstate").set("no");
    await Future.delayed(Duration(seconds: 1));
    await _getESP_Status();

    setState(() {
      _isLoading = false;
    });
  }     

  Future<void> _getESP_Status() async {
    final snapshot = await _database.child("espstate").get();
    setState(() {
      espStatus = snapshot.value == "yes" ? "yes" : "no";
    });
  }

  void _toggleLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(),
          body: AppBody(
            espStatus: espStatus,
            toggleLoading: _toggleLoading, // Pass toggle function to AppBody
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _initializeApp,
            child: Icon(Icons.refresh),
            backgroundColor: Colors.blue,
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54, // Dimmed overlay background
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
class AppBody extends StatelessWidget {
  final String espStatus;
  final Function(bool) toggleLoading; // Function to toggle loading state

  AppBody({required this.espStatus, required this.toggleLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (espStatus == "yes")
          ConnectionBanner(),
        if (espStatus == "no")
          ConnectionErrorBanner(),
        Expanded(
          child: Row(
            children: [
              SizedBox(width: 20),
              CustomContainer(deviceId: "device_1", toggleLoading: toggleLoading),
              SizedBox(width: 10),
              CustomContainer(deviceId: "device_fan", toggleLoading: toggleLoading),
            ],
          ),
        ),
        VoiceFeature(),
      ],
    );
  }
}

Widget ConnectionBanner() {
  return Container(
    color: Colors.green.shade400,
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 8),
        Text(
          "Connected to ESP",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget ConnectionErrorBanner() {
  return Container(
    color: Colors.red.shade400,
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Colors.white),
        SizedBox(width: 8),
        Text(
          "Failed to connect to ESP",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
