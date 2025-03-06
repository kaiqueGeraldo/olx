import 'package:flutter/material.dart';
import 'package:olx/src/components/custom_end_drawer_button.dart';
import 'package:olx/src/controllers/main/home_controller.dart';
import 'package:olx/src/utils/colors.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatefulWidget {
  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final controller = Provider.of<HomeController>(context, listen: false);
      controller.verificarUsuarioLogado();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          drawer: Drawer(
            width: MediaQuery.sizeOf(context).width * 0.7,
            backgroundColor: AppColors.whiteColor,
            child: controller.usuarioLogado == null
                ? const Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomEndDrawerButton(),
                  )
                : Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: DrawerHeader(
                          decoration:
                              BoxDecoration(color: AppColors.primaryColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Text(
                                  controller.usuarioLogado!.nome![0]
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                controller.usuarioLogado!.nome!,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                controller.usuarioLogado!.email!,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.library_books_rounded),
                        title: const Text("Meus Anúncios"),
                        onTap: () {
                          Navigator.pushNamed(context, '/meus-anuncios');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text("Configurações"),
                        onTap: () {
                          Navigator.pushNamed(context, '/configuracoes');
                        },
                      ),
                      const Spacer(),
                      CustomEndDrawerButton(
                        isLogout: true,
                        onTap: () {
                          Navigator.pop(context);
                          controller.confirmarSair(context);
                        },
                      ),
                    ],
                  ),
          ),
          appBar: AppBar(
            title: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "O",
                    style: TextStyle(color: Color(0xFFF1F1F1)), // Branco
                  ),
                  TextSpan(
                    text: "L",
                    style: TextStyle(color: Color(0xFF2ABF2F)), // Verde
                  ),
                  WidgetSpan(
                      child: SizedBox(
                    width: 1.5,
                  )),
                  TextSpan(
                    text: "X",
                    style: TextStyle(color: Color(0xFFF55F15)), // Laranja
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 49),
                        menuWidth: MediaQuery.of(context).size.width * 0.4,
                        iconEnabledColor: AppColors.primaryColor,
                        value: controller.itemSelecionadoEstado.isNotEmpty
                            ? controller.itemSelecionadoEstado
                            : null,
                        hint: controller.listaEstados[0],
                        items: controller.listaEstados,
                        onChanged: (value) {
                          setState(() {
                            controller.itemSelecionadoEstado = value!;
                          });
                          controller.filtrarAnuncios();
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 50,
                    color: AppColors.greyColor.withOpacity(0.2),
                  ),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        menuWidth: MediaQuery.of(context).size.width * 0.4,
                        iconEnabledColor: AppColors.primaryColor,
                        value: controller.itemSelecionadoCategoria.isNotEmpty
                            ? controller.itemSelecionadoCategoria
                            : null,
                        hint: controller.listaCategorias[0],
                        items: controller.listaCategorias,
                        onChanged: (value) {
                          setState(() {
                            controller.itemSelecionadoCategoria = value!;
                          });
                          controller.filtrarAnuncios();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              controller.carregarAnuncios(),
            ],
          ),
        );
      },
    );
  }
}
