import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gouni_flutter/presentation/register_page.dart';
import 'package:gouni_flutter/presentation/state/ui_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  final VoidCallback onNavigateBack;
  final void Function(String email) onNavigateToResetPassword;

  const ForgotPasswordPage({
    super.key,
    required this.onNavigateBack,
    required this.onNavigateToResetPassword,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailCtrl = TextEditingController();
  UiState<void> forgotPasswordState = UiState.idle();

  @override
  void initState() {
    super.initState();

    // Esto permite que el botón se actualice cuando el usuario escribe
    emailCtrl.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> forgotPassword(String email) async {
    setState(() => forgotPasswordState = UiState.loading());

    await Future.delayed(const Duration(seconds: 2));

    final emailExists = email == "user@example.com"; // Simulación

    if (emailExists) {
      setState(() => forgotPasswordState = UiState.success(null));
      widget.onNavigateToResetPassword(email);
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => forgotPasswordState = UiState.idle());
      });
    } else {
      setState(() => forgotPasswordState = UiState.error("El email no está registrado"));
    }
  }

  bool isValidEmail(String email) {
      final regex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
      );
      return regex.hasMatch(email.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = forgotPasswordState.status == UiState.loading;
    final hasError = forgotPasswordState.status == UiState.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Contraseña"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onNavigateBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Image.asset("assets/images/gounislogan.png", height: 100),
            const SizedBox(height: 32),
            const Text(
              "¿Olvidaste tu contraseña?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Ingresa tu correo electrónico para verificar si tienes una cuenta registrada.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Correo Electrónico",
                border: OutlineInputBorder(),
                hintText: "example@example.com",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            if (hasError)
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  forgotPasswordState.error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (hasError) const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading || !isValidEmail(emailCtrl.text)
                  ? null
                  : () => forgotPassword(emailCtrl.text),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Verificar Email"),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: widget.onNavigateBack,
              child: const Text("Volver al Inicio de Sesión"),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}