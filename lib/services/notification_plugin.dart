import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  InitializationSettings initializationSettings;

  NotificationPlugin() {
    init();
  }
  init() async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          .requestPermissions(
            sound: true,
            alert: true,
            badge: true,
          );
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async {
        onNotificationClick(payload);
      },
    );
  }

  Future<void> showNotification(
      RecievedNotification notifData, Time time) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "1",
      "Medicine",
      "Time to take your pill!",
      importance: Importance.Max,
      priority: Priority.Max,
      playSound: true,
    );
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
      androidNotificationDetails,
      iosNotificationDetails,
    );
    showPending();
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      notifData.id,
      notifData.title,
      notifData.body,
      time,
      notificationDetails,
      payload: 'Test Payload',
    );
  }

  Future<void> appointment(RecievedNotification notifData, String time,
      String date, String name) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "1",
      "Appointment with Dr. " + name,
      "Reminder for your appointment today in an hour",
      importance: Importance.Max,
      priority: Priority.Max,
      playSound: true,
    );
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
      androidNotificationDetails,
      iosNotificationDetails,
    );
    var day = date.split('-');
    var hr = time.split(':');
    DateTime notifTime = DateTime(int.parse(day[2]), int.parse(day[1]),
        int.parse(day[0]), int.parse(hr[0]) - 1, int.parse(hr[1]));
    print(notifTime);
    showPending();
    await flutterLocalNotificationsPlugin.schedule(
      notifData.id,
      notifData.title,
      notifData.body,
      notifTime,
      notificationDetails,
      payload: 'Test Payload',
    );
  }

  Future<void> cancelNotification(int id) async {
    // await flutterLocalNotificationsPlugin.cancelAll();
    print((id ~/ 10) * 10 + 1);
    print((id ~/ 10) * 10 + 2);
    print((id ~/ 10) * 10 + 3);
    await flutterLocalNotificationsPlugin.cancel((id ~/ 10) * 10 + 1);
    await flutterLocalNotificationsPlugin.cancel((id ~/ 10) * 10 + 2);
    await flutterLocalNotificationsPlugin.cancel((id ~/ 10) * 10 + 3);
    showPending();
  }

  Future<void> showPending() async {
    Future pending =
        flutterLocalNotificationsPlugin.pendingNotificationRequests();
    pending.then((value) {
      print(value);
      for (var i = 0; i < value.length; i++) {
        print(value[i].id);
      }
    });
  }
}

class RecievedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  RecievedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
