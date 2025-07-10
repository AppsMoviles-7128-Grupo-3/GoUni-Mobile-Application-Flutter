import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gouni_flutter/data/remote/api/user_api.dart';
import 'package:gouni_flutter/data/repository/auth_repository_impl.dart';
import 'package:gouni_flutter/presentation/state/ui_state.dart';

class RegisterPage extends StatefulWidget {
  final void Function(String userId) onSignUpSuccess;
  final VoidCallback onNavegateToLogin;

  const RegisterPage({
    super.key,
    required this.onSignUpSuccess,
    required this.onNavegateToLogin,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final universityCtrl = TextEditingController();
  final userCodeCtrl = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  UiState<String> authState = UiState.idle();

  void register() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();
    final university = universityCtrl.text.trim();
    final userCode = userCodeCtrl.text.trim();

    if ([name, email, password, confirmPassword, university, userCode].any((e) => e.isEmpty)) {
      setState(() => authState = UiState.error("Por favor completa todos los campos"));
      return;
    }

    if (password.length < 6) {
      setState(() => authState = UiState.error("La contraseña debe tener al menos 6 caracteres"));
      return;
    }

    if (password != confirmPassword) {
      setState(() => authState = UiState.error("Las contraseñas no coinciden"));
      return;
    }

    setState(() => authState = UiState.loading());

    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/')); // Usa 10.0.2.2 si estás en Android Emulator
      final userApi = UserApi(dio);
      final authRepository = AuthRepositoryImpl(userApi);

      print("Registrando $email ...");

      final result = await authRepository.register(
        name,
        email,
        password,
        university,
        userCode,
      );

      if (result.isSuccess) {
        final user = result.data!;
        setState(() => authState = UiState.success(user.id));
        widget.onSignUpSuccess(user.id);
      } else {
        setState(() => authState = UiState.error(result.error ?? "Error al registrarse"));
      }
    } catch (e) {
      setState(() => authState = UiState.error("Error inesperado: $e"));
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    universityCtrl.dispose();
    userCodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = authState.status == UiState.loading;
    final hasError = authState.status == UiState.error;
    final errorMessage = authState.error ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Crear Cuenta")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset("assets/images/gounislogan.png", height: 100),
            const SizedBox(height: 16),
            const Text("Únete a la comunidad GoUni", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 24),
            _buildSectionTitle(Icons.person, "Información Personal"),
            _buildTextField("Nombre completo", nameCtrl),
            _buildTextField("Correo electrónico", emailCtrl),

            const SizedBox(height: 24),
            _buildSectionTitle(Icons.school, "Información Académica"),
            _buildTextField("Universidad", universityCtrl),
            _buildTextField("Código de Estudiante", userCodeCtrl),

            const SizedBox(height: 24),
            _buildSectionTitle(Icons.lock, "Seguridad"),
            _buildPasswordField("Contraseña", passwordCtrl, passwordVisible, () {
              setState(() => passwordVisible = !passwordVisible);
            }),
            const SizedBox(height: 16),
            _buildPasswordField("Confirmar Contraseña", confirmPasswordCtrl, confirmPasswordVisible, () {
              setState(() => confirmPasswordVisible = !confirmPasswordVisible);
            }),

            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
              ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : register,
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Crear Cuenta"),
              ),
            ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: widget.onNavegateToLogin,
              child: const Text("¿Ya tienes cuenta? Inicia Sesión"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(icon, size: 18, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool visible, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      ),
    );
  }
}