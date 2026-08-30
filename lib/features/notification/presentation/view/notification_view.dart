import 'package:etmaan/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/notification_history_cubit.dart';
import '../../logic/notification_history_state.dart';
import '../widget/notification_app_bar.dart';
import '../widget/notification_card.dart';
import '../widget/notification_empty_state.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationHistoryCubit()..loadHistory(),
      child: Scaffold(
        appBar: const NotificationAppBar(),
        body: SafeArea(
          child: BlocBuilder<NotificationHistoryCubit, NotificationHistoryState>(
            builder: (context, state) {
              if (state.status == NotificationHistoryStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (state.status == NotificationHistoryStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'حدث خطأ ما',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.red,
                    ),
                  ),
                );
              }

              if (state.status == NotificationHistoryStatus.success) {
                if (state.entries.isEmpty) {
                  return const NotificationEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  itemCount: state.entries.length,
                  itemBuilder: (context, index) {
                    final entry = state.entries[index];
                    return NotificationCard(entry: entry);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
