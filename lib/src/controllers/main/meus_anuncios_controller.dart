import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/components/custom_item_anuncio.dart';
import 'package:olx/src/components/custom_show_dialog.dart';
import 'package:olx/src/components/custom_snackbar.dart';
import 'package:olx/src/models/anuncio.dart';

class MeusAnunciosController extends ChangeNotifier {
  final _controller = StreamController.broadcast();
  String? idUsuario;

  Future<void> _recuperarDadosUsualioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    idUsuario = usuarioLogado!.uid;
  }

  Future<Stream<QuerySnapshot<Object?>>> adicionarListenerAnuncios() async {
    await _recuperarDadosUsualioLogado();
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection('meus_anuncios')
        .doc(idUsuario)
        .collection('anuncios')
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });

    return stream;
  }

  Widget carregarAnuncios() {
    return StreamBuilder(
      stream: _controller.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados!'));
        }

        if (!snapshot.hasData ||
            (snapshot.data! as QuerySnapshot).docs.isEmpty) {
          return const Center(child: Text('Não há anúncios disponíveis.'));
        }

        QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
        List<DocumentSnapshot> anuncios = querySnapshot.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: anuncios.length,
          itemBuilder: (context, index) {
            Anuncio anuncio = Anuncio.fromDocumentSnapshot(anuncios[index]);
            return ItemAnuncio(
              anuncio,
              () {
                Navigator.pushNamed(
                  context,
                  '/detalhes-anuncio',
                  arguments: anuncio,
                );
              },
              onTapRemove: () {
                confirmarExcluirAnuncio(context, anuncio.id);
              },
            );
          },
        );
      },
    );
  }

  void confirmarExcluirAnuncio(BuildContext context, String? idAnuncio) {
    customShowDialog(
      context: context,
      title: 'Excluir anúncio',
      content: const Text('Deseja mesmo excluir o anúncio?'),
      cancelText: 'Cancelar',
      cancelTextColor: Colors.red,
      onCancel: () => Navigator.pop(context),
      confirmText: 'Excluir',
      confirmTextColor: Colors.green,
      onConfirm: () {
        excluirAnuncio(context, idAnuncio);
        Navigator.pop(context);
      },
    );
  }

  void excluirAnuncio(BuildContext context, String? idAnuncio) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('meus_anuncios')
        .doc(idUsuario)
        .collection('anuncios')
        .doc(idAnuncio)
        .delete()
        .then((_) {
      db.collection('anuncios').doc(idAnuncio).delete().then((_) {
        CustomSnackbar.show(context, 'Anúncio excluído com sucesso!');
      });
    });
  }

  void pararListener() {
    _controller.close();
  }

  @override
  void dispose() {
    pararListener();
    super.dispose();
  }
}
