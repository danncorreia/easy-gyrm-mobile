// remover apos corrigir este codigo
// ignore_for_file: dead_code, unused_field, prefer_final_fields, unused_import
import 'dart:convert';

import 'package:easy_gym_mobile/componentes/card_treino_aluno.dart';
import 'package:easy_gym_mobile/estado.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:toast/toast.dart';

class DadosAlunos extends StatefulWidget {
  const DadosAlunos({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DadosAlunosState();
  }
}

enum _EstadoAluno { naoVerificado, temAluno, semAluno }

class _DadosAlunosState extends State<DadosAlunos> {
  late dynamic _feedDeAlunos;

  _EstadoAluno _temAluno = _EstadoAluno.naoVerificado;
  late dynamic _aluno;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _lerFeedEstatico();
  }

  Future<void> _lerFeedEstatico() async {
    String conteudoJson =
    await rootBundle.loadString("lib/recursos/jsons/alunosFeed.json");
    _feedDeAlunos = await json.decode(conteudoJson);

    _carregarAluno();
  }

  void _carregarAluno() {
    setState(() {
      _aluno = _feedDeAlunos["alunos"]
          .firstWhere((aluno) => aluno["_id"] == estadoApp.idAluno);
    });

    _temAluno = _aluno != null
        ? _EstadoAluno.temAluno
        : _EstadoAluno.semAluno;
  }

  String getFormattedDate(String date) {
    var dateParse = DateTime.parse(date);
    var formattedDate = DateFormat('dd/MM/yyyy').format(dateParse);
    return formattedDate;
  }

  Widget _exibirAluno() {
    bool usuarioLogado = false; // corrigir aqui

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(children: [
          Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
              child: Text(
                "Aluno " + _aluno["nome"],
                style: const TextStyle(fontSize: 15),
              )),
          const Spacer(),
          GestureDetector(
            onTap: () {
              estadoApp.mostrarAlunos();
            },
            child: const Icon(Icons.arrow_back, size: 30),
          )
        ]),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 230,
            child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 150,
                  child: Image.asset('lib/recursos/imagens/user.png'))
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    _aluno["nome"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cadastro\n',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: getFormattedDate(_aluno["cadastro"]),
                          style: TextStyle(
                            fontSize: 20, // Font size for the second line
                          ),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      height: 1.3, // Line height
                    ),
                  )
                ],
              )
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "Treinos",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:
                FlatList(
                    data: _aluno["treinos"],
                    numColumns: 1,
                    buildItem: (item, index) {
                      return SizedBox(
                          height: estadoApp.altura * 0.5,
                          child: CardTreinoAluno(treino: item, idAluno: _aluno["_id"]));
                    }),
            )
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget detalhes = const SizedBox.shrink();

    if (_temAluno == _EstadoAluno.naoVerificado) {
      detalhes = const SizedBox.shrink();
    } else if (_temAluno == _EstadoAluno.temAluno) {
      detalhes = _exibirAluno();
    } else {
      // detalhes = _exibirMensagemAlunoInexistente();
    }

    return detalhes;
  }
}
