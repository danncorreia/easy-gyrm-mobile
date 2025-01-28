import 'package:flutter/material.dart';
import 'package:easy_gym_mobile/estado.dart';
import 'package:easy_gym_mobile/servicos/treinos_service.dart';

class CardExercicio extends StatelessWidget {
  final Exercicio exercicio;

  const CardExercicio({super.key, required this.exercicio});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        exercicio.img.isNotEmpty
            ? Image.network(
                exercicio.img,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
            : const SizedBox(
                height: 200,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
        Padding(
            padding: const EdgeInsets.all(1),
            child: Text(exercicio.nome,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20))),
        Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 2, bottom: 2),
            child: Column(
              children: [
                Text("${exercicio.series} séries\n",
                    style: const TextStyle(fontSize: 20)),
                Text("${exercicio.repeticoes} repetições\n",
                    style: const TextStyle(fontSize: 20)),
                Text("${exercicio.carga} kg\n",
                    style: const TextStyle(fontSize: 20)),
              ],
            )),
      ]),
    );
  }
}
