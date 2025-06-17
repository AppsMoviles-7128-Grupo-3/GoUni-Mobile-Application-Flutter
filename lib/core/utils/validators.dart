class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Por favor ingresa tu correo';
    if (!value.endsWith('upc.edu.pe')) return 'Debes usar tu correo universitario';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Por favor ingresa tu contraseña';
    if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
    return null;
  }
}