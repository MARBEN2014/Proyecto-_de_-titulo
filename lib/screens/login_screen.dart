import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/themes/app_text_styles.dart';
//import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
import 'package:paraflorseer/widgets/custom_appbar_logged_out.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Color _emailBorderColor = AppColors.primary;
  Color _passwordBorderColor = AppColors.primary;
  Color _labelColorEmail = AppColors.text;
  Color _labelColorPassword = AppColors.text;

  bool _isPasswordVisible = false;

  void _login() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      // Correo y contraseña de prueba
      String validEmail = 'usuario@prueba.com';
      String validPassword = 'Prueba123';

      setState(() {
        _labelColorEmail = AppColors.primary;
        _labelColorPassword = AppColors.primary;
      });

      // Verificar si el correo y la contraseña son correctos
      if (email == validEmail && password == validPassword) {
        // Navega a la pantalla de perfil de usuario
        Navigator.pushNamed(context, '/user');
      } else {
        setState(() {
          _emailBorderColor = Colors.red;
          _passwordBorderColor = Colors.red;
        });

        // Mostrar mensaje de error si las credenciales son incorrectas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales incorrectas. Inténtalo de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        _emailBorderColor = Colors.red;
        _passwordBorderColor = Colors.red;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, verifica tus credenciales.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _emailBorderColor = AppColors.primary;
      _passwordBorderColor = AppColors.primary;
      _labelColorEmail = AppColors.text;
      _labelColorPassword = AppColors.text;
      _formKey.currentState?.reset(); // Limpiar el estado del formulario
    });
  }

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarLoggedOut(),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Campo de correo electrónico
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Correo Electrónico',
                                  labelStyle:
                                      AppTextStyles.bodyTextStyle.copyWith(
                                    color: _labelColorEmail,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: _emailBorderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: _emailBorderColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    _emailBorderColor = Colors.red;
                                    return 'Por favor, ingresa tu correo electrónico';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    _emailBorderColor = Colors.red;
                                    return 'Por favor, ingresa un correo válido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // Campo de contraseña
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  labelStyle:
                                      AppTextStyles.bodyTextStyle.copyWith(
                                    color: _labelColorPassword,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: _passwordBorderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: _passwordBorderColor,
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.text,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    _passwordBorderColor = Colors.red;
                                    return 'Por favor, ingresa tu contraseña';
                                  }
                                  if (value.length < 6) {
                                    _passwordBorderColor = Colors.red;
                                    return 'La contraseña debe tener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Texto "O inicia sesión con:"
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'O inicia sesión con:',
                                style: AppTextStyles.bodyTextStyle.copyWith(
                                  fontSize: 15,
                                  color: AppColors.text,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Botones de redes sociales
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navega a la lógica de autenticación de Facebook
                                    Navigator.pushNamed(
                                        context, '/loginFacebook');
                                  },
                                  child: Image.asset(
                                    'assets/facebook.png',
                                    height: 60,
                                    width: 70,
                                  ),
                                ),
                                const SizedBox(
                                    width: 30), // Espaciado entre logos
                                GestureDetector(
                                  onTap: () {
                                    // Navega a la lógica de autenticación de Google
                                    Navigator.pushNamed(
                                        context, '/loginGoogle');
                                  },
                                  child: Image.asset(
                                    'assets/google.png',
                                    height: 60,
                                    width: 70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Iniciar Sesión',
                              style: AppTextStyles.bodyTextStyle.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/recovery_screen');
                          },
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Si no eres usuario, ',
                              style: AppTextStyles.bodyTextStyle.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Text(
                                  '  regístrate',
                                  style: AppTextStyles.bodyTextStyle.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
