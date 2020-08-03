import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PreguntaPage extends StatefulWidget {
  final idperfil;
  final title;
  final cargo;
  final correo;
  final empresa;
  final linkedin;
  final twiter;
  PreguntaPage(this.idperfil,this.title,this.cargo,this.correo,this.empresa,this.linkedin,this.twiter);
  @override
  MapScreenState createState() => MapScreenState(this.idperfil,this.title,this.cargo,this.correo,this.empresa,this.linkedin,this.twiter);
}

class MapScreenState extends State<PreguntaPage>
    with SingleTickerProviderStateMixin {
  var _idperfil;
  var _title;
  var _cargo;
  var _correo;
  var _empresa;
  var _linkedin;
  var _twiter;
  final String _fullName = "Nick";
  final String _status = "Software Developer";
  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";
  final String _followers = "173";
  final String _posts = "24";
  final String _scores = "450";


  MapScreenState(this._idperfil,this._title,this._cargo,this._correo,this._empresa,this._linkedin,this._twiter);
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        appBar: AppBar( title: new Text("Preguntas en vivo "),),
       body: Stack(
    children: <Widget>[
    _buildCoverImage(screenSize),
    SafeArea(
    child: SingleChildScrollView(
    child: Column(
    children: <Widget>[
      SizedBox(height:20),
    _buildFullName(),
      SizedBox(height:20),
    _buildStatus(context),SizedBox(height:10),
    //_buildStatContainer(),
     _buildBio2(context), _buildBio(context),

    _buildSeparator(screenSize),
    SizedBox(height: 10.0),
    _buildGetInTouch(context),
    SizedBox(height: 8.0),
    _buildButtons(),
    ],
    ),
    ),
    ),
    ],
    ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:  NetworkImage("http://admin.proexplo.com.pe/img/fondob.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }



  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      "PROGRAMA: "+_title,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        "PREGUNTA: "+_cargo,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Followers", _followers),
          _buildStatItem("Posts", _posts),
          _buildStatItem("Scores", _scores),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,

      fontSize: 16.0,
    );

    return Container(

      padding: EdgeInsets.all(8.0),
      child: Text(
        _correo,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildBio2(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(

      padding: EdgeInsets.all(8.0),
      child: Text(
        _empresa,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    return Container(

      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        "",
        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: (){
                _atenderpregunta(_idperfil);
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "ATENDER",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),

        ],
      ),
    );
  }

  void _atenderpregunta(int idpregunta) async {
    final jobsListAPIUrl = 'https://admin.proexplo.com.pe/rest/insertaatencion';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usuario=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();

    Map data = {
      'idpregunta': idpregunta,
      'idioma':IDIOMA,
      "usuario":usuario
    };

    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(jobsListAPIUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    String respuestajson = await response.transform(utf8.decoder).join();
    var jsonResponse = null;
    print(respuestajson);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(respuestajson);
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
    } else {
      throw Exception('Failed to load save participante');
    }
  }

}