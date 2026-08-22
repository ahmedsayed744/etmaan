import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/tasbeeh_cubit.dart';

class TasbeehActions extends StatelessWidget {
  const TasbeehActions({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasbeehCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          icon: Icons.bar_chart_rounded,
          label: 'إحصاء',
          onTap: () {
            // Open statistics bottom sheet
          },
        ),

        const SizedBox(width: 20),

        _ActionButton(
          icon: Icons.chevron_right_rounded,
          label: 'التالي',
          onTap: cubit.nextTasbeeh,
        ),

        const SizedBox(width: 20),

        _ActionButton(
          icon: Icons.refresh_rounded,
          label: 'إعادة',
          onTap: cubit.reset,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Material(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          elevation: 2,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 58,
              height: 58,
              child: Icon(
                icon,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}