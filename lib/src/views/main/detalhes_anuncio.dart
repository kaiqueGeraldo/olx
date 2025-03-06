import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:olx/src/components/custom_button.dart';
import 'package:olx/src/components/custom_snackbar.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:olx/src/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAnuncio extends StatefulWidget {
  final Anuncio anuncio;
  const DetalhesAnuncio(this.anuncio, {super.key});

  @override
  State<DetalhesAnuncio> createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  void ligarTelefone(String? numero) async {
    if (numero == null || numero.isEmpty) {
      CustomSnackbar.show(context, 'Número inválido!');
      return;
    }

    final Uri uri = Uri.parse("tel:$numero");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      CustomSnackbar.show(context, 'Não foi possível realizar essa ação!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anúncio - ${widget.anuncio.titulo}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: widget.anuncio.fotos != null &&
                      widget.anuncio.fotos!.isNotEmpty
                  ? FlutterCarousel(
                      options: FlutterCarouselOptions(
                        height: 250,
                        showIndicator: true,
                        slideIndicator: CircularSlideIndicator(
                          slideIndicatorOptions: SlideIndicatorOptions(
                            currentIndicatorColor: AppColors.primaryColor,
                            indicatorBackgroundColor: AppColors.greyColor,
                          ),
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                      items: widget.anuncio.fotos!.map((fotoUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(
                                fotoUrl,
                                fit: BoxFit.fitWidth,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.broken_image,
                                        size: 50, color: Colors.red),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }).toList(),
                    )
                  : const Center(
                      child: Text(
                        'Nenhuma imagem disponível',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.anuncio.preco!,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.anuncio.titulo!,
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.anuncio.descricao!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Contato',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.anuncio.telefone!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(color: AppColors.whiteColor),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: CustomButton(
            text: 'Ligar',
            funtion: () {
              ligarTelefone(widget.anuncio.telefone);
            },
            isLoading: false,
            enabled: true,
          ),
        ),
      ),
    );
  }
}
