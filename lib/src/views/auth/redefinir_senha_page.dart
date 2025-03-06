// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:olx/src/components/custom_button.dart';
import 'package:olx/src/components/custom_input_text.dart';
import 'package:olx/src/controllers/auth/redefinir_senha_controller.dart';
import 'package:provider/provider.dart';

class RedefinirSenhaPage extends StatelessWidget {
  const RedefinirSenhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RedefinirSenhaController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Redefinir Senha")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informe seu Email',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Digite seu email no campo abaixo para receber um link de redefinição de senha.',
                style: TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: CustomInputText(
                  controller: controller.emailController,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  enable: !controller.isLoading,
                  isLoading: controller.isLoading,
                  validator: controller.validarEmail,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  text: 'Enviar e-mail de redefinição',
                  funtion: () => controller.enviarRedefinicao(context),
                  isLoading: controller.isLoading,
                  enabled: !controller.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
