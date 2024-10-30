import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Asegúrate de importar intl para NumberFormat

import 'package:paraflorseer/modals/map_wellnees.dart';
import 'package:paraflorseer/ruta_welcome_screen/booking_screen.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/themes/app_text_styles.dart';
import 'package:paraflorseer/descripcions_servicios/descriptions_wellness.dart';
import 'package:paraflorseer/image_services/image_wellness.dart';

class CustomBodyWellness extends StatelessWidget {
  const CustomBodyWellness({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Servicios de',
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    '  Bienestar',
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.6,
              ),
              itemCount: descriptionsWellness
                  .length, // Cambiado a descriptionsWellness
              itemBuilder: (context, index) {
                return Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 140,
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: imageWellness[index].startsWith(
                                  'http') // Cambiado a imageWellness
                              ? Image.network(
                                  imageWellness[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Image.asset(
                                  imageWellness[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          descriptionsWellness[
                              index], // Cambiado a descriptionsWellness
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyTextStyle
                              .copyWith(fontSize: 14.3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          '\$${_formatPrice(servicesData[descriptionsWellness[index]]?['price'])}',
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final String serviceName =
                              descriptionsWellness[index];
                          final serviceData = servicesData[serviceName];

                          if (serviceData != null) {
                            List<String> therapists = serviceData['therapists'];
                            List<String> availableTimes =
                                serviceData['availableTimes'];
                            List<String> availableDays =
                                serviceData['availableDays'];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(
                                  serviceName: serviceName,
                                  therapists: therapists,
                                  availableTimes: availableTimes,
                                  availableDays: availableDays,
                                ),
                              ),
                            );
                          } else {
                            print("Servicio no reconocido");
                          }
                        },
                        child: const Text('Agendar Cita'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          fixedSize: const Size(150, 40),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price is int) {
      return NumberFormat("#,###", "es_CL").format(price);
    } else if (price is double) {
      return NumberFormat("#,###", "es_CL").format(price);
    }
    return "0"; // En caso de que no sea un número válido
  }
}