// ignore_for_file: dead_code

import 'dart:convert';

import 'package:easy_gym_mobile/componentes/card_aluno.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_gym_mobile/estado.dart';

class Alunos extends StatefulWidget {
  const Alunos({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EstadoAlunos();
  }
}

const int tamanhoDaPagina = 6;

class _EstadoAlunos extends State<Alunos> {
  late dynamic _feedDeAlunos;
  bool _carregando = false;
  List<dynamic> _alunos = [];

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
    _feedDeAlunos = await jsonDecode(resposta);

    _carregarAlunos();
  }

  void _carregarAlunos() {
    setState(() {
      _carregando = true;
    });

    if (_filtro.isNotEmpty) {
      _alunos = _alunos
          .where((aluno) =>
          aluno["nome"].toLowerCase().contains(_filtro))
          .toList();
    } else {
      final totalDeAlunosParaCarregar = _proximaPagina * tamanhoDaPagina;
      if (_feedDeAlunos["alunos"].length >= totalDeAlunosParaCarregar) {
        _alunos =
            _feedDeAlunos["alunos"].sublist(0, totalDeAlunosParaCarregar);
      }
    }

    setState(() {
      _carregando = false;
      _proximaPagina++;
    });
  }

  Future<void> _atualizarAlunos() async {
    _alunos = [];
    _proximaPagina = 1;

    _controladorDoFiltro.text = "";
    _filtro = "";

    _carregarAlunos();
  }

  void _aplicarFiltro(String filtro) {
    _filtro = filtro;

    _carregarAlunos();
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
            data: _alunos,
            loading: _carregando,
            numColumns: 1,
            onRefresh: () => _atualizarAlunos(),
            onEndReached: () => _carregarAlunos(),
            buildItem: (item, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0), // Espaçamento vertical
                child: SizedBox(
                    height: estadoApp.altura * 0.1,
                    child: CardAluno(aluno: item)
                )
              );
            }));
  }
}
