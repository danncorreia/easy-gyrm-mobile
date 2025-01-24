import 'package:flutter/material.dart';
import 'package:easy_gym_mobile/estado.dart';

class CardExercicio extends StatelessWidget {
  final dynamic exercicio;

  const CardExercicio({super.key, required this.exercicio});


  getExercicio() {
    return exercicio;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Image.asset(exercicio["img"]),
        Padding(
            padding: const EdgeInsets.all(1),
            child: Text(exercicio["nome"],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20))),
        Padding(
            padding:
            const EdgeInsets.only(left: 10.0, top: 2, bottom: 2),
            child: Column(
              children: [
                Text(
                    exercicio["series"].toString() + " séries\n",
                    style: const TextStyle(
                    fontSize: 20)),
                Text(exercicio["repeticoes"].toString() + " repetições\n",
                    style: const TextStyle(
                        fontSize: 20)),
                Text(exercicio["carga"].toString() + " kg\n",
                    style: const TextStyle(
                        fontSize: 20)),
              ],
            )),

      ]),
    );
  }
}
