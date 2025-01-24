import 'package:flutter/material.dart';
import 'package:easy_gym_mobile/estado.dart';

class CardTreinoAluno extends StatelessWidget {
  final dynamic treino;
  final dynamic idAluno;

  const CardTreinoAluno({super.key, required this.treino, required this.idAluno});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          estadoApp.mostrarDadosTreino(idAluno, treino["id_treino"]);
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                      child: Text(treino["nome"],
                          style: const TextStyle(fontSize: 25)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}
