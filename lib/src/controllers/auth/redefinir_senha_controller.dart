import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx/src/components/custom_snackbar.dart';

class RedefinirSenhaController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? validarEmail(String? text) {
    final regex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|outlook\.com|yahoo\.com)$');
    if (text == null || text.trim().isEmpty) {
      return 'O campo não pode estar vazio';
    } else if (!regex.hasMatch(text.trim())) {
      return 'Informe um email válido (@gmail.com, @hotmail.com, etc.)';
    }
    return null;
  }

  Future<void> enviarRedefinicao(BuildContext context) async {
    if (validarEmail(emailController.text) != null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      _mostrarMensagem(context, 'E-mail de redefinição enviado!', Colors.green);
      Navigator.pop(context);
    } catch (e) {
      _mostrarMensagem(context, 'Erro: ${e.toString()}', Colors.red);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _mostrarMensagem(BuildContext context, String mensagem, Color color) {
    CustomSnackbar.show(context, mensagem, backgroundColor: color);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
