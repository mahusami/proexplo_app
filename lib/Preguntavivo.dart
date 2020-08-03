import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:proapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Preguntavivo extends StatefulWidget {
  final idprograma;
  final title;
  Preguntavivo(this.idprograma,this.title);
  @override
  _PreguntavivoState createState() => _PreguntavivoState(this.idprograma,this.title);
}

class _PreguntavivoState extends State<Preguntavivo> {
  var _idprograma;
  var _title;
  _PreguntavivoState(this._idprograma,this._title);
  bool _isLoading = false;
  String URL = "https://admin.proexplo.com.pe/rest";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Container(
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),

          ],
        ),
      ),
    );
  }

  registerIn(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usuario=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();
    Map data = {
      'pregunta': email,
       'idioma':IDIOMA,
       'usuario':usuario,
       'programa':_idprograma
    };

    var jsonResponse = null;
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    HttpClientRequest request1 = await client.postUrl(Uri.parse(URL+"/regpregunta"));
    request1.headers.set('content-type', 'application/json');
    request1.add(utf8.encode(json.encode(data)));
    HttpClientResponse response1 = await request1.close();
    String respuestajson1 = await response1.transform(utf8.decoder).join();


    if(response1.statusCode == 200) {
      jsonResponse = json.decode(respuestajson1);
      if(jsonResponse != null) {
        if(jsonResponse['IND_OPERACION']=="1") {
          // si se registra Hacemos login aut.
          Fluttertoast.showToast(
              msg: jsonResponse['DES_MENSAJE'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1
          );

          setState(() {
            _isLoading = false;
          });
        }else {
          // si no se registro y tiro error
          Fluttertoast.showToast(
              msg: jsonResponse['DES_MENSAJE'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1
          );

          setState(() {
            _isLoading = false;
          });
        }
      }else{
        setState(() {
          _isLoading = false;
        });
      }
    }

  }



  final TextEditingController emailController = new TextEditingController();



  final FocusNode _emaFocus = FocusNode();



  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[

          new TextField(
            keyboardType: TextInputType.multiline,
            controller: emailController,
            cursorColor: Colors.black87,
            minLines: 1,
            maxLines: 10

          ),
          SizedBox(height: 2.0),
          new Container(
            width: MediaQuery.of(context).size.width,
            height: 40.0,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            margin: EdgeInsets.only(top: 15.0),
            child: RaisedButton(
              onPressed: emailController.text == ""  ? null : () {
                setState(() {
                  _isLoading = true;
                });
                registerIn(emailController.text);
              },
              elevation: 0.0,
              color: Colors.orange,
              child: Text("Enviar", style: TextStyle(color: Colors.black87)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          )
        ,new Container(height: 70,)
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Pregunta en vivo",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black87,
              fontSize: 20.0,
              fontWeight: FontWeight.bold)),
    );
  }
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}