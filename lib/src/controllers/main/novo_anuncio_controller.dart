import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/src/components/custom_show_modal_button.dart';
import 'package:olx/src/components/custom_snackbar.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:olx/src/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:olx/src/utils/configuracoes.dart';

class NovoAnuncioController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  String itemSelecionadoEstado = '';
  String itemSelecionadoCategoria = '';
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();
  final List<XFile> listaImagens = [];
  late Anuncio anuncio;
  late BuildContext dialogContext;

  List<DropdownMenuItem<String>> listaEstados = [];
  List<DropdownMenuItem<String>> listaCategorias = [];

  void carregarItensDropdown() {
    listaCategorias = Configuracoes.getCategorias();
    listaEstados = Configuracoes.getEstados();
  }

  Future<void> selecionarImagem(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);

    isLoading = true;
    notifyListeners();

    if (image != null) {
      if (!listaImagens.any((img) => img.path == image.path)) {
        if (listaImagens.length < 5) {
          listaImagens.add(image);
          notifyListeners();
        } else {
          debugPrint('Limite de imagens atingido');
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void mostrarModalSelecao(BuildContext context) {
    CustomShowModalButton.show(
      context: context,
      title: 'Selecionar Imagem',
      children: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera, color: AppColors.greyColor),
            title: Text('Câmera', style: TextStyle(color: AppColors.greyColor)),
            onTap: () {
              Navigator.pop(context);
              selecionarImagem(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.image, color: AppColors.greyColor),
            title:
                Text('Galeria', style: TextStyle(color: AppColors.greyColor)),
            onTap: () {
              Navigator.pop(context);
              selecionarImagem(ImageSource.gallery);
            },
          ),
        ],
      ),
      isLoading: isLoading,
    );
  }

  void excluirImagem(BuildContext context, int index) {
    if (index < 0 || index >= listaImagens.length) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(listaImagens[index].path)),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.075,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.primaryColor),
                    foregroundColor:
                        WidgetStatePropertyAll(AppColors.whiteColor),
                    shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))))),
                onPressed: () {
                  if (index < listaImagens.length) {
                    removerImagem(index);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Excluir'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removerImagem(int index) {
    listaImagens.removeAt(index);
    notifyListeners();
  }

  static const String imgbbApiKey = "7cc8f508cdde60681f32b0e9c07e5cfa";

  Future<String?> _uploadParaImgBB(
      BuildContext context, Uint8List imageBytes) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://api.imgbb.com/1/upload?key=$imgbbApiKey"),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'upload.jpg',
        ),
      );

      var response = await request.send();

      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);

      if (response.statusCode == 200 && jsonData['success'] == true) {
        return jsonData['data']['url'];
      } else {
        CustomSnackbar.show(
            context, 'Erro no upload: ${jsonData['error']['message']}');
        return null;
      }
    } catch (e) {
      CustomSnackbar.show(context, 'Erro ao enviar imagem para ImgBB: $e');
      return null;
    }
  }

  void salvarAnuncio(BuildContext context) async {
    _abrirDialog(dialogContext);
    await _uploadDadosAnuncio(context);
  }

  Future<void> _uploadDadosAnuncio(BuildContext context) async {
    if (listaImagens.isEmpty) return;

    isLoading = true;
    notifyListeners();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    String idUsuario = usuarioLogado!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference anuncioRef = db
        .collection('meus_anuncios')
        .doc(idUsuario)
        .collection('anuncios')
        .doc(anuncio.id);
    DocumentReference anuncioPublicoRef =
        db.collection('anuncios').doc(anuncio.id);

    try {
      var docSnapshot = await anuncioRef.get();
      if (!docSnapshot.exists) {
        await anuncioRef
            .set(anuncio.toMap(), SetOptions(merge: true))
            .then((_) async {
          await anuncioPublicoRef.set(
            anuncio.toMap(),
            SetOptions(merge: true),
          );
        });
      }

      List<String> urlsImagens = [];

      for (var imagem in listaImagens) {
        try {
          Uint8List imageBytes = await imagem.readAsBytes();
          String? imageUrl = await _uploadParaImgBB(context, imageBytes);

          if (imageUrl != null) {
            urlsImagens.add(imageUrl);
          } else {
            debugPrint('Erro ao fazer upload da imagem ${imagem.path}');
          }
        } catch (e) {
          debugPrint('Erro ao processar a imagem ${imagem.path}: $e');
        }
      }

      if (urlsImagens.isNotEmpty) {
        await anuncioRef.update({
          'fotos': FieldValue.arrayUnion(urlsImagens),
        });
        await anuncioPublicoRef.update({
          'fotos': FieldValue.arrayUnion(urlsImagens),
        });

        Navigator.pop(dialogContext);

        CustomSnackbar.show(
          context,
          'Anúncio cadastrado com sucesso!',
          backgroundColor: Colors.green,
        );

        Navigator.pop(context);
      }
    } catch (e) {
      CustomSnackbar.show(context, 'Erro ao verificar/criar o anúncio: $e');
      debugPrint('Erro ao verificar/criar o anúncio: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void _abrirDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Salvando anúncio...'),
          ],
        ),
      ),
    );
  }
}
