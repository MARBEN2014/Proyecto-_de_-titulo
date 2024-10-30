import 'package:flutter/material.dart';
import 'package:paraflorseer/screens/index_screen.dart';
//import 'package:paraflorseer/screens/register2_screen.dart';
//import 'package:paraflorseer/screens/index_screen.dart';
//import 'package:paraflorseer/screens/welcome_screen.dart';
import 'package:paraflorseer/themes/app_theme.dart';
import 'package:paraflorseer/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlorSer App',
      theme: AppTheme.lightTheme, // Aplicamos el tema
      home: const IndexScreen(), // Pantalla inicial
      routes:
          AppRoutes.getRoutes(), // Cargamos las rutas desde el archivo separado
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
    );
  }
}
