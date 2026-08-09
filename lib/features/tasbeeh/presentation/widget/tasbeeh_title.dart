import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/tasbeeh_cubit.dart';
import '../../logic/cubit/tasbeeh_state.dart';

class TasbeehTitle extends StatelessWidget {
  const TasbeehTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbeehCubit, TasbeehState>(
      builder: (context, state) {
        if (state is! TasbeehUpdated) {
          return const SizedBox();
        }
        return Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: Text(
                state.currentTasbeeh.arabicName,
                key: ValueKey(
                  state.currentTasbeeh.arabicName,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF182230),
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}