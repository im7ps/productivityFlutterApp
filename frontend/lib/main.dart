import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carica le variabili d'ambiente. Fallisce silenziosamente se il file manca (gestito dal fallback)
  // ma per production è meglio gestire l'errore.
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found. Using default fallbacks.");
  }
  
  runApp(
    const ProviderScope(
      child: WhatIveDoneApp(),
    ),
  );
}