import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class Educador {
  final int id;
  final String nome;
  final String email;

  Educador({
    required this.id,
    required this.nome,
    required this.email,
  });

  factory Educador.fromJson(Map<String, dynamic> json) {
    return Educador(
      id: json['_id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'nome': nome,
        'email': email,
      };
}

class AuthService {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
  static const String _tokenKey = 'access_token';
  static const String _educadorKey = 'educador_data';
  static final _storage = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static Future<String?> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final token = responseData['access_token'];
        final educadorData = responseData['educador'];

        await _salvarToken(token);
        await _salvarEducador(Educador.fromJson(educadorData));

        return token;
      }
      return null;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }

  static Future<void> _salvarToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  static Future<void> _salvarEducador(Educador educador) async {
    await _storage.write(_educadorKey, educador.toJson());
  }

  static String? getToken() {
    return _storage.read(_tokenKey);
  }

  static Educador? getEducador() {
    final educadorJson = _storage.read(_educadorKey);
    if (educadorJson != null) {
      return Educador.fromJson(educadorJson);
    }
    return null;
  }

  static Future<void> logout() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_educadorKey);
  }
}
