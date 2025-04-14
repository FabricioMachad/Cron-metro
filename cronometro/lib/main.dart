import 'package:flutter/material.dart';

import 'service/notificao.dart';
import 'view/cronometromodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificacaoService().init();
  runApp(CronometroApp());
}

class CronometroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cronômetro',
      theme: ThemeData.dark(),
      home: CronometroView(),
    );
  }
}
