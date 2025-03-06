class ListaCategoria {
  String text;
  String value;

  ListaCategoria(this.text, this.value);

  static List<ListaCategoria> categorias = [
    ListaCategoria("Automóvel", "auto"),
    ListaCategoria("Imóvel", "imovel"),
    ListaCategoria("Eletrônicos", "eletro"),
    ListaCategoria("Moda", "moda"),
    ListaCategoria("Esportes", "esportes"),
  ];
}
