import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildProfileOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.primary.withOpacity(0.1),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/user_placeholder.png'),
          ),
          const SizedBox(height: 15),
          const Text(
            'Juan Pérez',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            'Estudiante - UPC',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    '4.8',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Calificación',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                children: [
                  const Text(
                    '12',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Viajes',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                children: [
                  const Text(
                    '100%',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Puntualidad',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildProfileOption(
            icon: Icons.person,
            title: 'Editar perfil',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.credit_card,
            title: 'Métodos de pago',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.history,
            title: 'Historial de viajes',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.star,
            title: 'Calificaciones',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.notifications,
            title: 'Notificaciones',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.security,
            title: 'Seguridad',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.help,
            title: 'Ayuda',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            color: Colors.red,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(title, style: TextStyle(color: color ?? Colors.black)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}