//import 'package:gouni_flutter/features/auth/presentation/screens/login_screen.dart';


import 'package:flutter/material.dart';
import 'package:gouni_flutter/presentation/forgot_password_page.dart';
import 'package:gouni_flutter/presentation/login_page.dart';
import 'package:gouni_flutter/presentation/register_page.dart';
import 'package:gouni_flutter/presentation/reset_password_page.dart';

//import 'data/auth/auth_remote_data_source.dart';
//import 'data/auth/auth_repository_impl.dart';
//import 'domain/auth/auth_repository.dart';
//import 'presentation/auth/auth_controller.dart';
//import 'presentation/auth/login_page.dart'; // tu login

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoUni',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}*/

void main() {
  runApp(const GoUniApp());
}

class GoUniApp extends StatelessWidget {
  const GoUniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoUni',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/signin':
            return MaterialPageRoute(
              builder: (context) => LoginPage(
                onSignInSuccess: (userId) {
                  // Aquí decides qué hacer después del login
                  debugPrint('Usuario autenticado: $userId');
                },
                onNavigateToSignUp: () {
                  Navigator.pushNamed(context, '/signup');
                },
                onNavigateToForgotPassword: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
              ),
            );

          case '/signup':
            return MaterialPageRoute(
              builder: (context) => RegisterPage(
                onSignUpSuccess: (userId) {
                  // Luego del registro, redirige a login o dashboard
                  Navigator.pushNamedAndRemoveUntil(context, '/signin', (r) => false);
                },
                onNavegateToLogin: () {
                  Navigator.popUntil(context, ModalRoute.withName('/signin'));
                },
              ),
            );

          case '/forgot-password':
            return MaterialPageRoute(
              builder: (context) => ForgotPasswordPage(
                onNavigateBack: () {
                  Navigator.pop(context);
                },
                onNavigateToResetPassword: (email) {
                  Navigator.pushNamed(context, '/reset-password', arguments: email);
                },
              ),
            );

          case '/reset-password':
            final email = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ResetPasswordPage(
                email: email,
                onNavigateBack: () => Navigator.pop(context),
                onNavigateToSignIn: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/signin',
                  (route) => false,
                ),
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}