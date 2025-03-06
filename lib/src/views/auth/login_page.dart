import 'package:flutter/material.dart';
import 'package:olx/src/components/custom_button.dart';
import 'package:olx/src/components/custom_input_text.dart';
import 'package:olx/src/controllers/auth/login_controller.dart';
import 'package:olx/src/utils/colors.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);

    return Scaffold(
      appBar: AppBar(),
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
                  child: Column(
                    children: [
                      CustomInputText(
                        controller: controller.emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        isLoading: controller.isLoading,
                        errorText: controller.hasError
                            ? 'Email ou senha incorretos'
                            : null,
                        onChanged: (value) => controller.setError(false),
                      ),
                      const SizedBox(height: 10),
                      CustomInputText(
                        controller: controller.senhaController,
                        hintText: 'Senha',
                        keyboardType: TextInputType.text,
                        isLoading: controller.isLoading,
                        isPassword: true,
                        obscureText: controller.isPassword,
                        errorText: controller.hasError
                            ? 'Email ou senha incorretos'
                            : null,
                        onChanged: (value) => controller.setError(false),
                        onSuffixIconPressed:
                            controller.togglePasswordVisibility,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => controller.isLoading
                              ? null
                              : Navigator.pushNamed(
                                  context,
                                  '/redefinir-senha',
                                ),
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text: 'Entrar',
                        funtion: () => controller.login(context),
                        isLoading: controller.isLoading,
                        enabled: !controller.isLoading,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem uma conta?'),
                    const SizedBox(width: 5),
                    GestureDetector(
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                      onTap: () {
                        controller.isLoading
                            ? null
                            : Navigator.pushNamed(
                                context,
                                '/cadastro',
                              );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
