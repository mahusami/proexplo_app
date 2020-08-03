import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:proapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecuperapwdPage extends StatefulWidget {
  @override
  _RecuperapwdPageState createState() => _RecuperapwdPageState();
}

class _RecuperapwdPageState extends State<RecuperapwdPage> {

  bool _isLoading = false;
  String URL = "https://admin.proexplo.com.pe/rest";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:  new ExactAssetImage('assets/images/fondob.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            Container(
                height: 230,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:  new ExactAssetImage('assets/images/login.png'),
                    fit: BoxFit.cover,
                  ),
                )),
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  registerIn(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email
    };

    var jsonResponse = null;
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    HttpClientRequest request1 = await client.postUrl(Uri.parse(URL+"/recpwd"));
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

  Container buttonSection() {
    return Container(
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
        child: Text("Enviar Email", style: TextStyle(color: Colors.black87)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();



  final FocusNode _emaFocus = FocusNode();



  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[

          TextFormField(
            controller: emailController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.done,
            focusNode: _emaFocus,

            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _emaFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              icon: Icon(Icons.email, color: Colors.black87),
              hintText: "Email",
              labelText: 'Email',
              border:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                      width: 2,color: Colors.black12
                  )),

              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                      width: 2,color:Colors.deepOrange
                  )),
              hintStyle: TextStyle(color: Colors.black87),
            ),
          ),
          SizedBox(height: 15.0),

        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Recuperar Contraseña",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black87,
              fontSize: 15.0,

              fontWeight: FontWeight.bold)),
    );
  }
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}