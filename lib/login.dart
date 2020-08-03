import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:passwordfield/passwordfield.dart';
import 'package:proapp/main.dart';
import 'package:proapp/register.dart';
import 'package:proapp/recuperapwd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;
  bool passwordVisible=true;
  String URL = "https://admin.proexplo.com.pe/rest";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      resizeToAvoidBottomInset : false,

      body: Container(

          decoration: BoxDecoration(
            image: DecorationImage(
              image:  new ExactAssetImage('assets/images/fondob.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            //headerSection(),
            logoSection(),
            textSection(),
            buttonSection(),

            //btnregisterSection(),
          ],
        ),
      ),
    );
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': pass
    };
    var jsonResponse = null;
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);


    HttpClientRequest request = await client.postUrl(Uri.parse(URL+"/login"));

    request.headers.set('content-type', 'application/json');

    request.add(utf8.encode(json.encode(data)));

    HttpClientResponse response = await request.close();

    String respuestajson = await response.transform(utf8.decoder).join();


    if(response.statusCode == 200) {
      jsonResponse = json.decode(respuestajson);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        if(jsonResponse['IND_OPERACION']=="1") {

          sharedPreferences.setString("idioma", "1");
          sharedPreferences.setString("token", jsonResponse['ID_USER']);
          sharedPreferences.setString("tokentipo", jsonResponse['TIPO']);
          sharedPreferences.setString("tokenfec1", jsonResponse['FEC1']);
          sharedPreferences.setString("tokentfec1", jsonResponse['TFEC1']);
          sharedPreferences.setString("tokenttfec1", jsonResponse['TTFEC1']);
          sharedPreferences.setString("tokenfec2", jsonResponse['FEC2']);
          sharedPreferences.setString("tokentfec2", jsonResponse['TFEC2']);
          sharedPreferences.setString("tokenttfec2", jsonResponse['TTFEC2']);
          sharedPreferences.setString("tokenfec3", jsonResponse['FEC3']);
          sharedPreferences.setString("tokentfec3", jsonResponse['TFEC3']);
          sharedPreferences.setString("tokenttfec3", jsonResponse['TTFEC3']);
          sharedPreferences.setString("linkferia", jsonResponse['LINKFERIA']);

          Fluttertoast.showToast(
              msg: jsonResponse['DES_MENSAJE'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1
          );
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (BuildContext context) => MainPage()), (
              Route<dynamic> route) => false);
        }else{
          //datos incorrectos
          setState(() {
            _isLoading = false;
          });
          print(jsonResponse['DES_MENSAJE']);
          Fluttertoast.showToast(
              msg: jsonResponse['DES_MENSAJE'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1
          );
        }
       }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      //print(response.);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
          setState(() {
            _isLoading = true;
          });
          signIn(emailController.text, passwordController.text);
        },
        elevation: 0.0,
        color: Colors.deepOrangeAccent,
        child: Text("INGRESAR", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),

    );
  }
  Container btnregisterSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (BuildContext context) => RegisterPage()), (
              Route<dynamic> route) => false);
        },
        elevation: 0.0,
        color: Colors.deepOrangeAccent,
        child: Text("Registrarse", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),

    );
  }
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final FocusNode _emaFocus = FocusNode();
  final FocusNode _claveFocus = FocusNode();
  final FocusNode _butonFocus = FocusNode();

  Container logoSection(){
    return Container(

        height: 230,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
        decoration: BoxDecoration(
        image: DecorationImage(
        image: new ExactAssetImage('assets/images/login.png'),
    fit: BoxFit.cover,
    ),
    ));
  }
  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black,height: 1,fontSize: 14.0),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            focusNode: _emaFocus,
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _emaFocus, _claveFocus);
            },

            decoration: InputDecoration(
              hintText: "Email",
              border:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 2,color: Colors.black12
                  )),

              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                      width: 2,color:Colors.black12
                  ))
            ),
          ),
          SizedBox(height: 15.0),
          /*PasswordField(
            controller: passwordController,
            inputStyle: TextStyle(fontSize: 14.0),
            focusedBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                    width: 2,color:Colors.black12
                )) ,
            suffixIcon: Icon(
              Icons.remove_red_eye,
              color: Colors.black,
            ),
            textPadding: EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 2,color:Colors.black12
                )),
            hintText: "Contraseña",
          ),*/
        TextFormField(
          style: TextStyle(color: Colors.black,height: 1,fontSize: 14.0),
          keyboardType: TextInputType.text,
          controller: passwordController,
          obscureText: passwordVisible,//This will obscure text dynamically
          decoration: InputDecoration(
            hintText: 'Contraseña',
            border:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                    width: 2,color: Colors.black12
                )),

            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                    width: 2,color:Colors.black12
                )),
// Here is key idea
            suffixIcon: IconButton(
              icon: Icon(
// Based on passwordVisible state choose the icon
                passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.black12
              ),
              onPressed: () {
// Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
        ),
          new FlatButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (BuildContext context) => (RecuperapwdPage())), (
                    Route<dynamic> route) => true);
              },child: new Text("¿Olvidó su contraseña?")

          ),new FlatButton(
              onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (BuildContext context) => RegisterPage()), (
                Route<dynamic> route) => true);
          },child: new Text("Registrate aquí")

          )
        ],
      ),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 95.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
      child: Text("ProExplo",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black,
              fontSize: 45.0,

              fontWeight: FontWeight.bold)),
    );
  }
}