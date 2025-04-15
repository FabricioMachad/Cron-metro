import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  int idMessage = 0;

  // Definição de canais de notificação
  static String simpleChannelID = 'simple_notification_channel';
  static String simpleChannelName = 'Simple Notifications';
  static String simpleChannelDescription = 'Este canal é para notificações simples';
  static String expandedChannelID = 'expanded_notification_channel';
  static String expandedChannelName = 'Expanded Notifications';
  static String expandedChannelDescription = 'Este canal é para notificações expandidas';
  static String ongoingChannelID = 'ongoing_notification_channel';
  static String ongoingChannelName = 'Cronômetro em execução';
  static String ongoingChannelDescription = 'Notificação persistente do cronômetro';
  static String lapChannelID = 'lap_notification_channel';
  static String lapChannelName = 'Voltas Registradas';
  static String lapChannelDescription = 'Notificações de voltas do cronômetro';

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showSimpleNotification() async {
    if (await checkNotificationPermission() == false) return;

    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      simpleChannelID,
      simpleChannelName,
      channelDescription: simpleChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      idMessage++,
      'Título da Notificação',
      'Esta é uma notificação simples.',
      platformChannelSpecifics,
    );
  }

  Future<void> showExpandedNotification(String title, String shortMessage, String longMessage) async {
    if (await checkNotificationPermission() == false) return;

    BigTextStyleInformation bigTextStyle = BigTextStyleInformation(
      longMessage,
      contentTitle: title,
      summaryText: shortMessage,
      htmlFormatTitle: true,
      htmlFormatContentTitle: true,
      htmlFormatContent: true,
      htmlFormatBigText: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      expandedChannelID,
      expandedChannelName,
      channelDescription: expandedChannelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      styleInformation: bigTextStyle,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      idMessage++,
      title,
      shortMessage,
      platformChannelSpecifics,
    );
  }

  Future<void> showOngoingNotification(Duration tempo) async {
    if (await checkNotificationPermission() == false) return;

    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      ongoingChannelID,
      ongoingChannelName,
      channelDescription: ongoingChannelDescription,
      importance: Importance.low,
      priority: Priority.low,
      icon: '@mipmap/ic_launcher',
      ongoing: true,
      showWhen: false,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      1, // ID fixo para notificação persistente
      '⏱️ Cronômetro em execução',
      _formatarTempo(tempo),
      platformChannelSpecifics,
    );
  }

  Future<void> updateOngoingNotification(Duration tempo) async {
    await showOngoingNotification(tempo);
  }

  Future<void> cancelOngoingNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(1);
  }

  Future<void> showLapNotification(int numeroVolta, Duration tempoVolta, Duration tempoTotal) async {
    if (await checkNotificationPermission() == false) return;

    await _flutterLocalNotificationsPlugin.show(
      100 + numeroVolta, // ID único por volta
      '🏁 Volta $numeroVolta registrada',
      'Volta: ${_formatarTempo(tempoVolta)} | Total: ${_formatarTempo(tempoTotal)}',
        NotificationDetails(
        android: AndroidNotificationDetails(
          lapChannelID,
          lapChannelName,
          channelDescription: lapChannelDescription,
          importance: Importance.high,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  Future<bool> checkNotificationPermission() async {
    if (Platform.isIOS) {
      return false;
    } else if (Platform.isAndroid) {
      final bool? granted = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return granted ?? false;
    } else {
      return false;
    }
  }

  String _formatarTempo(Duration duracao) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    String h = doisDigitos(duracao.inHours);
    String m = doisDigitos(duracao.inMinutes.remainder(60));
    String s = doisDigitos(duracao.inSeconds.remainder(60));
    return "$h:$m:$s";
  }
}
