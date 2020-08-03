import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proapp/web_view.dart';
import 'package:proapp/web_view_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:proapp/Encuesta.dart';

import 'Perfilview.dart';
class ListEncuesta extends StatefulWidget {
  final idprograma;
  final title;
  final tipo;
  ListEncuesta(this.idprograma,this.title,this.tipo);

  /*@override
  createState() => _ListEncuestaState(this.idprograma,this.title);*/
  @override
  _ListEncuestaState createState() => _ListEncuestaState(this.idprograma,this.title,this.tipo);
}

class _ListEncuestaState extends State<ListEncuesta> {
  var _idprograma;
  var _title;
  var _tipo;
  bool _isLoadingPage;
  String __usuario;
  String __idioma;
  SharedPreferences sharedPreferences1;
  final _key = UniqueKey();

  _ListEncuestaState(this._idprograma,this._title,this._tipo);
  @override
  void initState() {
    super.initState();
    getSharedPrefs();


    _isLoadingPage = true;
  }
    Future<Null> getSharedPrefs() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      __usuario = prefs.getString("token");
      __idioma = prefs.getString("idioma");
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

            body: Center(child:FutureBuilder<List<Job4>>(
              future: _fetchJobs2(_idprograma),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  List<Job4> data = snapshot2.data;
                  return _jobsListView2(data);
                } else if (snapshot2.hasError) {
                  return Text("${snapshot2.error}");
                }
                return CircularProgressIndicator();
              },
            ))

        );
  }

  Future<List<Job4>> _fetchJobs2(int idprog) async {

    final jobsListAPIUrl2 = 'https://admin.proexplo.com.pe/rest/getencuesta';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usuario=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();

    Map data = {
      'programa': idprog,
      'usuario':usuario,
      'idioma':IDIOMA,
      'tipo':_tipo
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
      return jsonResponse.map((job4) => new Job4.fromJson(job4)).toList();
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
                      Icons.receipt,
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    onPressed: () {


                    },
                  ),

                ),
                title: Text(
                  data[index].nombre,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold,fontSize: 15),

                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),


                trailing: Container(width: 40,child:
                data[index].realizada==0? new FlatButton(
                    child: Icon(
                    Icons.mode_edit,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    String uu="http://admin.proexplo.com.pe/rest/getdetalleencuesta?usuario="+__usuario+"&ididioma="+__idioma+"&id="+data[index].id.toString();
                    if(_tipo=="P"){
                      _handleURLButtonPress2(context,uu,"Encuesta");
                      }else{
                      _handleURLButtonPress(context,uu,"Encuesta");
                      }
                    },
                  ):Container(child: Icon(
                  Icons.check_circle,
                  color: Colors.black,
                   ))
                )
            ),
          );

        });
  }
  void _handleURLButtonPress(BuildContext context, String url,String texto) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url,texto)));
  }

  void _handleURLButtonPress2(BuildContext context, String url,String texto) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer2(url,texto)));
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
