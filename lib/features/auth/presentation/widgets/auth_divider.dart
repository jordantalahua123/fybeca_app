import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class AuthDivider extends StatelessWidget {
  final String label;

  const AuthDivider({super.key, this.label = 'o continúa con'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: AppTextStyles.caption),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
