# HandFlow Android App

This is the official Android application for the [**HandFlow project**](https://github.com/Self-nasu/HandFlow), designed to enable seamless control of smart devices through **gesture-based** and **voice-based** commands.

<div align="center">
  <img src="https://cdn.discordapp.com/attachments/1210507622747209748/1372601847088545792/WhatsApp_Image_2025-05-15_at_21.14.39_544b7dac.jpg?ex=68275e96&is=68260d16&hm=99631adc50a0fc1f2681dad0dbe09ba2b12242e2a5257b0678ceb418383657d5&" alt="HandFlow App Demo" width="250"/>
</div>

---

## 🔎 About HandFlow

**HandFlow** is a smart home automation project focused on **intuitive control** of electronic devices. By integrating **gesture recognition** and **voice assistance**, it enhances accessibility and user experience.

📌 For complete details on the core system, hardware components, and gesture handling, visit the [main HandFlow repository](https://github.com/Self-nasu/HandFlow).

---

## 🛠️ Technologies Used

### <img src="https://storage.googleapis.com/cms-storage-bucket/a9d6ce81aee44ae017ee.png" alt="Flutter Logo" width="24" /> Flutter

* **Purpose:** Cross-platform framework used to build the Android UI.
* **Why Flutter?** Fast development, expressive UI, and native performance.

---

### <img src="https://firebase.google.com/downloads/brand-guidelines/PNG/logo-vertical.png" alt="Firebase Logo" width="24" /> Firebase Realtime Database

* **Purpose:** Real-time backend for synchronizing device states and ESP32 status.
* **Why Firebase?** Instant updates without HTTP polling, ensuring smooth real-time communication.

---

### 🗣️ Speech Recognition & Text-to-Speech

* **Purpose:** Enables natural voice interaction to control devices.
* **Packages Used:**

  * `speech_to_text` – For real-time speech recognition.
  * `flutter_tts` – For spoken feedback using text-to-speech.

---

## 🚀 Features

* **🎛️ Intuitive Device Control:** Turn devices on/off and adjust settings via a touch-friendly interface.
* **⚡ Real-Time Sync:** Device state and ESP32 status update instantly via Firebase.
* **🎙️ Voice Assistant:** Operate devices hands-free with voice commands.

---

## 🧠 Voice Assistant Guide

Use the following voice command formats:

```bash
Turn on device 1
Turn off device 1
Turn on fan level 3
Turn off fan
```

✅ The order of words doesn’t matter – the assistant uses natural language parsing to understand intent.

---

## 📌 Additional Resources

🔗 Visit the [main HandFlow repository](https://github.com/Self-nasu/HandFlow) for:

* Hardware schematics
* Gesture recognition algorithms
* ESP32 firmware
* Detailed documentation