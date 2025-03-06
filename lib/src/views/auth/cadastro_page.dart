import 'package:flutter/material.dart';
import 'package:olx/src/components/custom_button.dart';
import 'package:olx/src/components/custom_input_text.dart';
import 'package:olx/src/controllers/auth/cadastro_controller.dart';
import 'package:provider/provider.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CadastroController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo_no_bkg.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomInputText(
                        controller: controller.nomeController,
                        hintText: 'Nome',
                        keyboardType: TextInputType.name,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Este campo é obrigatório!'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      CustomInputText(
                        controller: controller.emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo é obrigatório!';
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          return emailRegex.hasMatch(value)
                              ? null
                              : 'Informe um email válido!';
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomInputText(
                        controller: controller.senhaController,
                        hintText: 'Senha',
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        obscureText: controller.isPassword,
                        focusNode: controller.senhaFocusNode,
                        onSuffixIconPressed:
                            controller.togglePasswordVisibility,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo é obrigatório!';
                          }
                          if (controller.hasUpperCase &&
                              controller.hasLowerCase &&
                              controller.hasNumber &&
                              controller.hasSpecialChar &&
                              controller.hasMinLength) {
                            return null;
                          }
                          return 'A senha não atende todos os critérios!';
                        },
                        onChanged: controller.validarSenha,
                      ),
                      const SizedBox(height: 5),
                      if (controller.showPasswordCriteria)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPasswordCriteria('Pelo menos 8 caracteres',
                                  controller.hasMinLength),
                              _buildPasswordCriteria('Uma letra maiúscula',
                                  controller.hasUpperCase),
                              _buildPasswordCriteria('Uma letra minúscula',
                                  controller.hasLowerCase),
                              _buildPasswordCriteria(
                                  'Um número', controller.hasNumber),
                              _buildPasswordCriteria(
                                  'Um caractere especial (!@#\$&*~)',
                                  controller.hasSpecialChar),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text: 'Cadastrar',
                        funtion: () =>
                            controller.cadastrar(context, _formKey),
                        isLoading: controller.isLoading,
                        enabled: !controller.isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordCriteria(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red[800],
          size: 14,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red[800],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
