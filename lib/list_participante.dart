import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:proapp/Participante.dart';

import 'Perfilview.dart';
class ListParticipante extends StatefulWidget {
  final idprograma;
  final title;
  ListParticipante(this.idprograma,this.title);

  /*@override
  createState() => _ListParticipanteState(this.idprograma,this.title);*/
  @override
  _ListParticipanteState createState() => _ListParticipanteState(this.idprograma,this.title);
}

class _ListParticipanteState extends State<ListParticipante> {
  var _idprograma;
  var _title;
  bool _isLoadingPage;
  final _key = UniqueKey();

  _ListParticipanteState(this._idprograma,this._title);
  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(child:FutureBuilder<List<Job2>>(
              future: _fetchJobs2(_idprograma),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  List<Job2> data = snapshot2.data;
                  return _jobsListView2(data);
                } else if (snapshot2.hasError) {
                  return Text("${snapshot2.error}");
                }
                return CircularProgressIndicator();
              },
            ))

        );
  }

  Future<List<Job2>> _fetchJobs2(int idprog) async {

    final jobsListAPIUrl2 = 'https://admin.proexplo.com.pe/rest/getparticipante';
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
      return jsonResponse.map((job2) => new Job2.fromJson(job2)).toList();
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
                      data[index].auto==1?Icons.person:Icons.lock,
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    onPressed: () {
                        if(data[index].auto==1){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ProfilePage(data[index].id,
                          data[index].nombre,data[index].cargo,data[index].correo,data[index].empresa,
                          data[index].linkedin,data[index].twiter)));
                        }
                    },
                  ),

                ),
                title: Text(
                  data[index].nombre,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold,fontSize: 15),

                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),


                trailing: Container(width: 40,child:
                  data[index].tipo==0?new FlatButton(
                    child: Icon(
                    Icons.add_box,
                    color: Colors.black,
                  ),

                  onPressed: () {
                      _SaveContacto(data[index].id,1);
                    },
                  ):new FlatButton(
                    child: Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),

                    onPressed: () {
                      _SaveContacto(data[index].id,2);
                    },
                  )
                )
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

  void _SaveContacto(int participante,int tipo) async {
    final jobsListAPIUrl = 'https://admin.proexplo.com.pe/rest/isertarred';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usuario=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();

    Map data = {
      'usuario': usuario,
      'participante':participante,
      'idioma':IDIOMA,
      'tipo':tipo
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
