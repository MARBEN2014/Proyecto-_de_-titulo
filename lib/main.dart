import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/firebase_options.dart';
import 'package:paraflorseer/screens/index_screen.dart';
import 'package:paraflorseer/screens/welcome_screen.dart';
//import 'package:paraflorseer/screens/register2_screen.dart';
//import 'package:paraflorseer/screens/index_screen.dart';
//import 'package:paraflorseer/screens/welcome_screen.dart';
import 'package:paraflorseer/themes/app_theme.dart';
import 'package:paraflorseer/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlorSer App',
      theme: AppTheme.lightTheme, // Aplicamos el tema
      home: const WelcomeScreen(), // Pantalla inicial
      routes:
          AppRoutes.getRoutes(), // Cargamos las rutas desde el archivo separado
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
    );
  }
}
