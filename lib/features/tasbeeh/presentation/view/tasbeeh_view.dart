import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/tasbeeh/presentation/widget/tasbeeh_actions.dart';
import 'package:etmaan/features/tasbeeh/presentation/widget/tasbeeh_counter.dart';
import 'package:etmaan/features/tasbeeh/presentation/widget/tasbeeh_list.dart';
import 'package:etmaan/features/tasbeeh/presentation/widget/tasbeeh_progress.dart';
import 'package:etmaan/features/tasbeeh/presentation/widget/tasbeeh_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../logic/cubit/tasbeeh_cubit.dart';

import 'package:etmaan/features/tasbeeh/data/datasource/tasbeeh_statistics_datasource.dart';
import 'package:etmaan/features/tasbeeh/data/repo/tasbeeh_statistics_repo_imp.dart';
import 'package:etmaan/features/tasbeeh/logic/cubit/tasbeeh_statistics_cubit.dart';

class TasbeehView extends StatelessWidget {
  const TasbeehView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TasbeehCubit()),
        BlocProvider(
          create: (_) => TasbeehStatisticsCubit(
            TasbeehStatisticsRepoImp(TasbeehStatisticsDatasource()),
          )..initializeStatistics(),
        ),
      ],
      child: const _TasbeehView(),
    );
  }
}

class _TasbeehView extends StatelessWidget {
  const _TasbeehView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'السبحة الالكترونية',
          style: AppStrings.font18Regular.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // ======================
              // Tasbeeh List
              // ======================
              const TasbeehList(),
              Gap(40.h),
              // ======================
              // Title
              // ======================
              const TasbeehTitle(),
              Gap(25.h),
              // ======================
              // Counter
              // ======================
              const TasbeehCounter(),
              Gap(25.h),
              // ======================
              // Progress
              // ======================
              const TasbeehProgress(),
              Gap(20.h),
              // ======================
              // Actions
              // ======================
              const TasbeehActions(),
              Gap(30.h),
            ],
          ),
        ),
      ),
    );
  }
}
