import 'package:flutter/material.dart';
import 'package:easy_gym_mobile/estado.dart';

class CardAluno extends StatelessWidget {
  final dynamic aluno;

  const CardAluno({super.key, required this.aluno});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          estadoApp.mostrarDadosAluno(aluno["_id"]);
        },
        child: Card(
          child: Row(children: [
            CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50,
                child: Image.asset('lib/recursos/imagens/user.png')),
            Row(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                  child: Text(aluno["nome"],
                      style: const TextStyle(fontSize: 17))),
            ]),
          ]),
        ));
  }
}
