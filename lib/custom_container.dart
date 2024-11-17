import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
class CustomContainer extends StatefulWidget {
  final String deviceId;
  final Function(bool) toggleLoading; // Function to toggle loading

  CustomContainer({required this.deviceId, required this.toggleLoading});

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String isDeviceOn = "off";
  String level = "1.0";
  double level1 = 1.0;

  @override
  void initState() {
    super.initState();
    _getDeviceStatus();
  }

  Future<void> _getDeviceStatus() async {
    final snapshot = await _database.child(widget.deviceId).get();
    if (snapshot.exists) {
      setState(() {
        isDeviceOn = snapshot.child("state").value as String;
        if (snapshot.child("level").exists) {
          level = snapshot.child("level").value.toString();
        }
      });
    }
    print(widget.deviceId + " " + isDeviceOn);
  }

  Future<void> _toggleDeviceStatus() async {
    widget.toggleLoading(true); // Show loader
    setState(() {
      isDeviceOn = (isDeviceOn == "off") ? "on" : "off";
    });

    if (isDeviceOn == "off") {
      await _database.child("gestureData").update({
        "device": widget.deviceId,
        "command": isDeviceOn,
        "level": "0",
      });
    } else {
      await _database.child("gestureData").update({
        "device": widget.deviceId,
        "command": isDeviceOn,
        "level": widget.deviceId == "device_fan" ? "1" : "0",
      });
    }
    await Future.delayed(const Duration(seconds: 1));
    widget.toggleLoading(false); // Hide loader
  }

  Future<void> _toggleDeviceLevel() async {
    widget.toggleLoading(true); // Show loader
    level = level1.toInt().toString();

    if (isDeviceOn == "off") {
      await _database.child("gestureData").update({
        "device": widget.deviceId,
        "command": "on",
        "level": level,
      });
      setState(() {
        isDeviceOn = "on";
      });
    } else {
      await _database.child("gestureData").update({
        "device": widget.deviceId,
        "level": level,
      });
    }
    await Future.delayed(const Duration(seconds: 1));
    widget.toggleLoading(false); // Hide loader
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb,
            size: 35.0,
            color: isDeviceOn == "on" ? Colors.amber : Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            widget.deviceId,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 2),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isDeviceOn == "on",
              onChanged: (value) => _toggleDeviceStatus(),
            ),
          ),
          if (widget.deviceId == "device_fan")
            Slider(
              value: level1,
              min: 1,
              max: 5,
              divisions: 4,
              label: level1.toInt().toString(),
              onChanged: (value) => setState(() => level1 = value),
              onChangeEnd: (value) => _toggleDeviceLevel(),
            ),
        ],
      ),
    );
  }
}
