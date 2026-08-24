import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Home provisional. Aquí se conectará el futuro CRUD como una nueva
/// feature (features/productos/, features/pedidos/, etc.) siguiendo la
/// misma estructura data/domain/presentation que auth.
class HomePage extends StatelessWidget {
  final UserEntity user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fybeca'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primaryNavy,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: AppTextStyles.headline.copyWith(color: AppColors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text('Hola, ${user.name}', style: AppTextStyles.headline, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(user.email, style: AppTextStyles.bodySecondary),
              const SizedBox(height: 8),
              Chip(label: Text(_providerLabel(user.provider))),
            ],
          ),
        ),
      ),
    );
  }

  String _providerLabel(AuthProvider provider) {
    switch (provider) {
      case AuthProvider.email:
        return 'Correo y contraseña';
      case AuthProvider.google:
        return 'Google';
      case AuthProvider.microsoft:
        return 'Microsoft';
    }
  }
}
