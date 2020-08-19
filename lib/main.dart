import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'future.dart';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double _dolar;
  double _euro;
  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChange(String txtAlterado) {
    if (txtAlterado.isEmpty || txtAlterado == "0") {
      _clearAll();
    } else {
      double real = double.parse(txtAlterado);
      dolarController.text = (real / this._dolar).toStringAsFixed(2);
      euroController.text = (real / this._euro).toStringAsFixed(2);
    }
  }

  void _dolarChange(String txtAlterado) {
    if (txtAlterado.isEmpty || txtAlterado == "0") {
      _clearAll();
    } else {
      double dolar = double.parse(txtAlterado);
      realController.text = (dolar * this._dolar).toStringAsFixed(2);
      euroController.text = (dolar * this._dolar / _euro).toStringAsFixed(2);
    }
  }

  void _euroChange(String txtAlterado) {
    if (txtAlterado.isEmpty || txtAlterado == "0") {
      _clearAll();
    } else {
      double euro = double.parse(txtAlterado);
      realController.text = (euro * this._euro).toStringAsFixed(2);
      dolarController.text =
          (euro * this._euro / this._dolar).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("\$ Conversor de Moedas \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar os Dados",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                _dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                _euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 200.0,
                        color: Colors.amber,
                      ),
                      buildTextField(
                          "Real", "R\$", realController, _realChange),
                      Divider(),
                      buildTextField(
                          "Dolar", "\$", dolarController, _dolarChange),
                      Divider(),
                      buildTextField("Euro", "EUR", euroController, _euroChange)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
