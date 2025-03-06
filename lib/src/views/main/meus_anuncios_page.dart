import 'package:flutter/material.dart';

import 'package:olx/src/controllers/main/meus_anuncios_controller.dart';
import 'package:olx/src/utils/colors.dart';
import 'package:provider/provider.dart';

class MeusAnunciosPage extends StatefulWidget {
  const MeusAnunciosPage({super.key});

  @override
  State<MeusAnunciosPage> createState() => _MeusAnunciosPageState();
}

class _MeusAnunciosPageState extends State<MeusAnunciosPage> {
  @override
  void initState() {
    super.initState();
    final controller =
        Provider.of<MeusAnunciosController>(context, listen: false);
    controller.adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MeusAnunciosController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Anúncios'),
      ),
      body: controller.carregarAnuncios(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 4,
        isExtended: true,
        onPressed: () {
          Navigator.pushNamed(context, '/novo-anuncio');
        },
        label: const Text('Adicionar'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
