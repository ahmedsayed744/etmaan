import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/notification_history_service.dart';
import 'notification_history_state.dart';

class NotificationHistoryCubit extends Cubit<NotificationHistoryState> {
  final NotificationHistoryService _historyService;

  NotificationHistoryCubit({NotificationHistoryService? historyService})
      : _historyService = historyService ?? NotificationHistoryService.instance,
        super(const NotificationHistoryState());

  void loadHistory() {
    emit(state.copyWith(status: NotificationHistoryStatus.loading));
    try {
      final todayEntries = _historyService.loadToday();
      
      // Filter by notifications whose scheduled time has already passed (now or past)
      final now = DateTime.now();
      final passedEntries = todayEntries
          .where((e) => !e.scheduledAt.isAfter(now))
          .toList();

      // Sort newest first
      passedEntries.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

      emit(state.copyWith(
        status: NotificationHistoryStatus.success,
        entries: passedEntries,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationHistoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
