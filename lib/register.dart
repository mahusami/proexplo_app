import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:passwordfield/passwordfield.dart';
import 'package:proapp/main.dart';
import 'package:proapp/web_view_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isLoading = false;
  bool _acepto=false;
  bool _confi=false;
  String URL = "https://admin.proexplo.com.pe/rest";
  bool passwordVisible=true;
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
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  registerIn(String nombres,apellidos,tipodoc,nrodoc,ruc,empresa,cargo,celu,tlf, email, pass,acepto,confi) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'nombres':nombres,
      'apellidos':apellidos,
      'tipodoc':tipodoc,
      'nrodoc':nrodoc,
      'ruc':ruc,
      'empresa':empresa,
      'cargo':cargo,
      'celu':celu,
      'tlf':tlf,
      'email': email,
      'password': pass,
      'acepto': acepto,
      'confi': confi
    };

    Map data2 = {
      'email': email,
      'password': pass
    };

    var jsonResponse = null;
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    HttpClientRequest request1 = await client.postUrl(Uri.parse(URL+"/saveuser"));
    request1.headers.set('content-type', 'application/json');
    request1.add(utf8.encode(json.encode(data)));
    HttpClientResponse response1 = await request1.close();
    String respuestajson1 = await response1.transform(utf8.decoder).join();


    if(response1.statusCode == 200) {
      jsonResponse = json.decode(respuestajson1);
      if(jsonResponse != null) {
        if(jsonResponse['IND_OPERACION']=="1") {
          // si se registra Hacemos login aut.
          //###################################################################################

          HttpClientRequest request = await client.postUrl(Uri.parse(URL+"/login"));
          request.headers.set('content-type', 'application/json');
          request.add(utf8.encode(json.encode(data2)));
          HttpClientResponse response = await request.close();
          String respuestajson = await response.transform(utf8.decoder).join();
          if(response.statusCode == 200) {
            jsonResponse = json.decode(respuestajson);
            if(jsonResponse != null) {
              setState((){
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

                sharedPreferences.setString("tokenfec4", jsonResponse['FEC4']);
                sharedPreferences.setString("tokentfec4", jsonResponse['TFEC4']);
                sharedPreferences.setString("tokenttfec4", jsonResponse['TTFEC4']);

                sharedPreferences.setString("tokenfec5", jsonResponse['FEC6']);
                sharedPreferences.setString("tokentfec5", jsonResponse['TFEC6']);
                sharedPreferences.setString("tokenttfec5", jsonResponse['TTFEC6']);

                sharedPreferences.setString("tokenfec6", jsonResponse['FEC6']);
                sharedPreferences.setString("tokentfec6", jsonResponse['TFEC6']);
                sharedPreferences.setString("tokenttfec6", jsonResponse['TTFEC6']);

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
              }
            }
          }
          else {
            setState(() {
              _isLoading = false;
            });
            //print(response.);
          }

          //###################################################################################
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
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(top: 10.0),
      child: RaisedButton(
        onPressed: emailController.text == "" || passwordController.text == "" ? null : () {


          int acepto,confi=0;
           acepto = _acepto==true?1:0;
           confi = _confi==true?1:0;
          int bandera=0;
          final bool isValid = EmailValidator.validate(emailController.text);

          if(nrodocController.text.trim()=="" || nombresController.text.trim()==""|| apellidosController.text.trim()==""||
              passwordController.text.trim()==""){
                bandera=0;
          }

          if(isValid){
            bandera=1;

          }else{
            bandera=0;
            Fluttertoast.showToast(
                msg: "Email Inválido",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1
            );
          }
            if(bandera==1) {
              setState(() {
                _isLoading = true;
              });
              registerIn(
                nombresController.text,
                apellidosController.text,
                 _SelectdType,
                nrodocController.text,
                rucempController.text,
                razempController.text,
                cargoController.text,
                celularController.text,
                tlfController.text,
                emailController.text,
                passwordController.text,
                acepto,
                confi);
            }else{
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                  msg: "Completar Campos",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1
              );
            }
          },
        elevation: 0.0,
        color: Colors.orange,
        child: Text("Registrarse", style: TextStyle(color: Colors.black87)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nombresController = new TextEditingController();
  final TextEditingController apellidosController = new TextEditingController();
  final TextEditingController tipodocController = new TextEditingController();
  final TextEditingController nrodocController = new TextEditingController();
  final TextEditingController rucempController = new TextEditingController();
  final TextEditingController razempController = new TextEditingController();
  final TextEditingController cargoController = new TextEditingController();
  final TextEditingController celularController = new TextEditingController();
  final TextEditingController tlfController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


  final FocusNode _emaFocus = FocusNode();
  final FocusNode _nomFocus = FocusNode();
  final FocusNode _apeFocus = FocusNode();
  final FocusNode _tdoFocus = FocusNode();
  final FocusNode _ndoFocus = FocusNode();
  final FocusNode _rucFocus = FocusNode();
  final FocusNode _razFocus = FocusNode();
  final FocusNode _carFocus = FocusNode();
  final FocusNode _celFocus = FocusNode();
  final FocusNode _tlfFocus = FocusNode();
  final FocusNode _claFocus = FocusNode();

  int pubmaximo=8;
  TextInputType pubtipo =TextInputType.number;
  WhitelistingTextInputFormatter pubteclado = WhitelistingTextInputFormatter.digitsOnly;


  String _SelectdType="Seleccione";
  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: nombresController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.next,
            focusNode: _nomFocus,
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _nomFocus, _apeFocus);
            },
            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _nomFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              hintText: "Nombres",
              labelText: 'Nombres',
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
          SizedBox(height: 10.0),
          TextFormField(
            controller: apellidosController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            focusNode: _apeFocus,
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _apeFocus, _tdoFocus);
            },
            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _apeFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              hintText: "Apellidos",
              labelText: 'Apellidos',
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
          SizedBox(height: 10.0),
          Container(
             height: 55,
          child:
            InputDecorator(

              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: _tdoFocus.hasFocus ? Colors.deepOrange : Colors.black
                ),
                fillColor: Colors.black,
                labelText: 'Tipo Documento',
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
                hintStyle: TextStyle(color: Colors.black),
              ),
            child: DropdownButtonHideUnderline(

              child:DropdownButton<String>(
                hint: Text(_SelectdType),
                focusNode: _tdoFocus,
                style: TextStyle(color: Colors.black),
                items: <String>['DNI', 'CE', 'PS', 'Otros'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                  );
              }).toList(),
              onChanged: (String val) {
              print(val);
              setState(() {
                _SelectdType = val;
                if(val=="DNI"){
                  pubmaximo=8;
                  pubtipo=TextInputType.number;
                  pubteclado= WhitelistingTextInputFormatter.digitsOnly;
                }
                if(val=="CE"){
                  pubmaximo=12;
                  pubtipo=TextInputType.text;
                  pubteclado=  WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"));
                }
                if(val=="PS"){
                  pubmaximo=12;
                  pubtipo=TextInputType.text;
                  pubteclado= WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"));
                }
                if(val=="Otros"){
                  pubmaximo=20;
                  pubtipo=TextInputType.text;
                  pubteclado=  WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"));
                }
                // _fieldFocusChange(context, _tdoFocus, _ndoFocus);
              });
              },
            )
       ))),
          SizedBox(height: 10.0),
          TextFormField(
            controller: nrodocController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.next,
            focusNode: _ndoFocus,
            maxLength: pubmaximo,
            keyboardType: pubtipo,
            inputFormatters: <TextInputFormatter>[
             pubteclado
            ],
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _ndoFocus, _rucFocus);
            },
            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _ndoFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              hintText: "Nro. Documento",
              labelText: 'Nro. Documento',
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
          SizedBox(height: 10.0),

          TextFormField(
            controller: rucempController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.next,
            focusNode: _rucFocus,
            maxLength: 11,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ], // Only numbers c
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _rucFocus, _razFocus);
            },
            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _rucFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              hintText: "RUC Empresa",
              labelText: 'RUC Empresa',
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
          SizedBox(height: 10.0),
          TextFormField(
            controller: razempController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            focusNode: _razFocus,
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _razFocus, _carFocus);
            },
            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _razFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              hintText: "Nombre Empresa",
              labelText: 'Nombre Empresa',
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
          SizedBox(height: 10.0),
          TextFormField(
            controller: cargoController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.next,
            focusNode: _carFocus,
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _carFocus, _tlfFocus);
            },
            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _carFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              hintText: "Cargo",
              labelText: 'Cargo',
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
          SizedBox(height:10.0),
          TextFormField(
            controller: tlfController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            focusNode: _tlfFocus,
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _tlfFocus, _celFocus);
            },
            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _tlfFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              hintText: "Teléfono",
              labelText: 'Teléfono',
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
          SizedBox(height: 10.0),
          TextFormField(
            controller: celularController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            focusNode: _celFocus,
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _celFocus, _emaFocus);
            },
            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _celFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              hintText: "Celular",
              labelText: 'Celular',
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
          SizedBox(height: 10.0),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            focusNode: _emaFocus,
            onFieldSubmitted: (term){
              _fieldFocusChange(context, _emaFocus, _claFocus);
            },
            style: TextStyle(color: Colors.black,height: 0.5),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _emaFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              hintText: "Email",
              labelText: 'Email',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                      width: 2,color:Colors.black12
                  )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        width: 2,color:Colors.deepOrange
                    )),
              hintStyle: TextStyle(color: Colors.black87),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            focusNode: _claFocus,
            keyboardType: TextInputType.text,
            controller: passwordController,
            obscureText: passwordVisible,//This will obscure text dynamically
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: _claFocus.hasFocus ? Colors.deepOrange : Colors.black
              ),
              labelText: 'Contraseña',
              hintText: 'Contraseña',
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
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(child: new FlatButton(onPressed:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WebViewContainer("http://admin.proexplo.com.pe/rest/terminos?idioma=1","Términos y Condiciones")));
              }, child: new Text("Acepto términos y condiciones"))),
              Switch(
                value: _acepto,
                onChanged: (bool newValue) {
                  _acepto =newValue;
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: new FlatButton(onPressed:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WebViewContainer("http://admin.proexplo.com.pe/rest/tratamiento?idioma=1","Tratamiento de Datos")));
              }, child: new Text("Acepto el tratamiento de mis datos"))),
              Switch(
                value: _confi,
                onChanged: (bool newValue) {
                  _confi =newValue;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Registrate Aquí",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black87,
              fontSize: 17.0,

              fontWeight: FontWeight.bold)),
    );
  }
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}