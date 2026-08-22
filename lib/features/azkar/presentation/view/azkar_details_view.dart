import 'package:etmaan/features/azkar/data/datasource/azkar_local_datasource.dart';
import 'package:etmaan/features/azkar/data/repo/azkar_repo_imp.dart';
import 'package:etmaan/features/azkar/presentation/cubit/azkar_cubit.dart';
import 'package:etmaan/features/azkar/presentation/cubit/azkar_state.dart';
import 'package:etmaan/features/azkar/presentation/widget/azkar_app_bar.dart';
import 'package:etmaan/features/azkar/presentation/widget/azkar_card.dart';
import 'package:etmaan/features/azkar/presentation/widget/azkar_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AzkarDetailsView extends StatelessWidget {
  final String title;
  final String jsonPath;

  const AzkarDetailsView({
    super.key,
    required this.title,
    required this.jsonPath,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AzkarCubit(AzkarRepoImp(AzkarLocalDataSource()))..loadAzkar(jsonPath),

      child: _AzkarDetailsBody(title: title),
    );
  }
}

class _AzkarDetailsBody extends StatelessWidget {
  final String title;

  const _AzkarDetailsBody({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AzkarAppBar(title: title),
      body: BlocBuilder<AzkarCubit, AzkarState>(
        builder: (context, state) {
          if (state is AzkarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AzkarError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  'حدث خطأ أثناء تحميل الأذكار',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.red),
                ),
              ),
            );
          }

          if (state is AzkarLoaded) {
            return Column(
              children: [
                AzkarProgress(
                  completed: state.completedCount,
                  total: state.azkar.length,
                ),

                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 24.h),
                    itemCount: state.azkar.length,
                    itemBuilder: (context, index) {
                      final azkar = state.azkar[index];

                      final currentCount = state.counters[azkar.id] ?? 0;

                      return AzkarCard(
                        azkar: azkar,
                        currentCount: currentCount,
                        onTap: () {
                          context.read<AzkarCubit>().increment(azkar.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
