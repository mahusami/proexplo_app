import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proapp/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'allTranslations.dart';
import 'login.dart';


class ProfilePageEdit extends StatefulWidget {

  ProfilePageEdit();
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePageEdit>
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
  bool _confi=false;
  MapScreenState();
  bool _status = true;
  String _TIPODOC;
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

  final FocusNode _linkedinFocus = FocusNode();
  final FocusNode _twiterFocus = FocusNode();


  String _SelectdType="Seleccione";
  List messages ;
  String profile;
  int pubmaximo=8;
  TextInputType pubtipo =TextInputType.number;
  WhitelistingTextInputFormatter pubteclado = WhitelistingTextInputFormatter.digitsOnly;
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    getProfile();
    setearsession();
    // TODO: implement initState
   // emailController.text=messages[0].email;
    //apellidosController.text=messages[0].apellidos;

    super.initState();
  }
  setearsession() async {
    sharedPreferences = await SharedPreferences.getInstance();
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
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : new Container(),
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
                                      items: <String>['','DNI', 'CE', 'PS', 'Otros'].map((String value) {
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
                          Row(
                            children: <Widget>[
                              Expanded(child: new FlatButton( child: new Text( allTranslations.text('key_confidencial')))),
                              Switch(
                                value: _confi,
                                onChanged: (bool newValue) {
                                  _confi =newValue;
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:<Widget>[
                              FlatButton(
                                onPressed: () {
                                  sharedPreferences.clear();
                                  sharedPreferences.commit();
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
                                },
                                child:  new Text( allTranslations.text('key_close')),
                              ),
                            ]

                          ),
                          !_status ? _getActionButtons() : new Container(),
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
        print(messages);
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

        if(messages[0]['auto']==1){
          _confi=true;
        }else{
          _confi=false;
        }

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
                    child: new Text( allTranslations.text('key_info_guardar')),
                    textColor: Colors.white,
                    color: Colors.teal,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());

                        updateIn(nombresController.text,apellidosController.text,_TIPODOC,nrodocController.text ,
                            rucempController.text,razempController.text,cargoController.text,
                            celularController.text,tlfController.text, emailController.text, passwordController.text,
                            linkedinController.text,twiterController.text);

                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text( allTranslations.text('key_info_cancelar')),
                    textColor: Colors.white,
                    color: Colors.deepOrange,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
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

  updateIn(String nombres,apellidos,tipodoc,nrodoc,ruc,empresa,cargo,celu,tlf, email, pass,linkedin,twiter) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usuario=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();
    int auto=0;
    if(_confi==true){auto=1;}

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
      'auto':auto
    };

    var jsonResponse = null;
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    HttpClientRequest request1 = await client.postUrl(Uri.parse("https://admin.proexplo.com.pe/rest/upduser"));
    request1.headers.set('content-type', 'application/json');
    request1.add(utf8.encode(json.encode(data)));
    HttpClientResponse response1 = await request1.close();
    String respuestajson1 = await response1.transform(utf8.decoder).join();


    if(response1.statusCode == 200) {
      jsonResponse = json.decode(respuestajson1);
      if(jsonResponse != null) {
        if(jsonResponse['IND_OPERACION']=="1") {
          Fluttertoast.showToast(
              msg: jsonResponse['DES_MENSAJE'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1
          );
        }else{
          Fluttertoast.showToast(
              msg: jsonResponse['DES_MENSAJE'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1
          );
        }
      }
    }
  }
}