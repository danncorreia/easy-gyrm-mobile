import 'package:flutter/material.dart';
import 'package:easy_gym_mobile/estado.dart';

class CardAluno extends StatelessWidget {
  final String nome;
  final String avatar;
  final VoidCallback onTap;

  const CardAluno({
    super.key,
    required this.nome,
    required this.avatar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 30,
                child: avatar.isEmpty
                    ? Image.asset('lib/recursos/imagens/user.png')
                    : Image.network(avatar),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
