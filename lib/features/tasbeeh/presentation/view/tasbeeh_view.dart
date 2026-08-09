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

class TasbeehView extends StatelessWidget {
  const TasbeehView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasbeehCubit(),
      child: const _TasbeehView(),
    );
  }
}

class _TasbeehView extends StatelessWidget {
  const _TasbeehView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("السبحة الالكترونية ", style: AppStrings.font22BoldTitle),
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
