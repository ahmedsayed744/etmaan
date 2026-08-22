import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/tasbeeh/logic/cubit/tasbeeh_cubit.dart';
import 'package:etmaan/features/tasbeeh/logic/cubit/tasbeeh_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TasbeehCounter extends StatefulWidget {
  const TasbeehCounter({super.key});

  @override
  State<TasbeehCounter> createState() => _TasbeehCounterState();
}

class _TasbeehCounterState extends State<TasbeehCounter> {
  bool _pressed = false;
  // ============================================================
  // ON TAP
  // ============================================================
  void _onTap() {
    context.read<TasbeehCubit>().increment();
    setState(() {
      _pressed = true;
    });
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      setState(() {
        _pressed = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbeehCubit, TasbeehState>(
      builder: (context, state) {
        if (state is! TasbeehUpdated) {
          return const SizedBox();
        }
        final Color color = state.currentTasbeeh.color;
        return GestureDetector(
          onTap: _onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.94 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: state.progress),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              builder: (BuildContext context, double progress, Widget? child) {
                // OUTER SIZE
                final double outerSize = 210.r;
                // PROGRESS RING SIZE
                final double ringSize = 200.r;
                // MAIN BUTTON SIZE
                final double buttonSize = _pressed ? 160.r : 168.r;
                return SizedBox.square(
                  dimension: outerSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // OUTER GLOW
                      Container(
                        width: 205.r,
                        height: 205.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.10),
                              blurRadius: 25.r,
                              spreadRadius: 8.r,
                            ),
                          ],
                        ),
                      ),
                      // PROGRESS RING
                      SizedBox.square(
                        dimension: ringSize,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 8.r,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .outlineVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                      // MAIN CIRCULAR BUTTON
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        width: buttonSize,
                        height: buttonSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.20),
                              blurRadius: 18.r,
                              spreadRadius: 2.r,
                              offset: Offset(0, 6.h),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // COUNTER
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                              child: Text(
                                '${state.count}',
                                key: ValueKey(state.count),
                                style: AppStrings.font32Bold.copyWith(
                                  fontSize: 50.sp,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            Gap(5.h),
                            // PRESS TEXT
                            Text(
                              'اضغط',
                              style: AppStrings.font18Regular.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
