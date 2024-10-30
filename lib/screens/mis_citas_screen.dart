import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
import 'package:paraflorseer/themes/app_colors.dart';

class MisCitasScreen extends StatefulWidget {
  const MisCitasScreen({super.key});

  @override
  _MisCitasScreenState createState() => _MisCitasScreenState();
}

class _MisCitasScreenState extends State<MisCitasScreen> {
  String nombreUsuario = "Usuario"; // Reemplaza con el nombre real del usuario

  // Lista de citas
  List<Map<String, String>> citas = [];

  // Función para agregar una nueva cita
  void agregarCita(String terapeuta, String fecha, String hora) {
    setState(() {
      citas.add({
        'terapeuta': terapeuta,
        'fecha': fecha,
        'hora': hora,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Centrar el nombre del usuario en la parte superior
            Center(
              child: Text(
                'Tus citas agendadas, $nombreUsuario',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            // Mostrar el calendario y mensaje si no hay citas
            if (citas.isEmpty) ...[
              // Imagen del calendario centrada
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/calendario.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Texto centrado "No tienes citas agendadas"
              const Center(
                child: Text(
                  "Usted no tiene citas agendadas",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else ...[
              // Mostrar la lista de citas agendadas
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: citas.length > 3
                      ? 3
                      : citas.length, // Limita a 3 citas si hay más de 3
                  itemBuilder: (context, index) {
                    final cita = citas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Terapeuta: ${cita['terapeuta']}'),
                        subtitle: Text(
                          'Fecha: ${cita['fecha']}\nHora: ${cita['hora']}',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Botón para agregar una nueva cita (para prueba)
            ElevatedButton(
              onPressed: () {
                // Aquí puedes probar añadiendo una nueva cita
                agregarCita("Dr. Juan Pérez", "2024-10-10", "14:00");
              },
              child: const Text('Agregar cita'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
