// ignore_for_file: dead_code

import 'package:easy_gym_mobile/componentes/card_exercicio.dart';
import 'package:easy_gym_mobile/estado.dart';
import 'package:easy_gym_mobile/servicos/auth_service.dart';
import 'package:easy_gym_mobile/servicos/treinos_service.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';

class DadosTreino extends StatefulWidget {
  const DadosTreino({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EstadoDadosTreino();
  }
}

class _EstadoDadosTreino extends State<DadosTreino> {
  bool _carregando = false;
  List<Exercicio> _exercicios = [];
  String _filtro = "";
  final TextEditingController _controladorDoFiltro = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDadosTreino();
  }

  void _carregarDadosTreino() {
    if (estadoApp.treino == null) {
      print("Treino ${estadoApp.treino}");
      setState(() {
        _carregando = false;
        _exercicios = [];
      });
      return;
    }

    setState(() {
      _carregando = true;
    });

    if (_filtro.isNotEmpty) {
      _exercicios = estadoApp.treino!.exercicios
          .where((exercicio) =>
              exercicio.nome.toLowerCase().contains(_filtro.toLowerCase()))
          .toList();
    } else {
      _exercicios = estadoApp.treino!.exercicios;
    }

    setState(() {
      _carregando = false;
    });
  }

  Future<void> _atualizarDadosTreino() async {
    _controladorDoFiltro.text = "";
    _filtro = "";
    _carregarDadosTreino();
  }

  void _aplicarFiltro(String filtro) {
    setState(() {
      _filtro = filtro;
      _carregarDadosTreino();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (estadoApp.treino == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Treino não encontrado'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => estadoApp.mostrarDadosAluno(estadoApp.idAluno),
            ),
          ],
        ),
        body: const Center(
          child: Text('Treino não encontrado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(estadoApp.treino!.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              estadoApp.mostrarLogin();
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => estadoApp.mostrarDadosAluno(estadoApp.idAluno),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controladorDoFiltro,
              decoration: const InputDecoration(
                labelText: 'Filtrar exercícios',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _aplicarFiltro,
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _atualizarDadosTreino,
                    child: _exercicios.isEmpty
                        ? const Center(
                            child: Text('Nenhum exercício encontrado'),
                          )
                        : ListView.builder(
                            itemCount: _exercicios.length,
                            itemBuilder: (context, index) {
                              return CardExercicio(
                                exercicio: _exercicios[index],
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
