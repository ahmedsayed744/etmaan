import 'package:etmaan/core/theme/app_strings.dart';
import 'package:etmaan/features/quran/data/datasource/quran_local_datasource.dart';
import 'package:etmaan/features/quran/data/models/surah_model.dart';
import 'package:etmaan/features/quran/data/repo/quran_repo_imp.dart';
import 'package:etmaan/features/quran/logic/cubit/quran_cubit.dart';
import 'package:etmaan/features/quran/logic/cubit/quran_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../widget/daily_goal_card.dart';
import '../widget/last_read_card.dart';
import '../widget/quran_search_bar.dart';
import '../widget/surah_card.dart';
import '../widget/surah_section_title.dart';
import 'quran_pdf_view.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuranCubit(
        QuranRepoImp(QuranLocalDataSource()),
      )..loadFirstPage(),
      child: const _QuranViewBody(),
    );
  }
}

class _QuranViewBody extends StatefulWidget {
  const _QuranViewBody();

  @override
  State<_QuranViewBody> createState() => _QuranViewBodyState();
}

class _QuranViewBodyState extends State<_QuranViewBody> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) {
      return;
    }

    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<QuranCubit>().loadMore();
    }
  }

  void _openQuran() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuranPdfView()),
    );
  }

  List<SurahModel> _surahsFrom(QuranState state) {
    return switch (state) {
      QuranLoaded(:final surahs) => surahs,
      QuranLoadingMore(:final surahs) => surahs,
      QuranEndOfData(:final surahs) => surahs,
      QuranError(:final surahs) => surahs,
      _ => const [],
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "القرآن الكريم",
          style: AppStrings.font22BoldTitle.copyWith(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: Column(
        children: [
          QuranSearchBar(
            controller: searchController,
            onChanged: context.read<QuranCubit>().search,
          ),
          Expanded(
            child: BlocBuilder<QuranCubit, QuranState>(
              builder: (context, state) {
                if (state is QuranInitial || state is QuranLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final surahs = _surahsFrom(state);

                if (state is QuranError && surahs.isEmpty) {
                  return _ErrorFooter(
                    message: state.message,
                    onRetry: context.read<QuranCubit>().retry,
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 1 + surahs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          SizedBox(height: 14.h),
                          LastReadCard(
                            surahName: 'سورة الكهف',
                            currentPage: 287,
                            totalPages: 604,
                            progress: .48,
                            onContinue: _openQuran,
                          ),
                          Gap(14.h),
                          DailyGoalCard(
                            completedPages: 8,
                            targetPages: 10,
                          ),
                          Gap(16.h),
                          const SurahSectionTitle(),
                          Gap(8.h),
                        ],
                      );
                    }

                    final surahIndex = index - 1;
                    if (surahIndex < surahs.length) {
                      return SurahCard(
                        surah: surahs[surahIndex],
                        onTap: _openQuran,
                      );
                    }

                    if (state is QuranLoadingMore) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state is QuranError && surahs.isNotEmpty) {
                      return _ErrorFooter(
                        message: state.message,
                        onRetry: context.read<QuranCubit>().retry,
                      );
                    }

                    if (surahs.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(
                          child: Text(
                            'لا توجد سورة مطابقة للبحث',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark
                                  ? const Color(0xffAEB8C4)
                                  : const Color(0xff667085),
                            ),
                          ),
                        ),
                      );
                    }

                    return Gap(15.h);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorFooter extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorFooter({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          Gap(12.h),
          TextButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
