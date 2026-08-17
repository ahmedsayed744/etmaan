import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QuranPdfView extends StatelessWidget {
  const QuranPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم'), centerTitle: true),
      body: SfPdfViewer.asset(
        'assets/data/quran/quran.pdf',
        canShowPaginationDialog: true,
        canShowScrollHead: true,
        onDocumentLoaded: (details) {
          debugPrint('PDF Loaded: ${details.document.pages.count} pages');
        },
        onDocumentLoadFailed: (details) {
          debugPrint('PDF Error: ${details.description}');
        },
      ),
    );
  }
}
