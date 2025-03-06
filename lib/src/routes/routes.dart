import 'package:flutter/material.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:olx/src/views/main/configuracoes_page.dart';
import 'package:olx/src/views/main/detalhes_anuncio.dart';
import 'package:olx/src/views/main/meus_anuncios_page.dart';
import 'package:olx/src/views/main/novo_anuncio_page.dart';
import 'package:olx/src/views/auth/cadastro_page.dart';
import 'package:olx/src/views/auth/login_page.dart';
import 'package:olx/src/views/auth/redefinir_senha_page.dart';
import 'package:olx/src/views/main/home_page.dart';
import 'package:olx/src/views/splash_screen_page.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreenPage(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case '/cadastro':
        return MaterialPageRoute(
          builder: (_) => const CadastroPage(),
        );
      case '/redefinir-senha':
        return MaterialPageRoute(
          builder: (_) => const RedefinirSenhaPage(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case '/meus-anuncios':
        return MaterialPageRoute(
          builder: (_) => const MeusAnunciosPage(),
        );
      case '/novo-anuncio':
        return MaterialPageRoute(
          builder: (_) => const NovoAnuncioPage(),
        );
      case '/detalhes-anuncio':
        return MaterialPageRoute(
          builder: (_) => DetalhesAnuncio(args as Anuncio),
        );
      case '/configuracoes':
        return MaterialPageRoute(
          builder: (_) => const ConfiguracoesPage(),
        );
      default:
        return _routeError();
    }
  }

  static Route<dynamic> _routeError() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Tela não encontrada'),
        ),
        body: const Center(
          child: Text('Tela não encontrada! '),
        ),
      ),
    );
  }
}
