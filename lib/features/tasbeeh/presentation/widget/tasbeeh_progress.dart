import 'package:etmaan/features/tasbeeh/logic/cubit/tasbeeh_cubit.dart';
import 'package:etmaan/features/tasbeeh/logic/cubit/tasbeeh_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasbeehProgress extends StatelessWidget {
  const TasbeehProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbeehCubit, TasbeehState>(
      builder: (context, state) {
        if (state is! TasbeehUpdated) {
          return const SizedBox();
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: RichText(
            key: ValueKey(
              '${state.count}-${state.percentage}',
            ),
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${state.count} / ${state.target} · ',
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: '${state.percentage}%',
                  style: TextStyle(
                    color: state.currentTasbeeh.color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}