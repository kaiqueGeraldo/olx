import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/components/custom_snackbar.dart';
import 'package:olx/src/models/usuario.dart';

class CadastroController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final FocusNode senhaFocusNode = FocusNode();

  bool isLoading = false;
  bool isPassword = true;
  bool showPasswordCriteria = false;

  bool hasUpperCase = false;
  bool hasLowerCase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  bool hasMinLength = false;

  CadastroController() {
    senhaFocusNode.addListener(() {
      showPasswordCriteria = senhaFocusNode.hasFocus;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    senhaFocusNode.dispose();
    super.dispose();
  }

  void validarSenha(String value) {
    hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
    hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
    hasNumber = RegExp(r'\d').hasMatch(value);
    hasSpecialChar = RegExp(r'[!@#\$&*~]').hasMatch(value);
    hasMinLength = value.length >= 8;
    notifyListeners();
  }

  /// **Função para cadastrar o usuário**
  Future<void> cadastrar(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      String nome = nomeController.text.trim();
      String email = emailController.text.trim();
      String senha = senhaController.text.trim();

      UserCredential firebaseUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      Usuario usuario = Usuario(
        idUsuario: firebaseUser.user!.uid,
        nome: nome,
        email: email,
        senha: senha,
      );

      await _db
          .collection('usuarios')
          .doc(usuario.idUsuario)
          .set(usuario.toMap());

      redirecionarUsuario(context);
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.show(context, 'Erro ao cadastrar usuário: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void redirecionarUsuario(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  void togglePasswordVisibility() {
    isPassword = !isPassword;
    notifyListeners();
  }
}
