//import 'package:gouni_flutter/features/auth/presentation/screens/login_screen.dart';


import 'package:flutter/material.dart';
import 'package:gouni_flutter/presentation/forgot_password_page.dart';
import 'package:gouni_flutter/presentation/login_page.dart';
import 'package:gouni_flutter/presentation/register_page.dart';
import 'package:gouni_flutter/features/home/presentation/screens/home_screen.dart';
import 'package:gouni_flutter/features/trips/presentation/screens/search_trips_screen.dart';
import 'package:gouni_flutter/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:gouni_flutter/presentation/reset_password_page.dart';
import 'package:provider/provider.dart';
import 'package:gouni_flutter/domain/provider/user_provider.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const GoUniApp(),
    ),
  );
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
        print("Ruta solicitada: ${settings.name}");
        switch (settings.name) {
          case '/signin':
            return MaterialPageRoute(
              builder: (context) => LoginPage(
                onSignInSuccess: (userId) {
                  Navigator.pushReplacementNamed(context, '/home');
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
                  Navigator.pushNamedAndRemoveUntil(context, '/signin', (r) => false);
                },
                onNavegateToLogin: () {
                  Navigator.popUntil(context, ModalRoute.withName('/signin'));
                },
              ),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
          case '/search-trips':
            return MaterialPageRoute(
              builder: (context) => const SearchTripsScreen(),
            );
          case '/trip-detail':
            final tripData = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => TripDetailScreen(tripData: tripData),
            );
          // Agrega aquí más rutas según tus necesidades

          case '/forgot-password':
            return MaterialPageRoute(
              builder: (context) => ForgotPasswordPage(
                onNavigateBack: () {
                  Navigator.pop(context);
                },
                onNavigateToResetPassword: (email) {
                  print("🚀 Ejecutando callback de navegación a /reset-password con $email");
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    '/reset-password',
                    arguments: email,
                  );
                },
              ),
            );

          case '/reset-password':
            print("Cargando ResetPasswordPage con argumento: ${settings.arguments}");
            final email = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ResetPasswordPage(
                email: email,
                onNavigateBack: () {
                  Navigator.pop(context);
                },
                onNavigateToSignIn: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/signin', (r) => false);
                },
              ),
            );
          default:
            return null;

          
        }
      },
    );
  }
}