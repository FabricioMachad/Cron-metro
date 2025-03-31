import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(Cronometro());
}

class Cronometro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cronômetro",
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: CronometroInicial(),
    );
  }
}

class CronometroInicial extends StatefulWidget {
  @override
  _CronometroInicialState createState() => _CronometroInicialState();
}

class _CronometroInicialState extends State<CronometroInicial> {
  Stopwatch _play = Stopwatch();
  Timer? _tempo;
  List<String> _voltas = [];
  Duration _ultimoTempo = Duration.zero;

  String _formatarTempo(Duration duracao) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');

    String horas = doisDigitos(duracao.inHours);
    String minutos = doisDigitos(duracao.inMinutes.remainder(60));
    String segundos = doisDigitos(duracao.inSeconds.remainder(60));
    return "$horas:$minutos:$segundos";
  }

  void _comecar() {
    setState(() {
      if (_play.isRunning) {
        _play.stop();
        _tempo?.cancel();
      } else {
        _play.start();
        _tempo = Timer.periodic(Duration(milliseconds: 100), (timer) {
          setState(() {});
        });
      }
    });
  }

  void _resetar() {
    setState(() {
      _play.reset();
      _voltas.clear();
      _ultimoTempo = Duration.zero;
    });
  }

  void _contavoltas() {
    Duration tempoAtual = _play.elapsed;
    Duration tempoVolta = tempoAtual - _ultimoTempo;

    setState(() {
      _voltas.add("Fiz em ${_formatarTempo(tempoVolta)} | Tempo total ${_formatarTempo(tempoAtual)}");
      _ultimoTempo = tempoAtual;
    });
  }

  @override
  void dispose() {
    _tempo?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fonteCronometro = MediaQuery.of(context).size.width * 0.1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cronômetro"),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _formatarTempo(_play.elapsed),
              style: TextStyle(fontSize: fonteCronometro, fontWeight: FontWeight.bold, color: Colors.greenAccent),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _botaoBranco(
                  onPressed: _comecar,
                  text: _play.isRunning ? 'Pausar' : 'Iniciar',
                ),
                _botaoBranco(
                  onPressed: _resetar,
                  text: 'Reiniciar',
                ),
                _botaoBranco(
                  onPressed: _contavoltas,
                  text: 'Marcar Volta',
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _voltas.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[850],
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.timer, color: Colors.white70),
                      title: Text(
                        "Volta ${index + 1}: ${_voltas[index]}",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoBranco({required VoidCallback onPressed, required String text}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text),
    );
  }
}
