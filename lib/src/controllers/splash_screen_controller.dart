import 'package:flutter/material.dart';

class SplashScreenController extends ChangeNotifier {
  List<double> opacities = [0, 0, 0];

  void startAnimation(BuildContext context) async {
    for (int i = 0; i < opacities.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      opacities[i] = 1.0;
      notifyListeners();
    }

    await Future.delayed(const Duration(seconds: 1));
    redirecionarUsuario(context);
  }

  void redirecionarUsuario(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}
