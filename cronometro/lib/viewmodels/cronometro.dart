import 'dart:async';

import '../model/voltamodel.dart';
import '../service/notificao.dart';

class CronometroViewModel {
  final Stopwatch _cronometro = Stopwatch();
  Timer? _timer;
  Duration _ultimoTempo = Duration.zero;
  final List<Volta> _voltas = [];
  final NotificacaoService _notificacaoService = NotificacaoService();

  Function()? onUpdate;

  Duration get tempoAtual => _cronometro.elapsed;
  List<Volta> get voltas => _voltas;
  bool get emExecucao => _cronometro.isRunning;

  void iniciarOuPausar() {
    if (_cronometro.isRunning) {
      _cronometro.stop();
      _timer?.cancel();
      _notificacaoService.cancelar(1);
      Timer(Duration(seconds: 10), () {
        if (!_cronometro.isRunning) {
          _notificacaoService.mostrarNotificacao(
            id: 3,
            titulo: "Retomar cronômetro?",
            corpo: "Você pausou o cronômetro. Deseja continuar?",
          );
        }
      });
    } else {
      _cronometro.start();
      _timer = Timer.periodic(Duration(milliseconds: 100), (_) => onUpdate?.call());
      _notificacaoService.mostrarNotificacao(
        id: 1,
        titulo: "Cronômetro em execução",
        corpo: "O cronômetro está contando o tempo",
        persistente: true,
      );
    }
    onUpdate?.call();
  }

  void reiniciar() {
    _cronometro.reset();
    _voltas.clear();
    _ultimoTempo = Duration.zero;
    _notificacaoService.cancelar(1);
    onUpdate?.call();
  }

  void marcarVolta() {
    Duration tempoVolta = _cronometro.elapsed - _ultimoTempo;
    _ultimoTempo = _cronometro.elapsed;
    _voltas.add(Volta(tempoVolta, _cronometro.elapsed));
    _notificacaoService.mostrarNotificacao(
      id: 2,
      titulo: "Volta registrada",
      corpo: "Volta em ${_formatarTempo(tempoVolta)} | Total ${_formatarTempo(_cronometro.elapsed)}",
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
