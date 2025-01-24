import 'package:flutter/material.dart';

enum Situacao { mostrandoAlunos, mostrandoDadosAluno, mostrarDadosTreino }

class Estado extends ChangeNotifier {
  Situacao _situacao = Situacao.mostrandoAlunos;

  double _altura = 0, _largura = 0;
  double get altura => _altura;
  double get largura => _largura;

  late int _idAluno;
  late int _idTreino;

  int get idAluno => _idAluno;
  int get idTreino => _idTreino;

  void setDimensoes(double altura, double largura) {
    _altura = altura;
    _largura = largura;
  }

  void mostrarAlunos() {
    _situacao = Situacao.mostrandoAlunos;

    notifyListeners();
  }

  bool mostrandoAlunos() {
    return _situacao == Situacao.mostrandoAlunos;
  }

  void mostrarDadosAluno(int idAluno) {
    _situacao = Situacao.mostrandoDadosAluno;
    _idAluno = idAluno;

    notifyListeners();
  }

  bool mostrandoDadosAluno() {
    return _situacao == Situacao.mostrandoDadosAluno;
  }

  void mostrarDadosTreino(int idAluno, int idTreino) {
    _situacao = Situacao.mostrarDadosTreino;
    _idAluno = idAluno;
    _idTreino = idTreino;

    notifyListeners();
  }

  bool mostrandoDadosTreino() {
    return _situacao == Situacao.mostrarDadosTreino;
  }
}

late Estado estadoApp;
