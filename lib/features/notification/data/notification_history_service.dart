import 'dart:convert';
import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import 'notification_history_entry.dart';

class NotificationHistoryService {
  NotificationHistoryService._();
  static final NotificationHistoryService instance = NotificationHistoryService._();

  // Helper to format Date only (YYYY-MM-DD)
  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // Load today's notifications from history
  List<NotificationHistoryEntry> loadToday() {
    try {
      final String? jsonStr = CacheHelper().getData(
        key: CacheKeys.notificationDailyHistory,
      ) as String?;

      if (jsonStr == null || jsonStr.isEmpty) {
        return [];
      }

      final Map<String, dynamic> data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final String? storedDate = data['date'] as String?;
      final todayDate = _getTodayDateString();

      // Daily reset: If stored date is not today, return empty and rotate
      if (storedDate != todayDate) {
        return [];
      }

      final List<dynamic> entriesJson = data['entries'] as List<dynamic>;
      return entriesJson
          .map((e) => NotificationHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Save the list of entries for today
  Future<void> _saveToday(List<NotificationHistoryEntry> entries) async {
    try {
      final todayDate = _getTodayDateString();
      final Map<String, dynamic> data = {
        'date': todayDate,
        'entries': entries.map((e) => e.toJson()).toList(),
      };
      final jsonStr = jsonEncode(data);
      await CacheHelper().saveData(
        key: CacheKeys.notificationDailyHistory,
        value: jsonStr,
      );
    } catch (_) {}
  }

  // Add an entry to today's history
  Future<void> addEntry(NotificationHistoryEntry entry) async {
    final entries = loadToday();
    
    // Check if the exact entry (by type and scheduled time) already exists to avoid duplicates
    final exists = entries.any((e) =>
        e.type == entry.type &&
        e.scheduledAt.isAtSameMomentAs(entry.scheduledAt));

    if (!exists) {
      entries.add(entry);
      await _saveToday(entries);
    }
  }
}
