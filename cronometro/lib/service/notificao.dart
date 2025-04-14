import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacaoService {
  static final NotificacaoService _instancia = NotificacaoService._interno();
  factory NotificacaoService() => _instancia;
  NotificacaoService._interno();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings();
    await _plugin.initialize(InitializationSettings(android: android, iOS: ios));
  }

  Future<void> mostrarNotificacao({
    required int id,
    required String titulo,
    required String corpo,
    bool persistente = false,
  }) async {
    final android = AndroidNotificationDetails(
      'cronometro_channel',
      'Cronômetro',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: persistente,
    );
    final ios = DarwinNotificationDetails();
    await _plugin.show(id, titulo, corpo, NotificationDetails(android: android, iOS: ios));
  }

  Future<void> cancelar(int id) async {
    await _plugin.cancel(id);
  }
}
