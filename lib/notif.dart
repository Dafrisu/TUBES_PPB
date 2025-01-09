import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notifservices {
  final FlutterLocalNotificationsPlugin notifplugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initnotif() async {
    AndroidInitializationSettings androidinit =
        const AndroidInitializationSettings('flutter_logo');

    var initSetting = InitializationSettings(android: androidinit);
    await notifplugin.initialize(initSetting,
        onDidReceiveNotificationResponse:
            (NotificationResponse notifresponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max, icon: 'flutter_logo'));
  }

  Future shownotif(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notifplugin.show(id, title, body, notificationDetails());
  }
}
