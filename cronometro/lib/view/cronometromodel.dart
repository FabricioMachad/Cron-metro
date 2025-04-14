import 'package:flutter/material.dart';

import '../model/voltamodel.dart';
import '../viewmodels/cronometro.dart';

class CronometroView extends StatefulWidget {
  @override
  State<CronometroView> createState() => _CronometroViewState();
}

class _CronometroViewState extends State<CronometroView> {
  final vm = CronometroViewModel();

  @override
  void initState() {
    super.initState();
    vm.onUpdate = () => setState(() {});
  }

  String _formatarTempo(Duration duracao) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    return "${doisDigitos(duracao.inHours)}:${doisDigitos(duracao.inMinutes.remainder(60))}:${doisDigitos(duracao.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    double fonteCronometro = MediaQuery.of(context).size.width * 0.1;

    return Scaffold(
      appBar: AppBar(title: Text('Cronômetro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Tempo decorrido',
              value: _formatarTempo(vm.tempoAtual),
              child: Text(
                _formatarTempo(vm.tempoAtual),
                style: TextStyle(
                  fontSize: fonteCronometro,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _botao(text: vm.emExecucao ? 'Pausar' : 'Iniciar', onPressed: vm.iniciarOuPausar),
                _botao(text: 'Reiniciar', onPressed: vm.reiniciar),
                _botao(text: 'Marcar Volta', onPressed: vm.marcarVolta),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: vm.voltas.length,
                itemBuilder: (_, index) {
                  Volta v = vm.voltas[index];
                  return Semantics(
                    label: 'Volta ${index + 1}',
                    value: 'Tempo da volta: ${_formatarTempo(v.tempoVolta)}, Tempo total: ${_formatarTempo(v.tempoTotal)}',
                    child: Card(
                      color: Colors.grey[850],
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Icon(Icons.timer, color: Colors.white70),
                        title: Text(
                          'Volta ${index + 1}: ${_formatarTempo(v.tempoVolta)} | Total ${_formatarTempo(v.tempoTotal)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _botao({required String text, required VoidCallback onPressed}) {
    return Semantics(
      button: true,
      label: text,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text),
      ),
    );
  }
}
