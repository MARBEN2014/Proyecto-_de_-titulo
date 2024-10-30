import 'package:flutter/material.dart';
import 'package:paraflorseer/screens/welcome_screen.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/themes/app_text_styles.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
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
  // ignore: library_private_types_in_public_api
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedTherapist;
  String? selectedTime;
  String? selectedDay;

  // Función para restablecer las selecciones
  Future<void> _resetSelections() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Simular un pequeño retraso
    setState(() {
      selectedTherapist = null;
      selectedTime = null;
      selectedDay = null;
    });
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
              // texto que se uestra en el recuadro flotante
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
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                  // Navegar a la pantalla BeautyScreen
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
        onRefresh: _resetSelections, // Restablecer las selecciones
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

              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.therapists.map((therapist) {
                  return ChoiceChip(
                    label: Text(therapist),
                    selected: selectedTherapist == therapist,
                    // Color del Chip antes de ser seleccionado
                    backgroundColor: AppColors.secondary,
                    // Color del Chip cuando es seleccionado
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
                  'Selecciona el día:',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Text(
              //   'Selecciona un día:',
              //   style: AppTextStyles.bodyTextStyle.copyWith(
              //     fontWeight: FontWeight.bold,
              //   ),

              // ),

              const SizedBox(height: 10),
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
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: selectedTherapist != null &&
                          selectedTime != null &&
                          selectedDay != null
                      ? () {
                          _showConfirmationDialog(
                              context); // Mostrar cuadro flotante
                        }
                      : null, // Deshabilitar si no hay selección
                  child: const Text('Confirmar Cita'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTherapist != null &&
                            selectedTime != null &&
                            selectedDay != null
                        ? AppColors.primary
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 40,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
