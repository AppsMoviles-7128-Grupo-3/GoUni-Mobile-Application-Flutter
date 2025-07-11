
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gouni_flutter/data/remote/api/user_api.dart';
import 'package:gouni_flutter/data/repository/auth_repository_impl.dart';
import 'package:gouni_flutter/domain/repository/auth_repository.dart';
import 'package:gouni_flutter/domain/usecase/auth/email_exists_use_case.dart';
import 'package:gouni_flutter/presentation/state/ui_state.dart';
import 'package:provider/provider.dart';

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
  final _emailController = TextEditingController();
  UiState<void> _forgotPasswordState = UiState.idle();

  final Dio dio = Dio(BaseOptions(baseUrl: 'https://adaptable-clarity-production.up.railway.app/api/'));
  late final UserApi _userApi = UserApi(dio);
  late final AuthRepository _authRepository;
  late final EmailExistsUseCase _emailExistsUseCase;

  @override
  void initState() {
  super.initState();
  _authRepository = AuthRepositoryImpl(_userApi);
  _emailExistsUseCase = EmailExistsUseCase(_authRepository);

  _emailController.addListener(() {
    setState(() {});
  });
}

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _verifyEmail() async {
  final email = _emailController.text.trim();

  if (!isValidEmail(email)) return;

  setState(() => _forgotPasswordState = UiState.loading());

  try {
    final response = await _userApi.forgotPassword(email);

    if (response.statusCode == 200) {
      setState(() => _forgotPasswordState = UiState.success(null));
      widget.onNavigateToResetPassword(email);
    } else {
      setState(() => _forgotPasswordState = UiState.error("Correo no registrado."));
    }
  } on DioException catch (e) {
    String errorMessage = "Error desconocido";

    if (e.response?.statusCode == 404) {
      errorMessage = "El correo no está registrado.";
    } else if (e.response?.data is Map && e.response?.data['message'] != null) {
      errorMessage = e.response?.data['message'];
    }

    setState(() => _forgotPasswordState = UiState.error(errorMessage));
  } catch (e) {
    setState(() => _forgotPasswordState = UiState.error("Error inesperado: $e"));
  }
}

  @override
  Widget build(BuildContext context) {
    final state = _forgotPasswordState;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Recuperar Contraseña',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          onPressed: widget.onNavigateBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 24, bottom: 100),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset('assets/images/gounislogan.png', width: 100, height: 100),
            const SizedBox(height: 32),
            Text(
              '¿Olvidaste tu contraseña?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Ingresa tu correo electrónico para verificar si tienes una cuenta registrada.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                hintText: 'example@example.com',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 32),

            if (state is UiStateError)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    state.message,
                    style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            if (state is UiStateLoading)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      const SizedBox(width: 12),
                      Text(
                        'Verificando email...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: (state is! UiStateLoading && isValidEmail(_emailController.text))
                    ? _verifyEmail
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: (state is UiStateLoading)
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'Verificar Email',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: widget.onNavigateBack,
              child: const Text('Volver al Inicio de Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}