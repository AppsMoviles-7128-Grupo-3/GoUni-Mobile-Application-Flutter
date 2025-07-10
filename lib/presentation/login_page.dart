import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gouni_flutter/data/remote/api/user_api.dart';
import 'package:gouni_flutter/data/repository/auth_repository_impl.dart';
import 'package:gouni_flutter/domain/model/user.dart';
import 'package:gouni_flutter/domain/repository/auth_repository.dart';
import 'package:gouni_flutter/presentation/state/ui_state.dart';

class LoginPage extends StatefulWidget {
  final void Function(String userId) onSignInSuccess;
  final VoidCallback onNavigateToSignUp;
  final VoidCallback onNavigateToForgotPassword;

  const LoginPage({
    Key? key,
    required this.onSignInSuccess,
    required this.onNavigateToSignUp,
    required this.onNavigateToForgotPassword,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'test@example.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _passwordVisible = false;
  UiState<User>? _authState;
  User? _currentUser;

  final Dio dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));  // http://192.168.18.X:8080/api/
  late final UserApi _userApi = UserApi(dio);
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(_userApi);
    _authState = null;
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print("Email: $email");
    print("Password: $password");

    if (email.isEmpty || password.isEmpty) {
      setState(() => _authState = UiState.error("Por favor completa todos los campos"));
      return;
    }

    setState(() => _authState = UiState.loading());

    print("Llamando login en AuthRepository...");

    final result = await _authRepository.login(email, password);


    print("Resultado del login: ${result.isSuccess}   ${result.data} ${result.error}");

    if (result.isSuccess) {
      setState(() {
        _authState = UiState.success(result.data!);
        _currentUser = result.data;
      });

      widget.onSignInSuccess(result.data!.id);
    } else {
      setState(() => _authState = UiState.error(result.error ?? "Error en el inicio de sesión"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _authState is UiStateLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Image.asset('assets/images/gounislogan.png', height: 200),
                const Text('GoUni', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300)),
                const SizedBox(height: 32),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: widget.onNavigateToForgotPassword,
                    child: const Text("¿Olvidaste tu contraseña?"),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : const Text("Iniciar Sesión"),
                  ),
                ),

                const SizedBox(height: 8),
                TextButton(
                  onPressed: widget.onNavigateToSignUp,
                  child: const Text("¿No tienes cuenta? Regístrate"),
                ),

                if (_authState is UiStateError) ...[
                  const SizedBox(height: 24),
                  Text(
                    (_authState as UiStateError).message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                ],

                const SizedBox(height: 24),
                const Text('test@example.com • 123456', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}