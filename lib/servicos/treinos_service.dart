import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_gym_mobile/servicos/auth_service.dart';
import 'package:intl/intl.dart';

String formatApiDate(String dateStr) {
  try {
    // Remove timezone information as it causes issues with parsing
    dateStr = dateStr.replaceAll(RegExp(r'\sGMT[+-]\d{4}$'), '');
    return DateFormat('EEE MMM dd yyyy HH:mm:ss', 'en_US')
        .parse(dateStr)
        .toIso8601String();
  } catch (e) {
    // If parsing fails, return the original string
    return dateStr;
  }
}

class Exercicio {
  final String id;
  final String nome;
  final String img;
  final int series;
  final int repeticoes;
  final int carga;
  final String data_criacao;
  final String data_atualizacao;
  final bool ativo;

  Exercicio({
    required this.id,
    required this.nome,
    required this.img,
    required this.series,
    required this.repeticoes,
    required this.carga,
    required this.data_criacao,
    required this.data_atualizacao,
    this.ativo = true,
  });

  factory Exercicio.fromJson(Map<String, dynamic> json) {
    return Exercicio(
      id: json['_id'] as String,
      nome: json['nome'] as String,
      img: json['img'] as String,
      series: json['series'] as int,
      repeticoes: json['repeticoes'] as int,
      carga: json['carga'] as int,
      data_criacao: formatApiDate(json['data_criacao'] as String),
      data_atualizacao: formatApiDate(json['data_atualizacao'] as String),
      ativo: json['ativo'] ?? true,
    );
  }
}

class Treino {
  final String id;
  final String id_aluno;
  final String nome;
  final List<Exercicio> exercicios;
  final String data_criacao;
  final String data_atualizacao;
  final bool ativo;

  Treino({
    required this.id,
    required this.id_aluno,
    required this.nome,
    required this.exercicios,
    required this.data_criacao,
    required this.data_atualizacao,
    this.ativo = true,
  });

  factory Treino.fromJson(Map<String, dynamic> json) {
    return Treino(
      id: json['_id'] as String,
      id_aluno: json['id_aluno'] as String,
      nome: json['nome'] as String,
      exercicios: (json['exercicios'] as List<dynamic>)
          .map((e) => Exercicio.fromJson(e as Map<String, dynamic>))
          .toList(),
      data_criacao: formatApiDate(json['data_criacao'] as String),
      data_atualizacao: formatApiDate(json['data_atualizacao'] as String),
      ativo: json['ativo'] ?? true,
    );
  }
}

class TreinosService {
  static const String _baseUrl = AuthService.baseUrl;

  static Future<List<Treino>> getTreinosDoAluno(String idAluno) async {
    final token = AuthService.getToken();

    if (token == null) {
      throw Exception('Usuário não está autenticado');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/students/$idAluno/workouts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Treino.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar treinos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar treinos: $e');
    }
  }
}
