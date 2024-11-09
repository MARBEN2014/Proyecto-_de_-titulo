//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/screens/welcome_screen.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/themes/app_text_styles.dart';
import 'package:paraflorseer/utils/obtenerUserandNAme.dart';
//import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';

class BookingScreen extends StatefulWidget {
  final String serviceName;
  final List<String> therapists;
  final List<String> availableTimes;
  final List<String> availableDays;

  const BookingScreen({
    super.key,
    required this.serviceName,
    required this.therapists,
    required this.availableTimes,
    required this.availableDays,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedTherapist;
  String? selectedTime;
  String? selectedDay;
  String? userName; // Para almacenar el nombre del usuario

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  // Función para obtener el nombre del usuario
  Future<void> _getUserDetails() async {
    String? fetchedUserName =
        await fetchUserName(); // Llama a la función de nombre
    setState(() {
      userName = fetchedUserName ?? 'Usuario'; // Asigna el nombre o 'Usuario'
    });
  }

  // Función para restablecer las selecciones
  Future<void> _resetSelections() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Simula un pequeño retraso
    setState(() {
      selectedTherapist = null;
      selectedTime = null;
      selectedDay = null;
    });
  }

  // Función para guardar la reserva en Firestore
  Future<void> _saveBookingToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Si no hay un usuario autenticado
        throw Exception("Usuario no autenticado");
      }

      // Crear un documento en la colección 'servicios_bienestar'
      await FirebaseFirestore.instance.collection('servicios_bienestar').add({
        'user_id': user.uid, // ID del usuario que hizo la reserva
        'service_name': widget.serviceName,
        'therapist': selectedTherapist,
        'time': selectedTime,
        'day': selectedDay,
        'user_name': userName,
        'created_at': FieldValue.serverTimestamp(), // Fecha y hora de creación
      });

      // Mostrar el cuadro de confirmación de cita
      _showConfirmationDialog(context);
    } catch (e) {
      // En caso de error, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la cita: $e')),
      );
    }
  }

  // Función para mostrar el cuadro flotante de confirmación
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primary, // Color de fondo del cuadro
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.secondary,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                '¡Cita confirmada!',
                style: AppTextStyles.appBarTextStyle.copyWith(
                  color: AppColors.secondary,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              // Texto que se muestra en el cuadro flotante
              Text(
                'Tu cita con $selectedTherapist el $selectedDay a las $selectedTime ha sido confirmada.',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                  // Navega de nuevo a la pantalla WelcomeScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: _resetSelections, // Restablece las selecciones
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Selecciona el Terapeuta:',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  'Bienvenido, $userName',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    color: AppColors.text,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Muestra la lista de terapeutas
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.therapists.map((therapist) {
                  return ChoiceChip(
                    label: Text(therapist),
                    selected: selectedTherapist == therapist,
                    backgroundColor: AppColors.secondary,
                    selectedColor: AppColors.primary,
                    labelStyle: selectedTherapist == therapist
                        ? AppTextStyles.bodyTextStyle
                            .copyWith(color: AppColors.secondary)
                        : AppTextStyles.bodyTextStyle
                            .copyWith(color: AppColors.primary),
                    onSelected: (isSelected) {
                      setState(() {
                        selectedTherapist = isSelected ? therapist : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Selecciona el Horario:',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              // Muestra la lista de horarios disponibles
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.availableTimes.map((time) {
                  return ChoiceChip(
                    label: Text(time),
                    selected: selectedTime == time,
                    backgroundColor: AppColors.secondary,
                    selectedColor: AppColors.primary,
                    labelStyle: selectedTime == time
                        ? AppTextStyles.bodyTextStyle
                            .copyWith(color: Colors.white)
                        : AppTextStyles.bodyTextStyle
                            .copyWith(color: AppColors.primary),
                    onSelected: (isSelected) {
                      setState(() {
                        selectedTime = isSelected ? time : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Selecciona el Día:',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              // Muestra la lista de días disponibles
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.availableDays.map((day) {
                  return ChoiceChip(
                    label: Text(day),
                    selected: selectedDay == day,
                    backgroundColor: AppColors.secondary,
                    selectedColor: AppColors.primary,
                    labelStyle: selectedDay == day
                        ? AppTextStyles.bodyTextStyle
                            .copyWith(color: Colors.white)
                        : AppTextStyles.bodyTextStyle
                            .copyWith(color: AppColors.primary),
                    onSelected: (isSelected) {
                      setState(() {
                        selectedDay = isSelected ? day : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              // Botón para confirmar la cita
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedTherapist != null &&
                        selectedTime != null &&
                        selectedDay != null) {
                      _saveBookingToFirestore(); // Guarda la cita en Firestore
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Por favor, selecciona todos los campos.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Confirmar Cita',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
