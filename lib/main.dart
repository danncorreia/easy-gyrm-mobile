import 'package:easy_gym_mobile/telas/alunos.dart';
import 'package:easy_gym_mobile/telas/dados_alunos.dart';
import 'package:easy_gym_mobile/telas/dados_treino.dart';
import 'package:flutter/material.dart';
import 'package:easy_gym_mobile/estado.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Estado(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.blueGrey),
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    estadoApp = context.watch<Estado>();

    final media = MediaQuery.of(context);
    estadoApp.setDimensoes(media.size.height, media.size.width);

    Widget tela = const SizedBox.shrink();
    if (estadoApp.mostrandoAlunos()) {
      tela = const Alunos();
    } else if (estadoApp.mostrandoDadosAluno()) {
      tela = const DadosAlunos();
    } else if (estadoApp.mostrandoDadosTreino()) {
      tela = const DadosTreino();
    }

    return tela;
  }
}
