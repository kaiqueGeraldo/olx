import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx/src/components/custom_button.dart';
import 'package:olx/src/components/custom_input_text.dart';
import 'package:olx/src/components/custom_text_area.dart';
import 'package:olx/src/controllers/main/novo_anuncio_controller.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:olx/src/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncioPage extends StatefulWidget {
  const NovoAnuncioPage({super.key});

  @override
  State<NovoAnuncioPage> createState() => _NovoAnuncioPageState();
}

class _NovoAnuncioPageState extends State<NovoAnuncioPage> {
  @override
  void initState() {
    super.initState();
    final controller =
        Provider.of<NovoAnuncioController>(context, listen: false);
    controller.carregarItensDropdown();
    controller.tituloController.clear();
    controller.precoController.clear();
    controller.telefoneController.clear();
    controller.descricaoController.clear();
    controller.listaImagens.clear();
    controller.anuncio = Anuncio.gerarId();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NovoAnuncioController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Anúncio')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: controller.listaImagens,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Necessário selecionar ao menos uma imagem';
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.listaImagens.length < 5
                                ? controller.listaImagens.length + 1
                                : controller.listaImagens.length,
                            itemBuilder: (context, index) {
                              if (index == controller.listaImagens.length) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () => controller.isLoading
                                        ? null
                                        : controller
                                            .mostrarModalSelecao(context),
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.greyColor,
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            'Adicionar',
                                            style: TextStyle(
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.isLoading
                                        ? null
                                        : controller.excluirImagem(
                                            context, index);
                                  },
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(
                                      File(controller.listaImagens[index].path),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.2),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (field.hasError)
                          Center(
                            child: Text('${field.errorText}',
                                style: TextStyle(color: Colors.red[800])),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          hint: controller.listaEstados[0],
                          items: controller.listaEstados,
                          onChanged: (value) =>
                              controller.itemSelecionadoEstado = value!,
                          onSaved: (estado) =>
                              controller.anuncio.estado = estado,
                          validator: (value) => Validador()
                              .add(
                                Validar.OBRIGATORIO,
                                msg: 'Campo Obrigatório',
                              )
                              .valido(value)
                              ?.replaceAll('[', '')
                              .replaceAll(']', ''),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          hint: controller.listaCategorias[0],
                          items: controller.listaCategorias,
                          onChanged: (value) =>
                              controller.itemSelecionadoCategoria = value!,
                          onSaved: (categoria) =>
                              controller.anuncio.categoria = categoria,
                          validator: (value) => Validador()
                              .add(
                                Validar.OBRIGATORIO,
                                msg: 'Campo Obrigatório',
                              )
                              .valido(value)
                              ?.replaceAll('[', '')
                              .replaceAll(']', ''),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomInputText(
                  controller: controller.tituloController,
                  enable: !controller.isLoading,
                  hintText: 'Título',
                  keyboardType: TextInputType.text,
                  onSaved: (titulo) => controller.anuncio.titulo = titulo,
                  validator: (value) {
                    return Validador()
                        .add(
                          Validar.OBRIGATORIO,
                          msg: 'Campo Obrigatório',
                        )
                        .valido(value)
                        ?.replaceAll('[', '')
                        .replaceAll(']', '');
                  },
                ),
                const SizedBox(height: 10),
                CustomInputText(
                  controller: controller.precoController,
                  enable: !controller.isLoading,
                  hintText: 'Preço',
                  keyboardType: TextInputType.number,
                  onSaved: (preco) => controller.anuncio.preco = preco,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true),
                  ],
                  validator: (value) {
                    return Validador()
                        .add(
                          Validar.OBRIGATORIO,
                          msg: 'Campo Obrigatório',
                        )
                        .valido(value)
                        ?.replaceAll('[', '')
                        .replaceAll(']', '');
                  },
                ),
                const SizedBox(height: 10),
                CustomInputText(
                  controller: controller.telefoneController,
                  enable: !controller.isLoading,
                  hintText: 'Telefone de Contato',
                  keyboardType: TextInputType.number,
                  onSaved: (telefone) => controller.anuncio.telefone = telefone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  validator: (value) {
                    return Validador()
                        .add(
                          Validar.OBRIGATORIO,
                          msg: 'Campo Obrigatório',
                        )
                        .valido(value)
                        ?.replaceAll('[', '')
                        .replaceAll(']', '');
                  },
                ),
                const SizedBox(height: 10),
                CustomTextArea(
                  controller: controller.descricaoController,
                  enable: !controller.isLoading,
                  hintText: 'Descrição',
                  hintStyle: TextStyle(color: AppColors.greyColor),
                  textColor: AppColors.blackColor,
                  maxLength: 200,
                  onSaved: (descricao) =>
                      controller.anuncio.descricao = descricao,
                  validator: (value) {
                    return Validador()
                        .add(
                          Validar.OBRIGATORIO,
                          msg: 'Campo Obrigatório',
                        )
                        .valido(value)
                        ?.replaceAll('[', '')
                        .replaceAll(']', '');
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Cadastrar Anúncio',
                  funtion: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.formKey.currentState!.save();
                      controller.dialogContext = context;
                      controller.salvarAnuncio(context);
                    }
                  },
                  isLoading: controller.isLoading,
                  enabled: !controller.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
