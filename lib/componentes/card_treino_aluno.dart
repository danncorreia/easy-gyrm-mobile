import 'package:flutter/material.dart';
import 'package:easy_gym_mobile/estado.dart';
import 'package:easy_gym_mobile/servicos/treinos_service.dart';

class CardTreinoAluno extends StatelessWidget {
  final Treino treino;
  final String idAluno;

  const CardTreinoAluno({super.key, required this.treino, required this.idAluno});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          treino.nome,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${treino.exercicios.length} exercício${treino.exercicios.length != 1 ? 's' : ''}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => estadoApp.mostrarDadosTreino(idAluno, treino.id, treino),
        ),
        onTap: () => estadoApp.mostrarDadosTreino(idAluno, treino.id, treino),
      ),
    );
  }
}
