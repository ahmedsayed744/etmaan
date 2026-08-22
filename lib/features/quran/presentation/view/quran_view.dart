import 'package:etmaan/core/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../data/models/surah_data.dart';
import '../../data/models/surah_model.dart';
import '../widget/daily_goal_card.dart';
import '../widget/last_read_card.dart';
import '../widget/quran_search_bar.dart';
import '../widget/surah_card.dart';
import '../widget/surah_section_title.dart';
import 'quran_pdf_view.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  final TextEditingController searchController = TextEditingController();

  late List<SurahModel> filteredSurahs;

  @override
  void initState() {
    super.initState();

    filteredSurahs = List.from(surahs);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterSurahs(String query) {
    final value = query.trim().toLowerCase();

    setState(() {
      if (value.isEmpty) {
        filteredSurahs = List.from(surahs);
        return;
      }

      filteredSurahs = surahs.where((surah) {
        return surah.name.toLowerCase().contains(value) ||
            surah.englishName.toLowerCase().contains(value) ||
            surah.number.toString() == value;
      }).toList();
    });
  }

  void _openQuran() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuranPdfView()),
    );
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
            onChanged: _filterSurahs,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
            
                DailyGoalCard(completedPages: 8, targetPages: 10),
            
                Gap(16.h),
            
                const SurahSectionTitle(),
            
                Gap(8.h),
            
                ...filteredSurahs.map((surah) {
                  return SurahCard(surah: surah, onTap: _openQuran);
                }),
            
                if (filteredSurahs.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Center(
                      child: Text(
                        'لا توجد سورة مطابقة للبحث',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? const Color(0xffAEB8C4) : const Color(0xff667085),
                        ),
                      ),
                    ),
                  ),
                  Gap(15.h)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
