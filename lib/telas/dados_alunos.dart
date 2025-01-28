// remover apos corrigir este codigo
// ignore_for_file: dead_code, unused_field, prefer_final_fields, unused_import

import 'package:easy_gym_mobile/componentes/card_treino_aluno.dart';
import 'package:easy_gym_mobile/estado.dart';
import 'package:easy_gym_mobile/servicos/auth_service.dart';
import 'package:easy_gym_mobile/servicos/alunos_service.dart';
import 'package:easy_gym_mobile/servicos/treinos_service.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class DadosAlunos extends StatefulWidget {
  const DadosAlunos({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DadosAlunosState();
  }
}

class _DadosAlunosState extends State<DadosAlunos> {
  bool _carregando = true;
  Aluno? _aluno;
  List<Treino> _treinos = [];
  String? _erro;

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      setState(() {
        _carregando = true;
        _erro = null;
      });

      // Carregar aluno
      final alunos = await AlunosService.getAlunos();
      final aluno = alunos.firstWhere((a) => a.id == estadoApp.idAluno);
      print('aluno $aluno');

      // Carregar treinos do aluno
      final treinos = await TreinosService.getTreinosDoAluno(aluno.id);
      print('treinos $treinos');
      setState(() {
        _aluno = aluno;
        _treinos = treinos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _carregando = false;
      });
    }
  }

  String getFormattedDate(String date) {
    try {
      var dateParse = DateTime.parse(date);
      var formattedDate = DateFormat('dd/MM/yyyy').format(dateParse);
      return formattedDate;
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_erro != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Erro'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => estadoApp.mostrarAlunos(),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erro ao carregar dados: $_erro'),
              ElevatedButton(
                onPressed: _carregarDados,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_aluno == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Aluno não encontrado'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => estadoApp.mostrarAlunos(),
            ),
          ],
        ),
        body: const Center(
          child: Text('Aluno não encontrado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do Aluno'),
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
            onPressed: () => estadoApp.mostrarAlunos(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _carregarDados,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 230,
                child: Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 150,
                    child: _aluno!.avatar.isEmpty
                        ? Image.asset('lib/recursos/imagens/user.png')
                        : Image.network(_aluno!.avatar),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _aluno!.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Criado em: ${getFormattedDate(_aluno!.data_criacao)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Última atualização: ${getFormattedDate(_aluno!.data_atualizacao)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Treinos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_treinos.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Nenhum treino cadastrado',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: FlatList(
                    data: _treinos,
                    buildItem: (treino, index) {
                      return CardTreinoAluno(
                        treino: treino,
                        idAluno: _aluno!.id,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
