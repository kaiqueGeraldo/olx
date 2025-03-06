import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/models/lista_categoria.dart';
import 'package:olx/src/utils/colors.dart';

class Configuracoes {
  static List<DropdownMenuItem<String>> getCategorias() {
    List<DropdownMenuItem<String>> itensDropCategorias = [];

    itensDropCategorias.add(
      DropdownMenuItem(
        value: "",
        child: Text(
          'Categoria',
          style: TextStyle(color: AppColors.primaryColor),
        ),
      ),
    );

    itensDropCategorias.addAll(
      ListaCategoria.categorias.map((categoria) {
        return DropdownMenuItem<String>(
          value: categoria.value,
          child: Text(categoria.text),
        );
      }).toList(),
    );

    return itensDropCategorias;
  }

  static List<DropdownMenuItem<String>> getEstados() {
    List<DropdownMenuItem<String>> itensDropEstados = [];

    itensDropEstados.add(
      DropdownMenuItem(
        value: "",
        child: Text(
          'Região',
          style: TextStyle(color: AppColors.primaryColor),
        ),
      ),
    );

    itensDropEstados.addAll(
      Estados.listaEstadosSigla.map((estado) {
        return DropdownMenuItem<String>(
          value: estado,
          child: Text(estado),
        );
      }).toList(),
    );

    return itensDropEstados;
  }
}
