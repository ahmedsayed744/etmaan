import 'package:etmaan/core/notifications/notification_payload.dart';
import 'package:etmaan/core/routing/routs.dart';
import 'package:etmaan/features/azkar/presentation/view/azkar_details_view.dart';
import 'package:etmaan/features/prayer/presentation/view/prayer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationRouter {
  NotificationRouter._();

  static void handle(
    BuildContext context,
    NotificationResponse response,
  ) {
    final target = NotificationPayload.parse(response.payload);

    switch (target) {
      case NotificationTarget.quran:
        Navigator.of(context).pushNamed(Routs.quranView);
        return;
      case NotificationTarget.morningAzkar:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AzkarDetailsView(
              title: 'أذكار الصباح',
              jsonPath: 'assets/data/azkar/morning.json',
            ),
          ),
        );
        return;
      case NotificationTarget.eveningAzkar:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AzkarDetailsView(
              title: 'أذكار المساء',
              jsonPath: 'assets/data/azkar/evening.json',
            ),
          ),
        );
        return;
      case NotificationTarget.prayer:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const PrayerView(),
          ),
        );
        return;
      case NotificationTarget.friday:
      case NotificationTarget.motivational:
      case null:
        Navigator.of(context).pushNamed(Routs.rootView);
        return;
    }
  }
}
