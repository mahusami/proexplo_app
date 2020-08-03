import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:proapp/Pregunta.dart';

import 'Perfilview.dart';
import 'Preguntaview.dart';
class ListPreguntas extends StatefulWidget {
  final idprograma;
  final title;
  ListPreguntas(this.idprograma,this.title);

  /*@override
  createState() => _ListParticipanteState(this.idprograma,this.title);*/
  @override
  _ListPreguntasState createState() => _ListPreguntasState(this.idprograma,this.title);
}

class _ListPreguntasState extends State<ListPreguntas> {
  var _idprograma;
  var _title;
  bool _isLoadingPage;
  final _key = UniqueKey();

  _ListPreguntasState(this._idprograma,this._title);
  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( title: new Text("Preguntas en vivo "),),
        body: Center(
            child:FutureBuilder<List<Pregunta>>(
              future: _fetchJobs2(_idprograma),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  List<Pregunta> data = snapshot2.data;
                  return _jobsListView2(data);
                } else if (snapshot2.hasError) {
                  return Text("${snapshot2.error}");
                }
                return CircularProgressIndicator();
              },
            ))
        );
  }

  Future<List<Pregunta>> _fetchJobs2(int idprog) async {

    final jobsListAPIUrl2 = 'https://admin.proexplo.com.pe/rest/getpreguntasexpo';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usuario=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();

    Map data = {
      'programa': idprog,
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
    print("entro");
    print(respuestajson);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(respuestajson);
      return jsonResponse.map((job2) => new Pregunta.fromJson(job2)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView2(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            shape: getborder(index),
            color:Colors.white,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  width: 50,
                  child:FlatButton(
                    child: Icon(
                      Icons.help,
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    onPressed: () {
                       Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PreguntaPage(data[index].id,
                              data[index].programa,data[index].pregunta,data[index].fechahora,data[index].nombres+ " "+data[index].apellidos,
                              "","")));
                    },
                  ),

                ),
                title: Text(
                  data[index].pregunta,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold,fontSize: 15),

                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),


            ),
          );

        });
  }

  Border getborder(int ix){
    Border col;

      if(ix%2==0){
        col = Border(left: BorderSide(color: Colors.orange, width: 5));
      } else {
        col = Border(left: BorderSide(color: Colors.teal, width: 5));
      }

    return col;
  }


}
