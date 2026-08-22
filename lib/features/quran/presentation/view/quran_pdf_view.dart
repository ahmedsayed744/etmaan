import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import 'package:etmaan/features/quran/data/models/surah_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QuranPdfView extends StatefulWidget {
  final int initialPage;

  const QuranPdfView({
    super.key,
    this.initialPage = 1,
  });

  @override
  State<QuranPdfView> createState() => _QuranPdfViewState();
}

class _QuranPdfViewState extends State<QuranPdfView> {
  final PdfViewerController _controller = PdfViewerController();

  late int _page;

  @override
  void initState() {
    super.initState();
    _page = clampQuranPage(widget.initialPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _savePage(int page) async {
    final validPage = clampQuranPage(
      page,
      totalPages: _controller.pageCount > 0
          ? _controller.pageCount
          : quranTotalPages,
    );

    if (validPage == _page) {
      return;
    }

    _page = validPage;
    await CacheHelper().saveData(
      key: CacheKeys.lastQuranPage,
      value: validPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        centerTitle: true,
      ),
      body: SfPdfViewer.asset(
        'assets/data/quran/quran.pdf',
        controller: _controller,
        initialPageNumber: _page,
        canShowPaginationDialog: true,
        canShowScrollHead: true,
        onDocumentLoaded: (details) {
          final totalPages = details.document.pages.count;
          final page = clampQuranPage(_page, totalPages: totalPages);
          if (_controller.pageNumber != page) {
            _controller.jumpToPage(page);
          }
          CacheHelper().saveData(
            key: CacheKeys.lastQuranPage,
            value: page,
          );
        },
        onDocumentLoadFailed: (details) {
          debugPrint('PDF Error: ${details.description}');
        },
        onPageChanged: (details) {
          _savePage(details.newPageNumber);
        },
      ),
    );
  }
}
