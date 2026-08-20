import 'dart:io';

/// Foundation for future downloaded adhan audio playback.
/// Does not bundle audio in app assets.
class AdhanService {
  AdhanService._();

  static final AdhanService instance = AdhanService._();

  static const String _fileName = 'adhan.mp3';

  Future<String> get _adhanDirectory async {
    final directory = Directory('${Directory.systemTemp.path}/etmaan_adhan');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory.path;
  }

  Future<String> get localFilePath async {
    final directory = await _adhanDirectory;
    return '$directory/$_fileName';
  }

  Future<bool> hasLocalAdhan() async {
    try {
      final file = File(await localFilePath);
      return file.existsSync();
    } catch (_) {
      return false;
    }
  }

  Future<bool> saveDownloadedAdhan(String sourcePath) async {
    try {
      final source = File(sourcePath);
      if (!await source.exists()) {
        return false;
      }

      final target = File(await localFilePath);
      await source.copy(target.path);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearLocalAdhan() async {
    try {
      final file = File(await localFilePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Safe no-op when file removal fails.
    }
  }
}
