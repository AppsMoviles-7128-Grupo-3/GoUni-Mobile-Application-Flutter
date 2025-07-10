import 'package:flutter/material.dart';
import 'package:gouni_flutter/presentation/register_page.dart';
import 'package:gouni_flutter/presentation/state/ui_state.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final VoidCallback onNavigateBack;
  final VoidCallback onNavigateToSignIn;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.onNavigateBack,
    required this.onNavigateToSignIn,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  bool showNewPassword = false;
  bool showConfirmPassword = false;
  bool showSuccessDialog = false;

  UiState<void> resetPasswordState = UiState.idle();

  @override
  void dispose() {
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> resetPassword(String email, String newPassword) async {
    setState(() => resetPasswordState = UiState.loading());
    await Future.delayed(const Duration(seconds: 2));

    if (newPassword.length >= 6) {
      setState(() => resetPasswordState = UiState.success(null));
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => showSuccessDialog = true);
      });
    } else {
      setState(() => resetPasswordState = UiState.error("Contraseña inválida"));
    }
  }

  bool isValidPassword(String pwd, String confirmPwd) {
    return pwd.length >= 6 && pwd == confirmPwd;
  }

  String getPasswordStrength(String password) {
    final hasLetter = password.contains(RegExp(r'[A-Za-z]'));
    final hasDigit = password.contains(RegExp(r'\d'));
    final hasSpecial = password.contains(RegExp(r'[^A-Za-z0-9]'));

    if (password.length < 6) return "Muy Débil";
    if (password.length >= 8 && hasLetter && hasDigit && hasSpecial) return "Fuerte";
    if (password.length >= 6 && hasLetter && hasDigit) return "Media";
    return "Débil";
  }

  @override
  Widget build(BuildContext context) {
    final newPassword = newPasswordCtrl.text;
    final confirmPassword = confirmPasswordCtrl.text;
    final isLoading = resetPasswordState.status == UiState.loading;
    final hasError = resetPasswordState.status == UiState.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Contraseña"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onNavigateBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset("assets/images/gounislogan.png", height: 100),
            const SizedBox(height: 32),
            const Text(
              "Establecer Nueva Contraseña",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Ingresa tu nueva contraseña. Asegúrate de que sea segura y fácil de recordar.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: newPasswordCtrl,
              obscureText: !showNewPassword,
              decoration: InputDecoration(
                labelText: "Nueva Contraseña",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(showNewPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => showNewPassword = !showNewPassword),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordCtrl,
              obscureText: !showConfirmPassword,
              decoration: InputDecoration(
                labelText: "Confirmar Nueva Contraseña",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(showConfirmPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => showConfirmPassword = !showConfirmPassword),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (newPassword.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: {
                    "Débil": Colors.red.shade100,
                    "Media": Colors.amber.shade100,
                    "Fuerte": Colors.green.shade100,
                    "Muy Débil": Colors.grey.shade300,
                  }[getPasswordStrength(newPassword)],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Fortaleza: ${getPasswordStrength(newPassword)}",
                  textAlign: TextAlign.left,
                ),
              ),
            if (newPassword.isNotEmpty &&
                confirmPassword.isNotEmpty &&
                newPassword != confirmPassword)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Las contraseñas no coinciden",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            if (hasError)
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  resetPasswordState.error ?? "Error desconocido",
                  textAlign: TextAlign.center,
                ),
              ),
            if (hasError) const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading || !isValidPassword(newPassword, confirmPassword)
                  ? null
                  : () => resetPassword(widget.email, newPassword),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Cambiar Contraseña"),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: widget.onNavigateBack,
              child: const Text("Cancelar"),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      // Diálogo de éxito
      persistentFooterButtons: showSuccessDialog
          ? [
              AlertDialog(
                title: const Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 48),
                    SizedBox(height: 12),
                    Text("¡Contraseña Cambiada!", textAlign: TextAlign.center),
                  ],
                ),
                content: const Text(
                  "Tu contraseña ha sido cambiada exitosamente. Ahora puedes iniciar sesión.",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() => showSuccessDialog = false);
                      widget.onNavigateToSignIn();
                    },
                    child: const Text("Iniciar Sesión"),
                  )
                ],
              )
            ]
          : null,
    );
  }
}