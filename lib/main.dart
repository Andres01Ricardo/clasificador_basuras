import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:clasificador_basuras/speech_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clasificador Basuras',
      debugShowCheckedModeBanner: false,
      home: const SpeechScreen(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
    );
  }
}
