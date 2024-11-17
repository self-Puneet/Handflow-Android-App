import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceFeature extends StatefulWidget {
  
  @override
  _VoiceFeatureState createState() => _VoiceFeatureState();
}

class _VoiceFeatureState extends State<VoiceFeature> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  Timer? _pauseTimer;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FlutterTts _flutterTts = FlutterTts();

  // Define constants
  // static const String deviceKey = "device";
  static const String levelKey = "level";
  static const String isOnKey = "command";
  static const String deviceKey = "device";
  static const Map<String, String> wordToNumber = {
    'one': '1',
    'two': '2',
    'to': '2',
    'tu' : '2',
    'three': '3',
    'four': '4',
    'for': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
  };

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    if (status.isGranted) {
      _speechEnabled = await _speechToText.initialize();
    } else {
      print('Microphone permission denied');
    }
    setState(() {});
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    _pauseTimer?.cancel();
    setState(() {});
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US"); // Set the language
    await _flutterTts.setPitch(1.0); // Set the pitch
    await _flutterTts.speak(text); // Speak the text
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    // Reset the pause timer
    _pauseTimer?.cancel();
    _pauseTimer = Timer(const Duration(seconds: 2), () {
      _processRecognizedSpeech(_lastWords);
    });
  }

  Future<void> _processRecognizedSpeech(String speech) async {
    String lowerSpeech = speech.toLowerCase();
    List<String> words = lowerSpeech.split(" ");
    print(words);

    // Replace words with their respective numbers
    words = words.map((word) => wordToNumber[word] ?? word).toList();
    String combinedString = words.join(' ');

    String device = "none";
    if (combinedString.contains("device 1")) {
      device = "device_1";
    }
    else if (combinedString.contains("fan")) {
      device = "device_fan";
    }
    else {
      print("no device is selected");
    }

    int? level;
    if (combinedString.contains("speed")) {
      level = int.tryParse(RegExp(r'speed\s*(\d+)').firstMatch(combinedString)?.group(1) ?? '');
    } else if (combinedString.contains("level")) {
      level = int.tryParse(RegExp(r'level\s*(\d+)').firstMatch(combinedString)?.group(1) ?? '');
    }

    // Regex to extract device, level, and turn
    // int? device = int.tryParse(RegExp(r'device\s*(\d+)').firstMatch(combinedString)?.group(1) ?? '');
    // int? level = int.tryParse(RegExp(r'speed\s*(\d+)').firstMatch(combinedString)?.group(1) ?? '');
    bool isDeviceOn = RegExp(r'turn\s*on').hasMatch(combinedString);

    print(device);
    print(level);
    print(isDeviceOn);

    // Update Firebase
  //   if (device != null) {
  //     String devicePath = 'Device $device';
  //     try {
  //       final snapshot = await _database.child(devicePath).get();
  //       if (snapshot.exists) {
  //         await _database.child(devicePath).child(isOnKey).set(isDeviceOn);
  //         final snapshot1 = await _database.child(devicePath).child("level").get();
  //         if (snapshot1.exists) {
  //           if (isDeviceOn){
  //             await _database.child(devicePath).child(levelKey).set(level);
  //           }
  //           if (isDeviceOn){
              // _speak("Device $device is turned on with level $level");
  //           }
  //           else {
              // _speak("Device $device is turned off");
  //           }
  //         } else {
  //           print("Sorry, the level is not provided.");
  //           _speak("Device $device is turned ${isDeviceOn ? "on" : "off"}");
  //         }
  //       } else {
  //         print("Sorry, that device is not connected to our system.");
  //       }
  //     } catch (e) {
  //       print("Error updating Firebase: $e");
  //     }
  //   } else {
  //     print('Could not parse device or level from the speech input.');
  //   }
  // }
    if (device == "device_1") {
      if (isDeviceOn) {
        await _database.child("gestureData").child(deviceKey).set(device);
        await _database.child("gestureData").child(isOnKey).set("on");
        _speak("Device 1 is turned on");
      }
      else {
        await _database.child("gestureData").child(deviceKey).set(device);
        await _database.child("gestureData").child(isOnKey).set("off");
        _speak("Device 1 is turned off");
      }
    }
    else if (device != "none") {
      if (level != null) {
        if (isDeviceOn) {
          await _database.child("gestureData").child(deviceKey).set(device);
          await _database.child("gestureData").child(isOnKey).set("on");
          await _database.child("gestureData").child(levelKey).set(level.toString());
          _speak("Device fan is turned on with level $level");
        }
        else {
          await _database.child("gestureData").child(deviceKey).set(device);
          await _database.child("gestureData").child(isOnKey).set("off");
          await _database.child("gestureData").child(levelKey).set("0");
          _speak("Device fan is turned off");
        }
      }
      else {
        // if (isDeviceOn) {
        //   _speak("Device $device is turned on with level $level");
        //   _speak("I didn't get what level you want to change. Try Again !!");     
        // }
        // else {
        //   _speak("Device $device is turned off with level $level");
        // }
        if (isDeviceOn == false) {
          await _database.child("gestureData").child(deviceKey).set(device);
          await _database.child("gestureData").child(isOnKey).set("off");
          if (device == "device_fan") {
            await _database.child("gestureData").child(levelKey).set("0");
          }
          if (device == "device_1") {
            _speak("Device 1 is turned off");
          }
          else if (device == "device_fan") {
            _speak("Fan is turned off");
          }
        }
        else {
          _speak("I didn't get what level you want to change. Try Again !!");
        }
        print(isDeviceOn);
      }
    }
    else {
      _speak("I didn't get what you just said. Try Again !!");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the recognized text
          Container(
            height: 100,
            width: 800,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _speechToText.isListening
                  ? _lastWords
                  : _speechEnabled
                      ? 'Tap the microphone to start listening...'
                      : 'Speech not available',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          const SizedBox(height: 20),
          // Microphone button
          FloatingActionButton(
            onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
            tooltip: 'Listen',
            child: Icon(_speechToText.isNotListening ? Icons.mic : Icons.mic_off),
          ),
        ],
      ),
    );
  }
}
