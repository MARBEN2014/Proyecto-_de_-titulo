import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
import 'package:paraflorseer/themes/app_colors.dart';

class MiFichaScreen extends StatefulWidget {
  const MiFichaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MiFichaScreenState createState() => _MiFichaScreenState();
}

class _MiFichaScreenState extends State<MiFichaScreen> {
  String nombreUsuario = "Usuario"; // Nombre del usuario
  String correoUsuario = "usuario@ejemplo.com"; // Correo del usuario
  String telefonoUsuario = "+56912345678"; // Teléfono del usuario

  // Función para actualizar la ficha del usuario
  void actualizarFicha(String nombre, String correo, String telefono) {
    setState(() {
      nombreUsuario = nombre;
      correoUsuario = correo;
      telefonoUsuario = telefono;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Título centrado
            Center(
              child: Text(
                'Ficha Personal de $nombreUsuario',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Mostrar la información de la ficha personal
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text('Correo electrónico'),
                subtitle: Text(correoUsuario),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text('Teléfono'),
                subtitle: Text(telefonoUsuario),
              ),
            ),

            const SizedBox(height: 20),

            // Botón para actualizar la ficha del usuario
            ElevatedButton(
              onPressed: () {
                // Aquí puedes actualizar la ficha con información predeterminada para probar
                actualizarFicha("Ana López", "ana@ejemplo.com", "+56998765432");
              },
              child: const Text('Actualizar Ficha'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
