// ignore_for_file: dead_code

import 'dart:convert';

import 'package:easy_gym_mobile/componentes/card_exercicio.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_gym_mobile/estado.dart';

class DadosTreino extends StatefulWidget {
  const DadosTreino({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EstadoDadosTreino();
  }
}

const int tamanhoDaPagina = 6;

class _EstadoDadosTreino extends State<DadosTreino> {
  late dynamic _treino;
  bool _carregando = false;
  List<dynamic> _exercicios = [];

  final TextEditingController _controladorDoFiltro = TextEditingController();
  String _filtro = "";

  int _proximaPagina = 1;

  @override
  void initState() {
    super.initState();

    _lerFeedEstatico();
  }

  Future<void> _lerFeedEstatico() async {
    final String resposta =
    await rootBundle.loadString('lib/recursos/jsons/alunosFeed.json');
    var temp = await jsonDecode(resposta);

    var tempAluno = temp["alunos"]
        .firstWhere((aluno) => aluno["_id"] == estadoApp.idAluno);

    _treino = tempAluno["treinos"]
        .firstWhere((exercicio) => exercicio["id_treino"] == estadoApp.idTreino);

    _carregarDadosTreino();
  }

  void _carregarDadosTreino() {
    setState(() {
      _carregando = true;
    });

    if (_filtro.isNotEmpty) {
      _exercicios = _treino
          .where((exercicio) =>
          exercicio["nome"].toLowerCase().contains(_filtro))
          .toList();
    } else {
      final totalDeDadosTreinoParaCarregar = _proximaPagina * tamanhoDaPagina;
      if (_treino["exercicios"].length >= totalDeDadosTreinoParaCarregar) {
        _exercicios =
            _treino["exercicios"].sublist(0, totalDeDadosTreinoParaCarregar);
      }
    }
    print(_treino["exercicios"]);
    print(_exercicios);

    setState(() {
      _carregando = false;
      _proximaPagina++;
    });
  }

  Future<void> _atualizarDadosTreino() async {
    _exercicios = [];
    _proximaPagina = 1;

    _controladorDoFiltro.text = "";
    _filtro = "";

    _carregarDadosTreino();
  }

  void _aplicarFiltro(String filtro) {
    _filtro = filtro;

    _carregarDadosTreino();
  }

  @override
  Widget build(BuildContext context) {
    bool usuarioLogado = false; // corrigir aqui

    return _carregando
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
        appBar: AppBar(actions: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 60, right: 20),
                  child: TextField(
                    controller: _controladorDoFiltro,
                    onSubmitted: (filtro) {
                      _aplicarFiltro(filtro);
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search)),
                  ))),
          usuarioLogado
              ? IconButton(
              onPressed: () {
                // preencher aqui
              },
              icon: const Icon(Icons.logout))
              : IconButton(
              onPressed: () {
                // preencher aqui
              },
              icon: const Icon(Icons.login))
        ]),
        body: FlatList(
            data: _exercicios,
            loading: _carregando,
            numColumns: 1,
            onRefresh: () => _atualizarDadosTreino(),
            onEndReached: () => _carregarDadosTreino(),
            buildItem: (item, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: SizedBox(
                      child: CardExercicio(exercicio: item)
                  )
              );
            }));
  }
}
