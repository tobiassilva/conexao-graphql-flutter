import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';

class Functions {

  HasuraConnect _conexao = HasuraConnect('http://aplicativoteste1.herokuapp.com/v1/graphql');

  String _deleteString(codigo){
    return """
    mutation MyMutation {
      delete_tabela_post(where: {codigo: {_eq: $codigo}}) {
        returning {
          codigo
          nome
          valor
        }
      }
    }""";
  }

  Future deleteInfo(codigo){

    var snapshot = _conexao.mutation(_deleteString(codigo));

    snapshot.then((value) {
      print(value);
    });

  }

}