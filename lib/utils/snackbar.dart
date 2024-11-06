import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      // Usamos un Center para centrar el contenido
      child: Text(
        mensaje,
        textAlign: TextAlign.center, // Asegúrate de que el texto esté centrado
      ),
    ),
    duration: Duration(seconds: 2),
    backgroundColor: Color.fromARGB(255, 26, 221, 101),
  ));
}
