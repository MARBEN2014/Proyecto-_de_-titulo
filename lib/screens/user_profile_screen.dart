import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/usuario.png'),
                  backgroundColor: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 20),

              // Campos de información de usuario como TextFields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    _buildEditableTextField(
                        context, 'Nombre Completo', nameController,
                        isName: true),
                    _buildDateField(context),
                    _buildGenderDropdown(),
                    _buildPhoneField(),
                    _buildEditableTextField(
                        context, 'Dirección', addressController),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botón de guardar datos
              Center(
                child: ElevatedButton(
                  onPressed: () => _saveUserData(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    'Guardar Datos',
                    style: TextStyle(fontSize: 16, color: AppColors.secondary),
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  // Widget para mostrar un campo editable como TextField
  Widget _buildEditableTextField(
      BuildContext context, String label, TextEditingController controller,
      {bool isName = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        textCapitalization:
            isName ? TextCapitalization.words : TextCapitalization.none,
        onChanged: (value) {
          if (isName) {
            controller.text = value.toUpperCase();
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          }
        },
      ),
    );
  }

  // Widget para la fecha de nacimiento
  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: birthdateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Fecha de Nacimiento',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            birthdateController.text =
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
          }
        },
      ),
    );
  }

  // Widget para el menú desplegable de género
  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: ['Masculino', 'Femenino']
            .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
        },
        decoration: InputDecoration(
          labelText: 'Sexo',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  // Campo de teléfono con código fijo 569
  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixText: '+569 ',
          labelText: 'Teléfono Celular',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        maxLength: 8,
      ),
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
        trailing: const Icon(Icons.arrow_forward, color: AppColors.primary),
        onTap: () {
          // Navegar a la pantalla de detalles de la cita
        },
      ),
    );
  }

  // Función para guardar datos del usuario
  void _saveUserData(BuildContext context) {
    if (nameController.text.isEmpty ||
        birthdateController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedGender == null) {
      _showErrorDialog(context);
    } else {
      _showConfirmationDialog(context);
    }
  }

  // Diálogo de confirmación de datos guardados
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          content: Container(
            width: 60, // Ancho deseado
            height: 60, // Alto deseado
            padding:
                const EdgeInsets.only(top: 20), // Espacio en la parte superior
            child: const Center(
              child: Text(
                'Datos guardados correctamente.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  // Diálogo de error si falta un campo por completar
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 230, 158, 125),
          content: Container(
            width: 60, // Ancho deseado
            height: 60, // Alto deseado

            padding: const EdgeInsets.only(
                top: 20), // Espacio adicional en la parte superior
            alignment: Alignment.center, // Alineación centrada
            child: const Text(
              'Por favor, complete todos los campos.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center, // Texto centrado
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
      },
    );
  }
}
