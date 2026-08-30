import '../data/notification_history_entry.dart';

enum NotificationHistoryStatus { initial, loading, success, error }

class NotificationHistoryState {
  final NotificationHistoryStatus status;
  final List<NotificationHistoryEntry> entries;
  final String? errorMessage;

  const NotificationHistoryState({
    this.status = NotificationHistoryStatus.initial,
    this.entries = const [],
    this.errorMessage,
  });

  NotificationHistoryState copyWith({
    NotificationHistoryStatus? status,
    List<NotificationHistoryEntry>? entries,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationHistoryState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
