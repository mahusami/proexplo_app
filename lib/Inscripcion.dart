import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as ImageProcess;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proapp/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'allTranslations.dart';
import 'main.dart';


class InscripcionPageEdit extends StatefulWidget {

  InscripcionPageEdit();
  @override
  InscripcionState createState() => InscripcionState();
}

class InscripcionState extends State<InscripcionPageEdit>
    with SingleTickerProviderStateMixin {

  String _nombres;
  String _apellidos;
  String _tipodoc;
  String _nrodoc;
  String _ruc;
  String _empresa;
  String _cargo;
  String _email;
  String _celular;
  String _telefono;

  InscripcionState();
  bool _status = true;
  String _TIPODOC;
  String _COMPROBANTE="";
  String _FORMAPAGO="";
  String _CATEGORIA="";
  final FocusNode myFocusNode = FocusNode();
   TextEditingController emailController = new TextEditingController();
   TextEditingController nombresController = new TextEditingController();
   TextEditingController apellidosController = new TextEditingController();
   TextEditingController tipodocController = new TextEditingController();
   TextEditingController nrodocController = new TextEditingController();
   TextEditingController rucempController = new TextEditingController();
   TextEditingController razempController = new TextEditingController();
   TextEditingController cargoController = new TextEditingController();
   TextEditingController celularController = new TextEditingController();
   TextEditingController tlfController = new TextEditingController();
   TextEditingController passwordController = new TextEditingController();
   TextEditingController linkedinController = new TextEditingController();
  TextEditingController twiterController = new TextEditingController();
  TextEditingController  amountController = new TextEditingController();

  TextEditingController telconController = new TextEditingController();
  TextEditingController fullnameController  = new TextEditingController();
  TextEditingController  documenController  = new TextEditingController();
  TextEditingController billingController = new TextEditingController();
  TextEditingController contactoController  = new TextEditingController();
  TextEditingController formapagoController  = new TextEditingController();

  final FocusNode _formapagoFocus  = FocusNode();
  final FocusNode _contactoFocus = FocusNode();
  final FocusNode _billingFocus = FocusNode();
  final FocusNode _documenFocus = FocusNode();
  final FocusNode _fullnameFocus = FocusNode();
  final FocusNode _telconFocus = FocusNode();
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
  final FocusNode _comproFocus = FocusNode();
  final FocusNode _linkedinFocus = FocusNode();
  final FocusNode _twiterFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _cateFocus = FocusNode();
  final FocusNode _paisFocus = FocusNode();
  final FocusNode _depaFocus = FocusNode();
  final FocusNode _provFocus = FocusNode();
  final FocusNode _distFocus = FocusNode();

  String _SelectdType="Seleccione";
  File _image;
  String _uploadedFileURL;
  List messages ;
  String profile;
  int pubmaximo=8;
  TextInputType pubtipo =TextInputType.number;
  WhitelistingTextInputFormatter pubteclado = WhitelistingTextInputFormatter.digitsOnly;
  List paisesList = List();
  List provinciassList = List();
  List depasList = List();
  List distList = List();
  String _pais="75";
  String _prov;
  String _depa;
  String _dist;
  int _idpais;
  int _iddepa;
  int _idprov;
  int _iddist;

  Combo selectedUser;
  List<Combo> users;

  Future<String> _getpais() async {
    final jobsListAPIUrl = 'https://admin.proexplo.com.pe/rest/getpais';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String EMAIL = sharedPreferences.getString("token").toString();
    String IDIOMA = sharedPreferences.getString("idioma").toString();

    Map data = {
      'email': EMAIL,
    };

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(jobsListAPIUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    String respuestajson = await response.transform(utf8.decoder).join();
    print(respuestajson);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(respuestajson);
      setState(() {
        paisesList = jsonResponse.map((combo2) => new Combo2.fromJson(combo2)).toList();

      });
    } else {

    }
  }


  Future<String> _getdepa() async {
    final jobsListAPIUrl = 'https://admin.proexplo.com.pe/rest/getdepartamento';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String EMAIL = sharedPreferences.getString("token").toString();
    String IDIOMA = sharedPreferences.getString("idioma").toString();

    Map data = {
      'idpais': _pais,
    };

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(jobsListAPIUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    String respuestajson = await response.transform(utf8.decoder).join();
    print(respuestajson);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(respuestajson);
      setState(() {
        depasList = jsonResponse.map((combo2) => new Combo2.fromJson(combo2)).toList();
      });
    } else {
    }
  }


  Future<String> _getprov() async {
    final jobsListAPIUrl = 'https://admin.proexplo.com.pe/rest/getprovincia';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String EMAIL = sharedPreferences.getString("token").toString();
    String IDIOMA = sharedPreferences.getString("idioma").toString();

    Map data = {
      'idpais': _pais,
      'iddepa':_depa
    };

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(jobsListAPIUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    String respuestajson = await response.transform(utf8.decoder).join();
    print(respuestajson);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(respuestajson);
      setState(() {
        provinciassList = jsonResponse.map((combo2) => new Combo2.fromJson(combo2)).toList();
      });
    } else {
    }
  }


  Future<String> _getdist() async {
    final jobsListAPIUrl = 'https://admin.proexplo.com.pe/rest/getdistrito';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String EMAIL = sharedPreferences.getString("token").toString();
    String IDIOMA = sharedPreferences.getString("idioma").toString();

    Map data = {
      'idpais': _pais,
      'iddepa':_depa,
      'idprov':_prov
    };

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(jobsListAPIUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    String respuestajson = await response.transform(utf8.decoder).join();
    print(respuestajson);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(respuestajson);
      setState(() {
        distList = jsonResponse.map((combo2) => new Combo2.fromJson(combo2)).toList();
      });
    } else {
    }
  }

  @override
  void initState() {
    users= <Combo>[const Combo("", "SELECCIONE"),const Combo("SO",'(1) ASOCIADO IIMP'),const Combo("SC",'(2) ASOCIADO PQT CORPORATIVO'),
      const Combo("NC",'(3) NO ASOCIADO PQT COPORATIVO'), const Combo("ES",'(4) ESTUDIANTE'),
      const Combo("DO",'(5) DOCENTE'),
      const Combo("AE", "(6) ASOCIADO ESTUDIANTE") ,const Combo("NS",'(7) NO ASOCIADO')
    ];
    selectedUser=users[0];
    getProfile();

    // TODO: implement initState
   // emailController.text=messages[0].email;
    //apellidosController.text=messages[0].apellidos;
    _status=true;
    super.initState();
    _getpais();
    _getdepa();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        resizeToAvoidBottomInset : false,
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 10.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[


                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_personal'),
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,color:Colors.deepOrange),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                       new Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_nombre'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                        hintText: "",
                                      ),
                                      controller: nombresController,
                                      focusNode: _nomFocus,
                                      enabled: !_status,
                                      autofocus: !_status,


                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_apellido'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      controller: apellidosController,
                                      focusNode: _apeFocus,
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_tipodoc'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                     child: DropdownButtonHideUnderline(
                                         child:DropdownButton<String>(
                                            hint: Text(_SelectdType),
                                      focusNode: _tdoFocus,
                                      value: _TIPODOC,
                                      style: TextStyle(color: Colors.black),
                                      items: <String>['DNI', 'CE', 'PS', 'Otros'].map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String val) {
                                        //_SelectdType = val;
                                          setState(() {
                                            _TIPODOC=val;
                                            _tdoFocus.unfocus();

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
                                            //FocusScope.of(context).requestFocus(_ndoFocus);
                                          });

                                        },
                                      )
                                     ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_nrodoc'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      controller: nrodocController,
                                      focusNode: _ndoFocus,
                                      enabled: !_status,
                                      maxLength: pubmaximo,
                                      keyboardType: pubtipo,
                                      inputFormatters: <TextInputFormatter>[
                                        pubteclado
                                      ],

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_ruc'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      enabled: !_status,
                                      controller: rucempController,
                                      focusNode: _rucFocus,
                                      maxLength: 11,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter.digitsOnly
                                      ], // Only numbers c
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_empresa'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      enabled: !_status,
                                      controller: razempController,
                                      focusNode: _razFocus,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_cargo'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      enabled: !_status,
                                      controller: cargoController,
                                      focusNode: _carFocus,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'LinkedIn',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      enabled: !_status,
                                      controller: linkedinController,
                                      focusNode: _linkedinFocus,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Twitter',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      enabled: !_status,
                                      controller: twiterController,
                                      focusNode: _twiterFocus,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                      allTranslations.text('key_info_email'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      enabled: false,
                                      controller: emailController,
                                      focusNode: _emaFocus,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        allTranslations.text('key_info_celular'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                          allTranslations.text('key_info_telefono'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                            hintText: ""),
                                        enabled: !_status,
                                        controller: celularController,
                                        focusNode: _celFocus,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      enabled: !_status,
                                      controller: tlfController,
                                      focusNode: _tlfFocus,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_pais'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: DropdownButtonHideUnderline(
                                        child:DropdownButton(
                                          focusNode: _paisFocus,
                                          value:_pais,
                                          style: TextStyle(color: Colors.black),
                                          items: paisesList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item.nombre),
                                              value: item.id.toString(),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _pais = newValue;
                                              _depa = null;
                                              _prov=null;
                                              _dist=null;
                                              _getdepa();
                                              _getprov();
                                              _getdist();
                                              //selectedUser = newValue;
                                              //_CATEGORIA=newValue.id;
                                              //_imprimirmonto(nrodocController.text.trim(),newValue.id,_TIPODOC,apellidosController.text.trim());
                                            });
                                          },
                                        )
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_depa'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: DropdownButtonHideUnderline(
                                        child:DropdownButton(
                                          focusNode: _depaFocus,
                                          value:_depa,
                                          style: TextStyle(color: Colors.black),
                                          items: depasList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item.nombre),
                                              value: item.id.toString(),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _depa = newValue;
                                              _prov=null;
                                              _dist=null;
                                              _getprov();
                                              _getdist();
                                              //selectedUser = newValue;
                                              //_CATEGORIA=newValue.id;
                                              //_imprimirmonto(nrodocController.text.trim(),newValue.id,_TIPODOC,apellidosController.text.trim());
                                            });
                                          },
                                        )
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_prov'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: DropdownButtonHideUnderline(
                                        child:DropdownButton(
                                          focusNode: _provFocus,
                                          value:_prov,
                                          style: TextStyle(color: Colors.black),
                                          items: provinciassList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item.nombre),
                                              value: item.id.toString(),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _prov = newValue;
                                              _dist=null;
                                              _getdist();
                                              //selectedUser = newValue;
                                              //_CATEGORIA=newValue.id;
                                              //_imprimirmonto(nrodocController.text.trim(),newValue.id,_TIPODOC,apellidosController.text.trim());
                                            });
                                          },
                                        )
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_info_dist'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: DropdownButtonHideUnderline(
                                        child:DropdownButton(
                                          focusNode: _distFocus,
                                          value:_dist,
                                          style: TextStyle(color: Colors.black),
                                          items: distList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item.nombre),
                                              value: item.id.toString(),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _dist = newValue;
                                              //selectedUser = newValue;
                                              //_CATEGORIA=newValue.id;
                                              //_imprimirmonto(nrodocController.text.trim(),newValue.id,_TIPODOC,apellidosController.text.trim());
                                            });
                                          },
                                        )
                                    ),
                                  ),
                                ],
                              )),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 2.0),
                      child:
                      new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 25,),
                              new Text(
                                allTranslations.text('key_info_inscripcion'),
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,color:Colors.deepOrange),
                              ),
                              SizedBox(height: 10,),
                            ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_category'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: DropdownButtonHideUnderline(
                                        child:DropdownButton<Combo>(

                                          focusNode: _cateFocus,
                                          value: selectedUser,
                                          style: TextStyle(color: Colors.black),
                                          items: users.map((Combo user) {
                                            return new DropdownMenuItem<Combo>(
                                              value: user,
                                              child: new Text(
                                                user.name,
                                                style: new TextStyle(color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                            onChanged: (Combo newValue) {
                                              setState(() {
                                                selectedUser = newValue;
                                                  _CATEGORIA=newValue.id;
                                                  _imprimirmonto(nrodocController.text.trim(),newValue.id,_TIPODOC,apellidosController.text.trim());
                                              });
                                            },
                                        )
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_monto'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      controller: amountController,
                                      focusNode: _amountFocus,
                                      enabled: !_status,

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_mensa'),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(height: 22,),
                                      new Text(
                                        allTranslations.text('key_info_factu'),
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,color:Colors.deepOrange),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: DropdownButtonHideUnderline(
                                        child:DropdownButton<String>(
                                          hint: Text(_COMPROBANTE),
                                          focusNode: _comproFocus,
                                          value: _COMPROBANTE,
                                          style: TextStyle(color: Colors.black),
                                          items: <String>["",allTranslations.text("key_doc1"), allTranslations.text("key_doc2")].map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String val) {
                                            //_SelectdType = val;
                                            setState(() {
                                              _COMPROBANTE=val;
                                              //FocusScope.of(context).requestFocus(_ndoFocus);
                                            });

                                          },
                                        )
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_fullname'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      controller: fullnameController,
                                      focusNode: _fullnameFocus,

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_document'),

                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      controller: documenController,
                                      focusNode: _documenFocus,
                                      maxLength: 11,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter.digitsOnly
                                      ], // Only numbers c
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_billing'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      controller: billingController,
                                      focusNode: _billingFocus,

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_contact'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      controller: contactoController,
                                      focusNode: _contactoFocus,

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        allTranslations.text('key_phone'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: ""),
                                      controller: telconController,
                                      focusNode: _telconFocus,

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(height: 22,),
                                      new Text(
                                        allTranslations.text('key_info_forma'),
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,color:Colors.deepOrange),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[

                                      new Text(
                                        allTranslations.text('key_info_type'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: DropdownButtonHideUnderline(
                                        child:DropdownButton<String>(
                                          hint: Text(_FORMAPAGO),
                                          focusNode: _formapagoFocus,
                                          value: _FORMAPAGO,
                                          style: TextStyle(color: Colors.black),
                                          items: <String>["",allTranslations.text("key_deposito"), allTranslations.text("key_bank")].map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String val) {
                                            //_SelectdType = val;
                                            setState(() {
                                              _FORMAPAGO=val;
                                              //FocusScope.of(context).requestFocus(_ndoFocus);
                                            });

                                          },
                                        )
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[

                                      new Text(
                                        allTranslations.text('key_banco'),
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[

                                      new  RaisedButton(
                                        child: Text(allTranslations.text("key_buscarfile")),
                                        onPressed: chooseFile,
                                        color: Colors.cyan,
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[

                                      new Text(
                                        allTranslations.text('key_detra'),
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                           _getActionButtons(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  void getProfile() async {

    final jobsListAPIUrl2 = 'https://admin.proexplo.com.pe/rest/getusu';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usuario=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();

    Map data = {
      'usuario':usuario,
      'idioma':IDIOMA
    };

    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(jobsListAPIUrl2));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    String respuestajson = await response.transform(utf8.decoder).join();

    if (response.statusCode == 200) {
      setState(() {
        messages = json.decode(respuestajson);
        nombresController.text=messages[0]['nombres'];
        apellidosController.text=messages[0]['apellidos'];
        nrodocController.text=messages[0]['nrodoc'];
        _TIPODOC=messages[0]['tipodoc'];
        //tipodocController.text=
        rucempController.text=messages[0]['rucemp'];
        razempController.text=messages[0]['razemp'];
        cargoController.text=messages[0]['cargo'];
        emailController.text=messages[0]['email'];
        celularController.text=messages[0]['cel'];
        tlfController.text=messages[0]['tlf'];
        linkedinController.text=messages[0]['linkedin'];
        twiterController.text=messages[0]['twiter'];
      });


    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text( allTranslations.text('key_info_inscribir')),
                    textColor: Colors.white,
                    color: Colors.teal,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());

                        updateIn(nombresController.text,apellidosController.text,_TIPODOC,nrodocController.text ,
                            rucempController.text,razempController.text,cargoController.text,
                            celularController.text,tlfController.text, emailController.text, passwordController.text,
                            linkedinController.text,twiterController.text,
                            amountController.text,fullnameController.text,documenController.text,
                            billingController.text,contactoController.text,telconController.text,
                            _CATEGORIA,_COMPROBANTE,_FORMAPAGO,_image);

                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),

        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }



  _imprimirmonto(String nrodoc,categoria,tipodoc,apellidop)async {
    Map data = {
      'nrodoc':nrodoc,
      'tipodoc':tipodoc,
      'apellidop':apellidop,
      'idcate':categoria,
    };

    var jsonResponse = null;
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    HttpClientRequest request1 = await client.postUrl(Uri.parse("https://admin.proexplo.com.pe/rest/getvalidacionws"));
    request1.headers.set('content-type', 'application/json');
    request1.add(utf8.encode(json.encode(data)));
    HttpClientResponse response1 = await request1.close();
    String respuestajson1 = await response1.transform(utf8.decoder).join();


    if(response1.statusCode == 200) {
      jsonResponse = json.decode(respuestajson1);
      if(jsonResponse != null) {
        print(jsonResponse);
       if(jsonResponse['IDD']>0){
              amountController.text=jsonResponse['MONTO'];
       }else{
         amountController.text="0";
         Fluttertoast.showToast(
             msg: jsonResponse['MENSAJE'],
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.CENTER,
             timeInSecForIos: 1
         );
       }

      }
    }

  }

  updateIn(String nombres,apellidos,tipodoc,nrodoc,ruc,empresa,cargo,celu,tlf, email, pass,linkedin,twiter,
      amount,fullname,documen, billing,contacto,telcon,
    _CATEGORIA,_COMPROBANTE,_FORMAPAGO,File _image) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usuario=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();
    String img64 ="";
    String nombrefile="";
    if(_image!=null) {
      final _imageFile = ImageProcess.decodeImage(
        _image.readAsBytesSync(),
      );
      nombrefile=_image.path.split('/').last;
      img64= base64Encode(ImageProcess.encodePng(_imageFile));
    }

    Map data = {
      'idusu':usuario,
      'idioma':IDIOMA,
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
      'linkedin': linkedin,
      'twiter': twiter,
      'amount':amount,
      'fullname':fullname,
      'documen':documen,
      'billing':billing,
      'telcon':telcon,
      'categoria':_CATEGORIA,
      'comprobante':_COMPROBANTE,
      'formapago':_FORMAPAGO,
      'contacto':contacto,
      'image':img64,
      'nombrefile':nombrefile,
      'pais':_pais,
      'depa':_depa,
      'prov':_prov,
      'dist':_dist
    };

    var jsonResponse = null;
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    HttpClientRequest request1 = await client.postUrl(Uri.parse("https://admin.proexplo.com.pe/rest/saveficha"));
    request1.headers.set('content-type', 'application/json');
    request1.add(utf8.encode(json.encode(data)));
    HttpClientResponse response1 = await request1.close();
    String respuestajson1 = await response1.transform(utf8.decoder).join();


    if(response1.statusCode == 200) {
      jsonResponse = json.decode(respuestajson1);
      if(jsonResponse != null) {
        if(jsonResponse['INDICADOR']=="1") {
          Fluttertoast.showToast(
              msg: jsonResponse['MENSAJE'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1
          );
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (BuildContext context) => MainPage()), (
              Route<dynamic> route) => false);
        }else{
          Fluttertoast.showToast(
              msg: jsonResponse['MENSAJE'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1
          );
        }
      }
    }
  }
}

class Combo {
  const Combo(this.id,this.name);

  final String name;
  final String id;
}


class Combo2 {
  final String nombre;
  final int id;
  Combo2({this.id,this.nombre});
  factory Combo2.fromJson(Map<String, dynamic> json) {
    return Combo2(
        id: json['id'],
        nombre: json['nombre']
    );
  }
}