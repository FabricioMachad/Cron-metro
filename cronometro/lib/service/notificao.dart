import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String ongoingChannelID = 'ongoing_channel';
  static const String ongoingChannelName = 'Cronômetro em execução';
  static const String ongoingChannelDescription = 'Notificação persistente do cronômetro';

  static const String lapChannelID = 'lap_channel';
  static const String lapChannelName = 'Voltas do cronômetro';
  static const String lapChannelDescription = 'Notificações de voltas registradas';

  static const String reminderChannelID = 'reminder_channel';
  static const String reminderChannelName = 'Lembretes';
  static const String reminderChannelDescription = 'Sugestões e lembretes do cronômetro';

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Mostra notificação persistente com tempo atual
  Future<void> showOngoingNotification(Duration tempo) async {
    await _flutterLocalNotificationsPlugin.show(
      1, // ID fixo para notificação persistente
      '⏱️ Cronômetro em execução',
      'Tempo: ${_formatarTempo(tempo)}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          ongoingChannelID,
          ongoingChannelName,
          channelDescription: ongoingChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          ongoing: true,
          onlyAlertOnce: true,
        ),
      ),
    );
  }

  /// Atualiza notificação persistente com tempo decorrido
  Future<void> updateOngoingNotification(Duration tempo) async {
    await showOngoingNotification(tempo);
  }

  /// Cancela a notificação persistente
  Future<void> cancelOngoingNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(1); // Cancela pelo ID fixo
  }

  /// Mostra notificação de volta registrada
  Future<void> showLapNotification(int numeroVolta, Duration tempoVolta, Duration tempoTotal) async {
    await _flutterLocalNotificationsPlugin.show(
      100 + numeroVolta, // ID diferente por volta
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

  Future<void> showExpandedNotification(String title, String shortMessage, String longMessage) async {
    BigTextStyleInformation bigTextStyle = BigTextStyleInformation(
      longMessage,
      contentTitle: title,
      summaryText: shortMessage,
    );

    await _flutterLocalNotificationsPlugin.show(
      999, // ID exclusivo para sugestão
      title,
      shortMessage,
      NotificationDetails(
        android: AndroidNotificationDetails(
          reminderChannelID,
          reminderChannelName,
          channelDescription: reminderChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: bigTextStyle,
        ),
      ),
    );
  }

  String _formatarTempo(Duration duracao) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    final horas = doisDigitos(duracao.inHours);
    final minutos = doisDigitos(duracao.inMinutes.remainder(60));
    final segundos = doisDigitos(duracao.inSeconds.remainder(60));
    return "$horas:$minutos:$segundos";
  }
}
