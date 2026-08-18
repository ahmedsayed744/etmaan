import 'package:etmaan/features/prayer/data/datasource/location_datasource.dart';
import 'package:etmaan/features/prayer/data/datasource/prayer_datasource.dart';
import 'package:etmaan/features/prayer/data/repo/prayer_repo_imp.dart';
import 'package:etmaan/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:etmaan/features/prayer/presentation/cubit/prayer_state.dart';
import 'package:etmaan/features/prayer/presentation/widget/location_card.dart';
import 'package:etmaan/features/prayer/presentation/widget/next_prayer_card.dart';
import 'package:etmaan/features/prayer/presentation/widget/prayer_header.dart';
import 'package:etmaan/features/prayer/presentation/widget/prayer_times_card.dart';
import 'package:etmaan/features/prayer/presentation/widget/qibla_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerView extends StatelessWidget {
  const PrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrayerCubit(
        PrayerRepoImp(
          locationDataSource:
              LocationDataSource(),
          prayerDataSource:
              PrayerDataSource(),
        ),
      )..initialize(),
      child: const _PrayerBody(),
    );
  }
}

class _PrayerBody extends StatelessWidget {
  const _PrayerBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context)
          .scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<PrayerCubit, PrayerState>(
          builder: (context, state) {
            if (state.status ==
                PrayerStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status ==
                PrayerStatus.error) {
              return _ErrorView(
                message:
                    state.errorMessage ??
                        'حدث خطأ أثناء تحميل البيانات',
                onRetry: () {
                  context
                      .read<PrayerCubit>()
                      .initialize();
                },
              );
            }

            final cubit =
                context.read<PrayerCubit>();

            return RefreshIndicator(
              onRefresh: cubit.initialize,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  10.w,
                  8.h,
                  10.w,
                  24.h,
                ),
                children: [
                  const PrayerHeader(
                    title: 'الصلاة',
                  ),

                  SizedBox(height: 4.h),

                  NextPrayerCard(
                    prayerName:
                        state.nextPrayer?.name ??
                            '--',
                    prayerTime:
                        _formatTime(
                      state.nextPrayer?.time,
                    ),
                    remaining:
                        cubit.formattedRemaining,
                    progress:
                        _calculateProgress(
                      state,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  if (state.location != null)
                    LocationCard(
                      location:
                          state.location!
                              .displayName,
                    ),

                  SizedBox(height: 8.h),

                  PrayerTimesCard(
                    prayerTimes:
                        state.prayerTimes,
                    nextPrayerType:
                        state.nextPrayer?.type,
                  ),

                  SizedBox(height: 8.h),

                  if (state.qibla != null)
                    QiblaCard(
                      qiblaDirection:
                          state.qibla!.direction,
                      compassHeading:
                          state.compassHeading,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static String _formatTime(
    DateTime? time,
  ) {
    if (time == null) {
      return '--';
    }

    final hour = time.hour;
    final minute =
        time.minute.toString().padLeft(2, '0');

    final displayHour =
        hour % 12 == 0 ? 12 : hour % 12;

    final period =
        hour >= 12 ? 'م' : 'ص';

    return '$displayHour:$minute $period';
  }

  static double _calculateProgress(
    PrayerState state,
  ) {
    final next = state.nextPrayer;

    if (next == null) {
      return 0;
    }

    final prayers = state.prayerTimes;

    if (prayers.isEmpty) {
      return 0;
    }

    final now = DateTime.now();

    final nextIndex = prayers.indexWhere(
      (item) => item.type == next.type,
    );

    if (nextIndex <= 0) {
      return 0;
    }

    final previous =
        prayers[nextIndex - 1].time;

    final totalSeconds =
        next.time
            .difference(previous)
            .inSeconds;

    final elapsedSeconds =
        now
            .difference(previous)
            .inSeconds;

    if (totalSeconds <= 0) {
      return 0;
    }

    return (elapsedSeconds / totalSeconds)
        .clamp(0.0, 1.0);
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 42.sp,
              color:
                  const Color(0xff2E9568),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: theme
                    .colorScheme
                    .onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text(
                'حاول مرة أخرى',
              ),
            ),
          ],
        ),
      ),
    );
  }
}