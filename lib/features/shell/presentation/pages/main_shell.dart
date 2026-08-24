import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../tarjeta/domain/entities/convenio_entity.dart';
import '../../../tarjeta/presentation/bloc/convenios/convenios_bloc.dart';
import '../../../tarjeta/presentation/bloc/security_code/security_code_bloc.dart';
import '../../../tarjeta/presentation/pages/convenios_page.dart';
import '../../../tarjeta/presentation/pages/security_code_page.dart';

const _tabTitles = [
  'Tarjeta Empresarial',
  'Selecciona tu convenio',
  'Código de seguridad',
];

/// Shell autenticado: una sola pantalla con navegación inferior (Inicio,
/// Convenios, Código) en vez de pantallas apiladas con `Navigator.push`.
/// [ConveniosBloc] y [SecurityCodeBloc] viven aquí y se comparten entre las
/// 3 pestañas — así "generar código" es solo cambiar de pestaña, no navegar.
class MainShell extends StatefulWidget {
  final UserEntity user;

  const MainShell({super.key, required this.user});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  late final ConveniosBloc _conveniosBloc;
  late final SecurityCodeBloc _securityCodeBloc;

  @override
  void initState() {
    super.initState();
    _conveniosBloc = sl<ConveniosBloc>()..add(const ConveniosLoadRequested());
    _securityCodeBloc = sl<SecurityCodeBloc>();
  }

  @override
  void dispose() {
    _conveniosBloc.close();
    _securityCodeBloc.close();
    super.dispose();
  }

  void _goToTab(int index) => setState(() => _index = index);

  void _onGenerateRequested(ConvenioEntity convenio) {
    _securityCodeBloc.add(SecurityCodeGenerateRequested(convenio.id));
    _goToTab(2);
  }

  void _onDestinationSelected(int index) {
    // No se puede saltar directo a "Código" sin haber elegido convenio y
    // generado uno primero: en vez de dejar la pestaña vacía, se explica el
    // porqué con los pasos a seguir.
    if (index == 2 && _securityCodeBloc.state is SecurityCodeInitial) {
      _showStepsRequiredDialog();
      return;
    }
    _goToTab(index);
  }

  Future<void> _showStepsRequiredDialog() {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Antes de generar tu código',
          style: AppTextStyles.headline.copyWith(fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _StepRow(
              number: 1,
              text: 'Elige un convenio activo en la pestaña Convenios.',
            ),
            SizedBox(height: 12),
            _StepRow(
              number: 2,
              text: 'Toca "Generar código" para crear tu código de seguridad.',
            ),
            SizedBox(height: 12),
            _StepRow(
              number: 3,
              text:
                  'Muéstralo al dependiente al pagar. Es válido 5 minutos y de un solo uso.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Entendido'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _goToTab(1);
            },
            child: const Text('Elegir convenio'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _conveniosBloc),
        BlocProvider.value(value: _securityCodeBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_tabTitles[_index]),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: () =>
                  context.read<AuthBloc>().add(const AuthLogoutRequested()),
            ),
          ],
        ),
        body: IndexedStack(
          index: _index,
          children: [
            HomePage(user: widget.user, onGenerateCodeTap: () => _goToTab(1)),
            ConveniosPage(onGenerate: _onGenerateRequested),
            const SecurityCodePage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.credit_card_outlined),
              selectedIcon: Icon(Icons.credit_card),
              label: 'Convenios',
            ),
            NavigationDestination(
              icon: Icon(Icons.confirmation_number_outlined),
              selectedIcon: Icon(Icons.confirmation_number),
              label: 'Código',
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;

  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.brandRed,
          child: Text(
            '$number',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.body)),
      ],
    );
  }
}
