import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

// ignore: must_be_immutable
class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  var text = 'Presione el boton para comenzar a hablar';
  var isListening = false;
  Timer? timer;

  Timer? agradecimiento;

  @override
  void dispose() {
    speechToText.stop();
    timer?.cancel(); // Cancela el temporizador si aún está activo
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 4000),
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        glowColor: Colors.redAccent,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  });
                });

                timer = Timer(const Duration(seconds: 4), () async {
                  setState(() {
                    isListening = false;
                    speechToText.stop();
                  });
                  String clasificacion = "";
                  final canecas =
                      FirebaseFirestore.instance.collection('desechos');

                  final query = canecas.where('nombre', isEqualTo: text);
                  final snapshot = await query.get();
                  if (snapshot.docs.isEmpty) {
                    clasificacion = "No se encontro el desecho";
                  } else {
                    for (var doc in snapshot.docs) {
                      print("----->>>>>");
                      print(doc);
                      // ignore: prefer_interpolation_to_compose_strings
                      clasificacion = "va en la caneca " + doc['caneca'];
                    }
                  }
                  setState(() {
                    text = "$text $clasificacion";
                  });

                  agradecimiento = Timer(const Duration(seconds: 4), () {
                    setState(() {
                      text = "Muchas gracias por clasificar los desechos";
                    });
                  });
                });
              }
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.redAccent,
            radius: 35,
            // ignore: dead_code
            child: Icon(isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(
        leading: const Icon(Icons.restore_from_trash_outlined),
        toolbarHeight: 80.0,
        title: const Text(
          "Clasificador de desechos",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w800,
                fontSize: 34.0),
          ),
        ),
      ),
    );
  }
}
