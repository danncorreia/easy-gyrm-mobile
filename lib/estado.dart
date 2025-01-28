import 'package:flutter/material.dart';
import 'servicos/treinos_service.dart';

enum Situacao {
  mostrandoAlunos,
  mostrandoDadosAluno,
  mostrarDadosTreino,
  mostrandoLogin
}

class Estado extends ChangeNotifier {
  Situacao _situacao = Situacao.mostrandoLogin;
  String? _token;

  double _altura = 0, _largura = 0;
  double get altura => _altura;
  double get largura => _largura;

  late int _idEducador;
  late String _idAluno;
  late String _idTreino;
  Treino? _treino;

  int get idEducador => _idEducador;
  String get idAluno => _idAluno;
  String get idTreino => _idTreino;
  Treino? get treino => _treino;

  String? get token => _token;

  void setDimensoes(double altura, double largura) {
    _altura = altura;
    _largura = largura;
  }

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }

  void mostrarLogin() {
    _situacao = Situacao.mostrandoLogin;

    notifyListeners();
  }

  bool mostrandoLogin() {
    return _situacao == Situacao.mostrandoLogin;
  }

  void mostrarAlunos() {
    _situacao = Situacao.mostrandoAlunos;

    notifyListeners();
  }

  bool mostrandoAlunos() {
    return _situacao == Situacao.mostrandoAlunos;
  }

  void mostrarDadosAluno(String idAluno) {
    _situacao = Situacao.mostrandoDadosAluno;
    _idAluno = idAluno;

    notifyListeners();
  }

  bool mostrandoDadosAluno() {
    return _situacao == Situacao.mostrandoDadosAluno;
  }

  void mostrarDadosTreino(String idAluno, String idTreino, Treino treino) {
    _situacao = Situacao.mostrarDadosTreino;
    _idAluno = idAluno;
    _idTreino = idTreino;
    _treino = treino;

    notifyListeners();
  }

  bool mostrandoDadosTreino() {
    return _situacao == Situacao.mostrarDadosTreino;
  }
}

late Estado estadoApp;
