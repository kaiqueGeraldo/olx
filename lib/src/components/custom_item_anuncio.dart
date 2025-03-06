import 'package:flutter/material.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:olx/src/utils/colors.dart';

class ItemAnuncio extends StatelessWidget {
  final Anuncio anuncio;
  final VoidCallback onTapItem;
  final VoidCallback? onTapRemove;
  const ItemAnuncio(
    this.anuncio,
    this.onTapItem, {
    this.onTapRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
        color: Colors.white60,
        elevation: 25,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: SizedBox(
              width: 55,
              height: 55,
              child: (anuncio.fotos != null && anuncio.fotos!.isNotEmpty)
                  ? Image.network(
                      anuncio.fotos![0],
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 55,
                      height: 55,
                      color: AppColors.whiteColor,
                    ),
            ),
            title: Text(anuncio.titulo!),
            subtitle: Text(anuncio.preco!),
            // ignore: unnecessary_null_comparison
            trailing: onTapRemove != null
                ? IconButton(
                    onPressed: onTapRemove,
                    icon: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.red,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
