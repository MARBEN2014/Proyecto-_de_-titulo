import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/screens/welcome_screen.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/themes/app_text_styles.dart';
import 'package:paraflorseer/utils/obtenerUserandNAme.dart';
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

  // Función para guardar la reserva en la subcolección 'reservas' del usuario en Firestore
  Future<void> _saveBookingToUserSubcollection() async {
    try {
      // Obtiene el usuario autenticado
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Si no hay un usuario autenticado, lanza una excepción
        throw Exception("Usuario no autenticado");
      }

      // Crea la referencia a la subcolección 'reservas' dentro del documento del usuario
      final userReservationsRef = FirebaseFirestore.instance
          .collection(
              'user') // Asume que los documentos de usuarios están en la colección 'usuarios'
          .doc(user.uid) // Documento del usuario actual
          .collection('Reservas'); // Subcolección 'reservas' del usuario

      // Agrega el documento de la reserva en la subcolección 'reservas' del usuario
      await userReservationsRef.add({
        'service_name': widget.serviceName,
        'therapist': selectedTherapist,
        'time': selectedTime,
        'day': selectedDay,
        'user_name': userName,
        'created_at': FieldValue.serverTimestamp(), // Fecha y hora de creación
      });

      // Muestra el cuadro de confirmación de cita
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
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: selectedTherapist != null &&
                          selectedTime != null &&
                          selectedDay != null
                      ? _saveBookingToUserSubcollection // Llama a la función para guardar la reserva
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Confirmar Cita'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
