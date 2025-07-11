import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/constants/app_colors.dart';
import 'package:gouni_flutter/core/widgets/custom_button.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const BookingConfirmationScreen({super.key, required this.tripData});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  int _passengers = 1;
  bool _acceptConditions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar reserva')),
      body: const Center(
        child: Text('Aquí irá la confirmación de la reserva'),
      ),
    );
  }
}