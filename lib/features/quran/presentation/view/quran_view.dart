import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 20.h),
          children: [
            QuranSearchBar(
              controller: searchController,
              onChanged: _filterSurahs,
            ),

            SizedBox(height: 14.h),

            LastReadCard(
              surahName: 'سورة الكهف',
              currentPage: 287,
              totalPages: 604,
              progress: .48,
              onContinue: _openQuran,
            ),

            SizedBox(height: 14.h),

            DailyGoalCard(completedPages: 8, targetPages: 10),

            SizedBox(height: 16.h),

            const SurahSectionTitle(),

            SizedBox(height: 8.h),

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
                      color: const Color(0xff667085),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
