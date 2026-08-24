import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/locator.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/auth_wrapper.dart';

class FybecaApp extends StatelessWidget {
  const FybecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
      child: MaterialApp(
        title: 'Fybeca',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthWrapper(),
      ),
    );
  }
}
