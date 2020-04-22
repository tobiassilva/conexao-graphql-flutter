import 'package:flutter/material.dart';
import 'package:flutter_app_teste/post/post_page.dart';
import 'package:hasura_connect/hasura_connect.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  HasuraConnect _conexao = HasuraConnect('http://aplicativoteste1.herokuapp.com/v1/graphql');

  bool carregamento = false;

  @override
  void initState(){
    super.initState();

    this.carregamentoFuncao();
  }

  Future carregamentoFuncao() async {

    await getDados();

    setState(() {
      carregamento = true;
    });

  }

  var tabela;

  Future getDados() async {

    var snapshot = _conexao.subscription(subcriptionTabela);

    snapshot.listen((data){
      print(data);
      setState(() {
        tabela = data['data'];
      });
    });

  }

  String subcriptionTabela = """
    subscription {
      tabela_post {
        codigo
        nome
        valor
      }
    }
  """;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldState,
        backgroundColor: Colors.white,
        body: carregamento == false ? Center(
          child: CircularProgressIndicator(
            //backgroundColor: Colors.deepOrange,
          ),
        )
        : Column(
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
                  child: ListView.builder(
                      itemCount: tabela['tabela_post'].length,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('${index+1}. ${tabela['tabela_post'][index]['nome']}',
                                  style: TextStyle(fontSize: 15, ),
                                ),
                                Text('${tabela['tabela_post'][index]['valor']}'),
                              ],
                            ),
                            Divider(
                              height: 10,
                            ),
                          ],
                        );
                      }
                  ),
                ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,

                  ),
                  child: FlatButton(

                    onPressed: () async {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => postPage())
                      );
                    },
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            "  Inserir novos dados",
                            style: TextStyle(color: Colors.white),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
