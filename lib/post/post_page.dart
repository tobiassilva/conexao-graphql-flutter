import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';

class postPage extends StatefulWidget {
  @override
  _postPageState createState() => _postPageState();
}

class _postPageState extends State<postPage> {


  HasuraConnect conexao = HasuraConnect('https://aplicativoteste1.herokuapp.com/v1/graphql');

  @override
  void initState(){
    super.initState();

    this.getGraphql();

  }

  ///MÉTODO GET
  ///RECEBENDO DADOS DE TABELAS GRAPHQL
  ///
  ///

  void getGraphql() {
    var snapshot = conexao.subscription(variavelTabela);

    snapshot.listen((data) {
      print(data);
      print('${data["data"]["tabela_teste"][0]["nome"]}');
    });
  }

  String variavelTabela = """
    subscription {
      tabela_teste {
        codigo
        nome
      }
    }
  """;

  ///MÉTODO POST
  ///ENVIANDO DADOS PARA TABELAS GRAPHQL (HEROKU)
  ///
  ///

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nomeForm = TextEditingController();
  final valorForm = TextEditingController();

  Future<void> createState(nome, valor) async {
    var data = await conexao.mutation(query("$nome", "$valor"));

    print(data);
  }

  String query(nome, valor) {
    return (
        """
        mutation MyMutation {
          insert_tabela_post(objects: {nome: "$nome", valor: "$valor"}) {
            returning {
              codigo
              nome
              valor
            }
          }
        }
      """
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldState,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text('Nome: ', style: TextStyle(fontSize: 16),),

                    ],
                  ),
                ),
                TextFormField(
                  controller: nomeForm,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.left,
                  obscureText: false,
                  decoration: InputDecoration(
                    //border: InputBorder.none,
                    hintText: 'seu nome',
                    hintStyle: TextStyle(color: Colors.grey),
                    //labelText: 'Informe seu Nome'
                  ),
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Campo não pode ser vazio';
                    }
                  },
                ),

                SizedBox(height: 30,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text('Valor: ', style: TextStyle(fontSize: 16),),

                  ],
                ),


                TextFormField(
                  controller: valorForm,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    //border: InputBorder.none,
                    hintText: '10',
                    hintStyle: TextStyle(color: Colors.grey),

                  ),
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Campo não pode ser vazio';
                    }
                  },
                ),



                SizedBox(height: 30,),


                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,

                  ),
                  child: FlatButton(

                    onPressed: () async {
                      await createState(nomeForm.text, valorForm.text);

                      scaffoldState.currentState.showSnackBar(SnackBar(content: Text('Dados Enviados')));
                    },
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          Text(
                            "  Enviar",
                            style: TextStyle(color: Colors.white),
                          )
                        ]),
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }

}
