import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  String? id;
  String? estado;
  String? categoria;
  String? titulo;
  String? preco;
  String? telefone;
  String? descricao;
  List<String>? fotos;

  Anuncio();

  Anuncio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    estado = documentSnapshot['estado'];
    categoria = documentSnapshot['categoria'];
    titulo = documentSnapshot['titulo'];
    preco = documentSnapshot['preco'];
    telefone = documentSnapshot['telefone'];
    descricao = documentSnapshot['descricao'];
    fotos = List<String>.from(documentSnapshot['fotos']);
  }

  Anuncio.gerarId() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection('meus_anuncios');
    id = anuncios.doc().id;

    fotos = [];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'estado': estado,
      'categoria': categoria,
      'titulo': titulo,
      'preco': preco,
      'telefone': telefone,
      'descricao': descricao,
      'fotos': fotos,
    };
    return map;
  }
}
