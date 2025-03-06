import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:olx/src/components/custom_show_dialog.dart';
import 'package:olx/src/components/custom_snackbar.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController emailController =
      TextEditingController(text: 'kaiique2404@gmail.com');
  final TextEditingController senhaController =
      TextEditingController(text: 'Senha123@');

  bool _isPassword = true;
  bool _isLoading = false;
  bool _hasError = false;

  bool get isPassword => _isPassword;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  void togglePasswordVisibility() {
    _isPassword = !_isPassword;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (emailController.text.isEmpty || senhaController.text.isEmpty) return;

    setLoading(true);
    setError(false);

    try {
      String email = emailController.text.trim();
      String senha = senhaController.text.trim();

      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('usuarios').doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        customShowDialog(
          context: context,
          title: 'Conta Não Registrada',
          content: const Text(
              'Não temos registos desse email em nosso app! Deseja criar uma conta?'),
          cancelText: 'Cancelar',
          onCancel: () => Navigator.pop(context),
          confirmText: 'Sim',
          onConfirm: () => Navigator.pushNamed(context, '/cadastro'),
        );
      }

      redirecionarUsuario(context);
    } catch (e) {
      setError(true);
      if (context.mounted) {
        CustomSnackbar.show(context,
            'Erro ao autenticar usuário. Verifique o email e a senha e tente novamente!');
      }
    } finally {
      setLoading(false);
    }
  }

  void redirecionarUsuario(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(bool value) {
    _hasError = value;
    notifyListeners();
  }
}
