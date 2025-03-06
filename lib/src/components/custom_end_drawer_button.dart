import 'package:flutter/material.dart';

class CustomEndDrawerButton extends StatelessWidget {
  final bool isLogout;
  final VoidCallback? onTap;

  const CustomEndDrawerButton({super.key, this.isLogout = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(isLogout ? Icons.exit_to_app : Icons.login),
      title: Text(isLogout ? "Sair" : "Entrar/Cadastrar"),
      onTap: onTap ??
          () {
            Navigator.pushNamed(context, '/login');
          },
    );
  }
}
