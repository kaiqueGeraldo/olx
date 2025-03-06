import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx/src/components/custom_button.dart';
import 'package:olx/src/components/custom_item_anuncio.dart';
import 'package:olx/src/components/custom_show_modal_button.dart';
import 'package:olx/src/components/custom_snackbar.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:olx/src/models/usuario.dart';
import 'package:olx/src/utils/colors.dart';
import 'package:olx/src/utils/configuracoes.dart';

class HomeController extends ChangeNotifier {
  Usuario? usuarioLogado;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String itemSelecionadoEstado = '';
  String itemSelecionadoCategoria = '';
  List<DropdownMenuItem<String>> listaEstados = [];
  List<DropdownMenuItem<String>> listaCategorias = [];
  final _controller = StreamController.broadcast();
  StreamSubscription<QuerySnapshot>? _subscription;

  HomeController() {
    carregarItensDropdown();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    verificarUsuarioLogado();
    adicionarListenerAnuncios();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
    super.dispose();
  }

  void carregarItensDropdown() {
    listaCategorias = Configuracoes.getCategorias();
    listaEstados = Configuracoes.getEstados();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> verificarUsuarioLogado() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final User? user = auth.currentUser;
      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await firestore.collection('usuarios').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          usuarioLogado = Usuario.fromMap(userDoc.data()!);
        } else {
          debugPrint("Usuário logado, mas sem dados no Firestore.");
          usuarioLogado = null;
        }
      } else {
        usuarioLogado = null;
      }
    } catch (e) {
      debugPrint("Erro ao verificar usuário logado: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> adicionarListenerAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection('anuncios').snapshots();

    _subscription = stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future<void> filtrarAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection('anuncios');

    if (itemSelecionadoEstado.isNotEmpty) {
      query = query.where('estado', isEqualTo: itemSelecionadoEstado);
    }

    if (itemSelecionadoCategoria.isNotEmpty) {
      query = query.where('categoria', isEqualTo: itemSelecionadoCategoria);
    }

    await _subscription?.cancel();

    Stream<QuerySnapshot> stream = query.snapshots();
    _subscription = stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Widget carregarAnuncios() {
    return Expanded(
      child: StreamBuilder(
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
              );
            },
          );
        },
      ),
    );
  }

  void confirmarSair(BuildContext context) {
    CustomShowModalButton.show(
      context: context,
      title: 'Sair da Conta',
      children: _contentSairConta(context),
      isLoading: _isLoading,
    );
  }

  Widget _contentSairConta(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deseja realmente sair da sua conta?',
          style: TextStyle(color: AppColors.greyColor),
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: 'Sim, sair',
          funtion: () async => await sairDaConta(context),
          isLoading: _isLoading,
          enabled: !_isLoading,
          backgroundColor: AppColors.secundaryColor,
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: 'Não, cancelar',
          funtion: () => Navigator.pop(context),
          isLoading: _isLoading,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Future<void> sairDaConta(BuildContext context) async {
    try {
      setLoading(true);
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } catch (e) {
      CustomSnackbar.show(context,
          'Não foi possível sair da conta. Tente novamente mais tarde!');
    } finally {
      setLoading(false);
    }
  }
}
