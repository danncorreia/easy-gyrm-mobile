// ignore_for_file: dead_code

import 'package:easy_gym_mobile/componentes/card_aluno.dart';
import 'package:easy_gym_mobile/servicos/alunos_service.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:easy_gym_mobile/estado.dart';
import 'package:easy_gym_mobile/servicos/auth_service.dart';

class Alunos extends StatefulWidget {
  const Alunos({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EstadoAlunos();
  }
}

const int tamanhoDaPagina = 10;

class _EstadoAlunos extends State<Alunos> {
  List<Aluno> _alunos = [];
  bool _carregando = false;
  bool _erro = false;
  String _mensagemErro = '';

  final TextEditingController _controladorDoFiltro = TextEditingController();
  String _filtro = "";

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  Future<void> _carregarAlunos() async {
    setState(() {
      _carregando = true;
      _erro = false;
      _mensagemErro = '';
    });

    try {
      final alunos = await AlunosService.getAlunos();
      setState(() {
        _alunos = alunos;
        if (_filtro.isNotEmpty) {
          _alunos = _alunos
              .where((aluno) =>
                  aluno.nome.toLowerCase().contains(_filtro.toLowerCase()))
              .toList();
        }
      });
    } catch (e) {
      setState(() {
        _erro = true;
        _mensagemErro = e.toString();
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<void> _atualizarAlunos() async {
    _controladorDoFiltro.text = "";
    _filtro = "";
    await _carregarAlunos();
  }

  void _aplicarFiltro(String filtro) {
    setState(() {
      _filtro = filtro;
      if (_filtro.isNotEmpty) {
        _alunos = _alunos
            .where((aluno) =>
                aluno.nome.toLowerCase().contains(_filtro.toLowerCase()))
            .toList();
      } else {
        _carregarAlunos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_erro) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Alunos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthService.logout();
                estadoApp.mostrarLogin();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erro: $_mensagemErro'),
              ElevatedButton(
                onPressed: _carregarAlunos,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              estadoApp.mostrarLogin();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controladorDoFiltro,
              decoration: const InputDecoration(
                labelText: 'Filtrar alunos',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _aplicarFiltro,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _atualizarAlunos,
              child: FlatList(
                data: _alunos,
                buildItem: (aluno, int index) {
                  return CardAluno(
                    nome: aluno.nome,
                    avatar: aluno.avatar,
                    onTap: () {
                      estadoApp.mostrarDadosAluno(aluno.id);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
