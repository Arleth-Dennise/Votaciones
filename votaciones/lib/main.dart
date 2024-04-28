import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase Core
import 'package:votaciones/firebase_options.dart';
import 'bandas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(VotacionesApp());
}

class VotacionesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votaciones de Bandas de Rock',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      debugShowCheckedModeBanner: false,
      home: BandasScreen(),
    );
  }
}