import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:proapp/Ponente.dart';

import 'Perfilview.dart';
class ListPonente extends StatefulWidget {
  final idprograma;
  final title;
  ListPonente(this.idprograma,this.title);

  /*@override
  createState() => _ListPonenteState(this.idprograma,this.title);*/
  @override
  _ListPonenteState createState() => _ListPonenteState(this.idprograma,this.title);
}

class _ListPonenteState extends State<ListPonente> {
  var _idprograma;
  var _title;
  bool _isLoadingPage;
  final _key = UniqueKey();

  _ListPonenteState(this._idprograma,this._title);
  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(child:FutureBuilder<List<Job3>>(
              future: _fetchJobs2(_idprograma),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  List<Job3> data = snapshot2.data;
                  return _jobsListView2(data);
                } else if (snapshot2.hasError) {
                  return Text("${snapshot2.error}");
                }
                return CircularProgressIndicator();
              },
            ))

        );
  }

  Future<List<Job3>> _fetchJobs2(int idprog) async {

    final jobsListAPIUrl2 = 'https://admin.proexplo.com.pe/rest/getponente';
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
      return jsonResponse.map((job3) => new Job3.fromJson(job3)).toList();
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

                title: Text(
                  data[index].nombre,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold,fontSize: 15),

                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),


                trailing: Container(child:
                RatingBar(
                  initialRating:  (data[index].puntaje).toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 25,
                  itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _SaveMarca(data[index].id,rating);
                  },
                ),
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

  void _SaveMarca(int expos,double rating) async {
    final jobsListAPIUrl = 'https://admin.proexplo.com.pe/rest/isertarmarca';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usuario=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();

    Map data = {
      'usuario': usuario,
      'ponente':expos,
      'idioma':IDIOMA,
      'rating':rating
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
      throw Exception('Failed to load save marca');
    }
  }
}
