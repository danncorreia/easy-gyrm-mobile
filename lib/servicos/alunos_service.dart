import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_gym_mobile/servicos/auth_service.dart';

class Aluno {
  final String id;
  final String nome;
  final String avatar;
  final String data_criacao;
  final String data_atualizacao;

  Aluno({
    required this.id,
    required this.nome,
    required this.avatar,
    required this.data_criacao,
    required this.data_atualizacao,
  });

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['_id'] as String,
      nome: json['nome'] as String,
      avatar: json['avatar'] as String,
      data_criacao: json['data_criacao'] as String,
      data_atualizacao: json['data_atualizacao'] as String,
    );
  }
}

class AlunosService {
  static const String _baseUrl = AuthService.baseUrl;

  static Future<List<Aluno>> getAlunos() async {
    final educador = AuthService.getEducador();
    final token = AuthService.getToken();

    if (educador == null || token == null) {
      throw Exception('Usuário não está autenticado');
    }

    Educador educ = Educador.fromJson(educador.toJson());

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/students?educadorId=${educ.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> alunosJson = jsonDecode(response.body);
        return alunosJson.map((json) => Aluno.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar alunos');
      }
    } catch (e) {
      print('Erro ao buscar alunos: $e');
      throw Exception('Erro ao buscar alunos');
    }
  }
}
