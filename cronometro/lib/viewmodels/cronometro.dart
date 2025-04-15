import 'dart:async';

import '../model/voltamodel.dart';
import '../service/notificao.dart';

class CronometroViewModel {
  final Stopwatch _cronometro = Stopwatch();
  Timer? _timer;
  Duration _ultimoTempo = Duration.zero;
  final List<Volta> _voltas = [];
  final NotificationService _notificacaoService = NotificationService();

  Function()? onUpdate;

  Duration get tempoAtual => _cronometro.elapsed;
  List<Volta> get voltas => _voltas;
  bool get emExecucao => _cronometro.isRunning;

  void iniciarOuPausar() {
    if (_cronometro.isRunning) {
      _cronometro.stop();
      _timer?.cancel();
      _notificacaoService.cancelOngoingNotification();
      Timer(Duration(seconds: 10), () {
        if (!_cronometro.isRunning) {
          _notificacaoService.showExpandedNotification(
          "Retomar cronômetro?",
          "Cronômetro pausado",
          "Você pausou o cronômetro. Deseja continuar?",
);

        }
      });
    }
    onUpdate?.call();
  }

  void reiniciar() {
    _cronometro.reset();
    _voltas.clear();
    _ultimoTempo = Duration.zero;
    _notificacaoService.cancelOngoingNotification();
    onUpdate?.call();
  }

  void marcarVolta() {
  Duration tempoVolta = _cronometro.elapsed - _ultimoTempo;
  _ultimoTempo = _cronometro.elapsed;
  _voltas.add(Volta(tempoVolta, _cronometro.elapsed));

  _notificacaoService.showExpandedNotification(
    "Volta registrada",
    "Volta em ${_formatarTempo(tempoVolta)}",
    "Você completou uma volta em ${_formatarTempo(tempoVolta)}.\n"
    "Tempo total: ${_formatarTempo(_cronometro.elapsed)}",
  );

  onUpdate?.call();
}


  String _formatarTempo(Duration duracao) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    String h = doisDigitos(duracao.inHours);
    String m = doisDigitos(duracao.inMinutes.remainder(60));
    String s = doisDigitos(duracao.inSeconds.remainder(60));
    return "$h:$m:$s";
  }
}
