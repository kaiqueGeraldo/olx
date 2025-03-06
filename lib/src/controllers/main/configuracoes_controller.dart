import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/components/custom_button.dart';
import 'package:olx/src/components/custom_show_modal_button.dart';
import 'package:olx/src/components/custom_snackbar.dart';
import 'package:olx/src/utils/colors.dart';

class ConfiguracoesController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void confirmarSair(BuildContext context) {
    CustomShowModalButton.show(
      context: context,
      title: 'Sair da Conta',
      children: _contentSairConta(context),
      isLoading: _isLoading,
    );
  }

  Widget _contentSairConta(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deseja realmente sair da sua conta?',
          style: TextStyle(color: AppColors.greyColor),
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: 'Sim, sair',
          funtion: () async => await sairDaConta(context),
          isLoading: _isLoading,
          enabled: !_isLoading,
          backgroundColor: AppColors.secundaryColor,
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: 'Não, cancelar',
          funtion: () => Navigator.pop(context),
          isLoading: _isLoading,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Future<void> sairDaConta(BuildContext context) async {
    try {
      setLoading(true);
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } catch (e) {
      CustomSnackbar.show(context,
          'Não foi possível sair da conta. Tente novamente mais tarde!');
    } finally {
      setLoading(false);
    }
  }
}
