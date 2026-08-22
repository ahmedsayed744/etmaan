import 'package:etmaan/core/theme/app_colors.dart';
import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/home/data/datasource/home_local_datasource.dart';
import 'package:etmaan/features/home/data/repo/home_repo_imp.dart';
import 'package:etmaan/features/home/logic/cubit/daily_content_cubit.dart';
import 'package:etmaan/features/home/logic/cubit/daily_content_state.dart';
import 'package:etmaan/features/home/presentation/widget/achievements_section.dart';
import 'package:etmaan/features/home/presentation/widget/daily_goal_widget.dart';
import 'package:etmaan/features/home/presentation/widget/hadith_card.dart';
import 'package:etmaan/features/home/presentation/widget/tools_section.dart';
import 'package:etmaan/features/home/presentation/widget/verse_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  final ValueChanged<int>? onSelectTab;

  const HomeView({super.key, this.onSelectTab});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeLocalDataSource dataSource;
  @override
  void initState() {
    super.initState();
    dataSource = HomeLocalDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DailyContentCubit(HomeRepoImp(dataSource))..getDailyContent(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          surfaceTintColor: AppColors.primaryColor,
         automaticallyImplyLeading: false,
          title: Text( 
            "أطمئن",
            style: AppStrings.font22BoldTitle.copyWith(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
            child: BlocBuilder<DailyContentCubit, DailyContentState>(
              builder: (context, state) {
                if (state is DailyContentLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DailyContentError) {
                  return Center(child: Text(state.message));
                }
                if (state is DailyContentLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerseCard(verse: state.verse),
                      Gap(18.h),
                      HadithCard(hadith: state.hadith),
                      Gap(16.h),
                      ToolsSection(onSelectTab: widget.onSelectTab),
                      Gap(16.h),
                      const AchievementsSection(),
                      Gap(24.h),
                      DailyGoalWidget(),
                      Gap(20.h),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
