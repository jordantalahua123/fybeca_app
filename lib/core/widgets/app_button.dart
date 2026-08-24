import 'package:flutter/material.dart';

/// Botón primario reutilizable con estado de carga incorporado.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: outlined
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimary,
            ),
          )
        : Text(label);

    final effectiveOnPressed = isLoading ? null : onPressed;

    return outlined
        ? OutlinedButton(onPressed: effectiveOnPressed, child: child)
        : ElevatedButton(onPressed: effectiveOnPressed, child: child);
  }
}
