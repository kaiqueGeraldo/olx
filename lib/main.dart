import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx/firebase_options.dart';
import 'package:olx/src/controllers/auth/cadastro_controller.dart';
import 'package:olx/src/controllers/auth/login_controller.dart';
import 'package:olx/src/controllers/auth/redefinir_senha_controller.dart';
import 'package:olx/src/controllers/main/configuracoes_controller.dart';
import 'package:olx/src/controllers/main/home_controller.dart';
import 'package:olx/src/controllers/main/meus_anuncios_controller.dart';
import 'package:olx/src/controllers/main/novo_anuncio_controller.dart';
import 'package:olx/src/controllers/splash_screen_controller.dart';
import 'package:olx/src/views/splash_screen_page.dart';
import 'package:olx/src/routes/routes.dart';
import 'package:olx/src/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print("Erro capturado: ${details.exception}");
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenController()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => CadastroController()),
        ChangeNotifierProvider(create: (_) => RedefinirSenhaController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => MeusAnunciosController()),
        ChangeNotifierProvider(create: (_) => NovoAnuncioController()),
        ChangeNotifierProvider(create: (_) => ConfiguracoesController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeData temaPadrao = ThemeData(
    primaryColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    scaffoldBackgroundColor: AppColors.whiteColor,
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: AppColors.primaryColor),
    indicatorColor: AppColors.primaryColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColor,
      selectedItemColor: AppColors.whiteColor,
      unselectedItemColor: AppColors.greyColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OLX',
      home: const SplashScreenPage(),
      debugShowCheckedModeBanner: false,
      theme: temaPadrao,
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
