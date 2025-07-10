import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gouni_flutter/domain/provider/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: user == null
          ? const Center(child: Text('No se pudo cargar el usuario'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información Personal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _profileRow('Nombre:', user.name),
                          _profileRow('Email:', user.email),
                          _profileRow('Universidad:', user.university),
                          _profileRow('Código de Usuario:', user.userCode),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    label: const Text('Cerrar sesión'),
                    onPressed: () async {
                      // Limpia el usuario del provider
                      Provider.of<UserProvider>(context, listen: false).clearUser();
                      // Opcional: Llama a tu AuthRepository.logout() si necesitas limpiar tokens, etc.
                      // Navega al login y elimina el historial
                      Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _profileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}