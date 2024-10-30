import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart'; // Asegúrate de importar tus temas
import 'package:paraflorseer/widgets/custom_app_bar.dart'; // Import del AppBar personalizado
import 'package:paraflorseer/widgets/bottom_nav_bar.dart'; // Import del Bottom Navigation Bar

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isEditing = false; // Variable para determinar si está en modo edición

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(), // Uso del AppBar personalizado
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Espaciado general
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Título de la pantalla
              const Center(
                child: Text(
                  'Perfil de Usuario',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Imagen del perfil
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                      'assets/usuario.png'), // Ruta de la imagen del perfil
                  backgroundColor: AppColors.secondary, // Color de fondo
                ),
              ),
              const SizedBox(height: 20),

              // Información del usuario editable
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        20.0), // Ajusta el padding a izquierda y derecha
                child: Column(
                  children: [
                    _buildEditableUserInfoRow(
                        context, 'Nombre Completo', 'Diego Vásquez'),
                    _buildEditableUserInfoRow(
                        context, 'Fecha de Nacimiento', '21/01/1984'),
                    _buildEditableUserInfoRow(context, 'Sexo', 'Masculino'),
                    _buildEditableUserInfoRow(
                        context, 'Teléfono Celular', '+569 1234 5678'),
                    _buildEditableUserInfoRow(
                        context, 'Correo', 'diegovasquez21.@gmail.com'),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Botón de edición general
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (isEditing) {
                        // Guardar datos y mostrar banner
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Datos guardados correctamente.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                      isEditing =
                          !isEditing; // Cambiar entre modo edición y guardado
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Color del botón
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    isEditing ? 'Guardar Datos' : 'Editar Perfil',
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.secondary),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Historial de citas centrado
              const Center(
                child: Text(
                  'Historial de Citas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Listado de citas
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        20.0), // Ajusta el padding para los elementos de historial
                child: Column(
                  children: [
                    _buildAppointmentTile('Reiki', '10 de octubre, 10:00 AM'),
                    _buildAppointmentTile(
                        'Masaje Craneal', '15 de octubre, 11:00 AM'),
                    _buildAppointmentTile('Yoga', '20 de octubre, 9:00 AM'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const BottomNavBar(), // Uso del Bottom Navigation Bar
    );
  }

  // Widget para mostrar información del usuario con opción de edición
  Widget _buildEditableUserInfoRow(
      BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 8),
              // Mostrar el ícono de edición solo cuando esté en modo edición
              if (isEditing)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    _showEditDialog(context, label, value);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Mostrar un diálogo de edición para cada campo
  void _showEditDialog(
      BuildContext context, String label, String currentValue) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Ingrese su $label'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Guardar los cambios (lógica a implementar)
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Widget para mostrar una cita en el historial
  Widget _buildAppointmentTile(String therapy, String dateTime) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title:
            Text(therapy, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dateTime),
        trailing: const Icon(Icons.arrow_forward,
            color: AppColors.primary), // Icono para indicar acción
        onTap: () {
          // Navegar a la pantalla de detalles de la cita
        },
      ),
    );
  }
}
