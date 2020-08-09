import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:proapp/Preguntavivo.dart';
import 'package:proapp/list_encuesta.dart';
import 'package:proapp/list_network.dart';
import 'package:proapp/list_participante.dart';
import 'package:proapp/list_ponente.dart';
import 'package:proapp/login.dart';
import 'package:proapp/programalist.dart';
import 'package:rounded_floating_app_bar/rounded_floating_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:proapp/web_view_container.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proapp/Programa.dart';

import 'Inscripcion.dart';
import 'Perfiledit.dart';
import 'list_preguntas.dart';
import 'localization/app_translations.dart';
import 'localization/applicationtra.dart';
import 'allTranslations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('token');

  // Initializes the translation module
  await allTranslations.init();
  // then start the application
  runApp(MaterialApp(home: email == null ? LoginPage() : MyApp(),debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFFFFFF),
      )));
}

class MyApp extends StatefulWidget  {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String EMAIL='';
  String IDIOMA='';

  SharedPreferences sharedPreferences;
  SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  void initState() {
    checkLoginStatus();
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
    super.initState();
    //_localeOverrideDelegate = new SpecificLocalizationDelegate(null);
  }

  _onLocaleChanged() async {
    // do anything you need to do if the language changes
    print('Language has been changed to: ${allTranslations.currentLanguage}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }else{
      setState(() {
        EMAIL=sharedPreferences.getString("token").toString();
        IDIOMA=sharedPreferences.getString("idioma").toString();

      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
        primaryColor: const Color(0xFFFFFFFF),
      ),localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: allTranslations.supportedLocales(),
    );
  }

}

class MainPage extends StatefulWidget  {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {

  final String language = allTranslations.currentLanguage;
  //final String buttonText= language=='fr' ? '=> English' : '=> Español';

  String EMAIL='';
  String IDIOMA='';
  String _TIPO='';
  String _FEC1='';
  String _TFEC1='';
  String _TTFEC1='';
  String _FEC2='';
  String _TFEC2='';
  String _TTFEC2='';
  String _FEC3='';
  String  _TFEC3 ='';
  String _TTFEC3 ='';

  SharedPreferences sharedPreferences;
  int _currentIndex = 0;

  //MENUMAHUSAMI
  List<Widget> _tabList = [
    Container(
      color: Colors.white70,
      child: Home()
    ),
    Container(
      color: Colors.white70,
      child:Programa()
    ),
    Container(
      color: Colors.white70,
      child:ListEncuesta(0,"General","G")
    ),
    Container(
      color: Colors.white70,
        child:ListNetwork(2,"Network")
    ),
    Container(
      color: Colors.white70,
        child:ProfilePageEdit()
    )

  ];
  TabController _tabController;

  @override
  void initState() {
    setState(() {
      setearsession();
    });

    super.initState();
    _tabController = TabController(vsync: this, length: _tabList.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  setearsession() async {

     sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _TIPO = sharedPreferences.getString("tokentipo").toString();
      _FEC1 = sharedPreferences.getString("tokenfec1").toString();
      _TFEC1 = sharedPreferences.getString("tokentfec1").toString();
      _TTFEC1 = sharedPreferences.getString("tokenttfec1").toString();
      _FEC2 = sharedPreferences.getString("tokenfec2").toString();
      _TFEC2 = sharedPreferences.getString("tokentfec2").toString();
      _TTFEC2 = sharedPreferences.getString("tokenttfec2").toString();
      _FEC3 = sharedPreferences.getString("tokenfec3").toString();
      _TFEC3 = sharedPreferences.getString("tokentfec3").toString();
      _TTFEC3 = sharedPreferences.getString("tokenttfec3").toString();
      print("ACAAA" + _FEC1);
    });

  }


  @override
  Widget build(BuildContext context) {

      return new Scaffold(
          appBar: new AppBar(
            titleSpacing: 0.0,
            title: ConstrainedBox(
              constraints: BoxConstraints(

                minWidth: 269,
                minHeight: 50,
                maxWidth: 269,
                maxHeight: 50,
              ),
              child: Image.asset('assets/images/logoapp.png', fit: BoxFit.contain, alignment: Alignment(-0.9, 0.0),),
            ),
            actions: <Widget>[
            PopupMenuButton<String>(
                // overflow menu
                onSelected:(String value) async {
                    //setState(()
                     await allTranslations.setNewLanguage(value);
                      setState((){
                        if(value=="es") {
                          sharedPreferences.setString("idioma", "1");
                        }else{
                          sharedPreferences.setString("idioma", "2");
                        }
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                            builder: (BuildContext context) => MainPage()), (
                            Route<dynamic> route) => false);
                      });

                    //});

                },
                icon: new Icon(Icons.language, color: Colors.grey),
                  itemBuilder: (_) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(
                        child: const Text('English'), value: 'en'),
                    new PopupMenuItem<String>(
                        child: const Text('Español'), value: 'es'),
                  ],
              )
            ],

          ),

          body: Container(
            decoration: BoxDecoration(
            image: DecorationImage(
              image: new ExactAssetImage('assets/images/fondo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
            child:TabBarView(
                    controller: _tabController,
                    children: _tabList,
                  )),
          bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.white70,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Colors.deepOrange), // sets the inactive color of the `BottomNavigationBar`
          child: new BottomNavigationBar(

            currentIndex: _currentIndex,
            type: BottomNavigationBarType.shifting ,
            items: [
              BottomNavigationBarItem(

                  icon: Icon(Icons.home,color: Colors.black),
                  title: new Text(
                      allTranslations.text('key_inicio')
                    ,style:TextStyle(fontSize: 12,color: Colors.deepOrange)),
                    activeIcon: Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.deepOrange,
                    ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.date_range,color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text(allTranslations.text('key_programa'),style:TextStyle(fontSize: 12,color: Colors.deepOrange)),
                activeIcon: Icon(
                  Icons.date_range,
                  size: 30,
                  color: Colors.deepOrange,
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assignment_turned_in,color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text(allTranslations.text('key_encuesta'),style:TextStyle(fontSize: 12,color: Colors.deepOrange)),
                activeIcon: Icon(
                  Icons.assignment_turned_in,
                  size: 30,
                  color: Colors.deepOrange,
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.group_work,color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text(allTranslations.text('key_network'),style:TextStyle(fontSize: 12,color: Colors.deepOrange)),
                activeIcon: Icon(
                  Icons.group_work,
                  size: 30,
                  color: Colors.deepOrange,
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_pin,color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text(allTranslations.text('key_perfil'),style:TextStyle(fontSize: 12,color: Colors.deepOrange)),
                activeIcon: Icon(
                  Icons.person_pin,
                  size: 30,
                  color: Colors.deepOrange,
                ),
              )
            ],
            onTap: (index){
              setState(() {
                _currentIndex = index;
              });

              _tabController.animateTo(_currentIndex);
            },
          )
      ));
    }
}

class Home extends StatelessWidget  {
  SharedPreferences  sharedPreferences;
  static String  _EMAIL="";
  static String _IDIOMA="";
  static String links = '';
  static String links2 = '';
  static String links3 = '';
  static String links4 = '';
  static String links5 = '';
  static String links6 = '';
  static String text1 = '';
  static String text2 = '';
  static String text3 = '';
  static String text4 = '';
  static String text5 = '';
  static String text6 = '';
  String linkferia="";
  String TIPOUSU="";

  @override
  void initState() {
    checkLoginStatus2();
  }
  checkLoginStatus2() async {
    sharedPreferences= await SharedPreferences.getInstance();

    if(sharedPreferences.getString("token") != null) {

      _EMAIL=sharedPreferences.getString("token").toString();
      _IDIOMA=sharedPreferences.getString("idioma").toString();
      linkferia=sharedPreferences.getString("linkferia").toString();
      TIPOUSU=sharedPreferences.getString("tokentipo").toString();

      links = 'http://admin.proexplo.com.pe/rest/bienvenida?idioma=1';
      links2 = 'http://admin.proexplo.com.pe/rest/sede?idioma=1';
      links3 = 'http://admin.proexplo.com.pe/rest/auspicios?idioma=1';
      links4 = 'http://admin.proexplo.com.pe/rest/notasprensa?idioma=1';
      links5 = 'http://admin.proexplo.com.pe/rest/plano?idioma=1';
      links6 = 'https://proexplo.com.pe/app/ficha?idioma=1&usuario='+_EMAIL.toString();
      text1 = allTranslations.text('key_bienvenida');
      text2 = allTranslations.text('key_sede');
      text3 = allTranslations.text('key_auspicio');
      text4 =  allTranslations.text('key_noticia');
      text5 =  allTranslations.text('key_plano');
      text6 = allTranslations.text('key_inscripcion');

    }
  }

    _launchURL2() async {
        String url = linkferia;
         if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
  }

  @override
  Widget build(BuildContext context) {

    checkLoginStatus2();


    return Scaffold(
        backgroundColor: Colors.transparent,
        key: Key('123'),
        body: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,

                  //crossAxisAlignment: CrossAxisAlignment.stretch,
               children: <Widget>[
                  SizedBox(height: 40,),
                   Row( mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                    _urlButton(context,allTranslations.text('key_link1'),allTranslations.text('key_bienvenida'),Icons.assignment,0),

                    _urlButtonLink(context,linkferia,allTranslations.text('key_sede'),Icons.settings_remote,1),
                     _urlButton(context,allTranslations.text('key_link4')
                         ,allTranslations.text('key_noticia'),Icons.speaker_notes,2),
                   ]),
                 SizedBox(height: 20,),
                   Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[

                    _urlButton(context,allTranslations.text('key_link3'),allTranslations.text('key_auspicio'),Icons.group,3),
                     _urlButton(context,allTranslations.text('key_link5'),allTranslations.text('key_plano'),Icons.map,4),
                    _urlButton(context,"inscripcion",allTranslations.text('key_inscripcion'),Icons.border_color,5)]

                   ),
                 SizedBox(height: 20,),
                   Row(mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       TIPOUSU=="1"?_urlButtonEnvivo(context):Container()
                     ]
                   )
              ]
                )
        );

  }

  Widget _urlButtonEnvivo(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white70,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              offset: Offset(2.0, 2.0),
              spreadRadius: 2.0)
        ],
      ),
      margin: EdgeInsets.all(5.0),
      child: SizedBox.fromSize(
        size: Size(95, 95), // button width and height

        child: ClipOval(

          child: Material(

            color: Colors.white70, // button color
            child: InkWell(
              splashColor: Colors.white70, // splash color
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListPreguntas(0,"Preguntas")));
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(Icons.help,size:35,color: Colors.deepOrange), // icon
                  new Text( allTranslations.text('key_pregunta'),style:TextStyle(color: Colors.deepOrange,fontSize: 12),), // text
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _urlButtonLink(BuildContext context, String url,String texto,IconData ico,int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index%2==0?Colors.orange:Colors.teal,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              offset: Offset(2.0, 2.0),
              spreadRadius: 2.0)
        ],
      ),
      margin: EdgeInsets.all(5.0),
      child: SizedBox.fromSize(
        size: Size(95, 95), // button width and height

        child: ClipOval(

          child: Material(

            color: index%2==0?Colors.orange:Colors.teal, // button color
            child: InkWell(
              splashColor: Colors.orange, // splash color
              onTap: () { _launchURL2(); }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(ico,size:35,color: Colors.white), // icon
                  new Text(texto,style:TextStyle(color: Colors.white,fontSize: 12),), // text
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _urlButton(BuildContext context, String url,String texto,IconData ico,int index) {
    return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index%2==0?Colors.orange:Colors.teal,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
                offset: Offset(2.0, 2.0),
                spreadRadius: 2.0)
          ],
        ),
        margin: EdgeInsets.all(5.0),
        child: SizedBox.fromSize(
          size: Size(95, 95), // button width and height

          child: ClipOval(

            child: Material(

              color: index%2==0?Colors.orange:Colors.teal, // button color
              child: InkWell(
                splashColor: Colors.orange, // splash color
                onTap: () {
                  _handleURLButtonPress(context, url,texto);

                }, // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(ico,size:35,color: Colors.white), // icon
                    new Text(texto,style:TextStyle(color: Colors.white,fontSize: 12),), // text
                  ],
                ),
              ),
            ),
          ),
        ),
        );
  }

  void _handleURLButtonPress(BuildContext context, String url,String texto) {
    if(url=="inscripcion"){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => InscripcionPageEdit()));

    }else{
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url,texto)));
    }
  }



}


final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day']
};

class Programa extends StatelessWidget {

  String _TIPO='';
  String _FEC1='';
  String _TFEC1='';
  String _TTFEC1='';
  String _FEC2='';
  String _TFEC2='';
  String _TTFEC2='';
  String _FEC3='';
  String _TFEC3='';
  String _TTFEC3='';

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),

      home: Myprograma('Programa',_TIPO,_FEC1,_TFEC1,_TTFEC1,_FEC2,_TFEC2,_TTFEC2,_FEC3,_TFEC3,_TTFEC3),
    );
  }



}

class Myprograma extends StatefulWidget {
  String title="";
  String TIPO;
  String FEC1;
  String TFEC1;
  String TTFEC1;
  String FEC2;
  String TFEC2;
  String TTFEC2;
  String FEC3;
  String TFEC3;
  String TTFEC3;
  Myprograma(this.title,this.TIPO,this.FEC1,this.TFEC1,this.TTFEC1,
      this.FEC2,this.TFEC2,this.TTFEC2,this.FEC3,this.TFEC3,this.TTFEC3);
  @override
  _MyProgramaState createState() => _MyProgramaState(this.title,this.TIPO,this.FEC1,this.TFEC1,this.TTFEC1,
      this.FEC2,this.TFEC2,this.TTFEC2,this.FEC3,this.TFEC3,this.TTFEC3);

}

class _MyProgramaState extends State<Myprograma> with TickerProviderStateMixin {

  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  SharedPreferences sharedPreferences;
  String URL = "https://admin.proexplo.com.pe/rest";
  List datalistprograma;
  String EMAIL;
  String IDIOMA;
  String FECHA;
  String _TITLE;
  String _TIPOP="C";
  String _TIPO;
  String _FEC1;
  String _TFEC1;
  String _TTFEC1;
  String _FEC2;
  String _TFEC2;
  String _TTFEC2;
  String _FEC3;
  String _TFEC3;
  String _TTFEC3;
  String _TTFEC4;
  String _TFEC4;
  String _FEC4;
  String _TTFEC5;
  String _TFEC5;
  String _FEC5;
  String _TTFEC6;
  String _TFEC6;
  String _FEC6;
  String _TEXTOBUS;
  final TextEditingController buscarController = new TextEditingController();
  _MyProgramaState(this._TITLE,this._TIPO,this._FEC1,this._TFEC1,this._TTFEC1,
      this._FEC2,this._TFEC2,this._TTFEC2,
      this._FEC3,this._TFEC3,this._TTFEC3);
  final _key = UniqueKey();
  @override
  void initState() {
    setearsession();
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: -80)): ['Evento'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

  }

  setearsession() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _TIPO = sharedPreferences.getString("tokentipo").toString();
      _FEC1 = sharedPreferences.getString("tokenfec1").toString();
      _TFEC1 = sharedPreferences.getString("tokentfec1").toString();
      _TTFEC1 = sharedPreferences.getString("tokenttfec1").toString();
      _FEC2 = sharedPreferences.getString("tokenfec2").toString();
      _TFEC2 = sharedPreferences.getString("tokentfec2").toString();
      _TTFEC2 = sharedPreferences.getString("tokenttfec2").toString();
      _FEC3 = sharedPreferences.getString("tokenfec3").toString();
      _TFEC3 = sharedPreferences.getString("tokentfec3").toString();
      _TTFEC3 = sharedPreferences.getString("tokenttfec3").toString();

      _FEC4 = sharedPreferences.getString("tokenfec4").toString();
      _TFEC4 = sharedPreferences.getString("tokentfec4").toString();
      _TTFEC4 = sharedPreferences.getString("tokenttfec4").toString();

      _FEC5 = sharedPreferences.getString("tokenfec5").toString();
      _TFEC5 = sharedPreferences.getString("tokentfec5").toString();
      _TTFEC5 = sharedPreferences.getString("tokenttfec5").toString();

      _FEC6 = sharedPreferences.getString("tokenfec6").toString();
      _TFEC6 = sharedPreferences.getString("tokentfec6").toString();
      _TTFEC6 = sharedPreferences.getString("tokenttfec6").toString();

    });

  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
        FECHA=day.toString();
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    resizeToAvoidBottomInset : false,
      body: Column(
        mainAxisSize: MainAxisSize.max,

        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          const SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
            _FEC1!=''?_urlButtonDay(context,_FEC1,_TFEC1,_TTFEC1):Container(),
            _FEC2!=''?_urlButtonDay(context,_FEC2,_TFEC2,_TTFEC2):Container(),
            _FEC3!=''?_urlButtonDay(context,_FEC3,_TFEC3,_TTFEC3):Container(),
            _FEC4!=''?_urlButtonDay(context,_FEC4,_TFEC4,_TTFEC4):Container(),
            _FEC5!=''?_urlButtonDay(context,_FEC5,_TFEC5,_TTFEC5):Container(),
            _FEC6!=''?_urlButtonDay(context,_FEC6,_TFEC6,_TTFEC6):Container(),
          ]
          ),
          //_buildTableCalendar(),
          const SizedBox(height: 5.0),
          ToggleSwitch(
              minWidth: 90.0,
              cornerRadius: 20,
              activeBgColor: Colors.green,
              activeTextColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveTextColor: Colors.white,
              labels: ['ORALES', 'POSTERS'],
              activeColors: [Colors.teal, Colors.deepOrange],
              onToggle: (index) {
                  if(index==0){
                    setState(() {
                      _TIPOP='C';
                    });

                  }else{
                    setState(() {
                      _TIPOP='P';
                    });
                  }
              }),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            margin: EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                new Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: buscarController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (term){
                      setState(() {
                        _TEXTOBUS=buscarController.text;
                      });

                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: allTranslations.text("key_search").toString(),
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      isDense: true,
                    ),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
          // _buildTableCalendarWithBuilders(),

          Expanded(child: FutureBuilder<List<Job>>(
                  future: _fetchJobs(FECHA),
                  builder: (context, snapshot) {
                  if (snapshot.hasData) {
                  List<Job> data = snapshot.data;
                  return _jobsListView(data);
                  } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              return CircularProgressIndicator();
            },
    )),
        ],
      ),
    );
  }

  Widget _urlButtonDay(BuildContext context, String url,String texto,String subtilt)  {

    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.orange,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              offset: Offset(2.0, 2.0),
              spreadRadius: 2.0)
        ],
      ),
      margin: EdgeInsets.all(5.0),
      child: SizedBox.fromSize(
        size: Size(45,45), // button width and height

        child: ClipOval(
          child: Material(
            color: Colors.orange, // button color
            child: InkWell(
              splashColor: Colors.orange, // splash color
              onTap: () {
                    setState(() {
                      FECHA=url;
                    });
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(texto,style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),), // text
                  new Text(subtilt,style:TextStyle(color: Colors.white,fontSize: 7),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      //locale:'us_US',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.week,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.orange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,

      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 11.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)


  Future<List<Job>> _fetchJobs(String fec) async {

    final jobsListAPIUrl = 'https://admin.proexplo.com.pe/rest/getprograma';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String EMAIL=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();

    Map data = {
      'email': EMAIL,
      'idioma':IDIOMA,
      'fecha':FECHA,
      'tipo':_TIPOP,
      'texto':buscarController.text.toString()
    };

    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(jobsListAPIUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    String respuestajson = await response.transform(utf8.decoder).join();
    print(respuestajson);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(respuestajson);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }


  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            shape: getborder(data[index].tipo,index,data[index].importante),
            color:getMyColor(data[index].tipo),
            child: new Container(
              child: new Center(
                  child: new Column(
                    // Stretch the cards in horizontal axis
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                       new Text(
                        // Read the name field value and set it in the Text widget
                        data[index].nombre,
                      textAlign: data[index].tipo=='P'?TextAlign.left:TextAlign.center,
                        // set some style to text
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,fontSize: getMytam(data[index].tipo), color: getMyColorletra(data[index].tipo)),
                        ),
                      data[index].tipo=='P'? SizedBox(height: 10.0):SizedBox(height: 0.0),
                        new Text(
                          // Read the name field value and set it in the Text widget
                            data[index].tipo=='P'? "  "+data[index].ponente:"",
                          // set some style to text
                          style: new TextStyle(
                              fontSize: data[index].tipo=='P'?13.0:0.0, color: Colors.amber),
                        ),
                      data[index].tipo=='P'||data[index].tipo=='R'? SizedBox(height: 10.0):SizedBox(height: 0.0),
                      new Text(
                        // Read the name field value and set it in the Text widget
                        data[index].tipo=='P'||data[index].tipo=='R'? "  "+data[index].horario+"  ":"",

                        // set some style to text
                        style: new TextStyle(
                            fontSize: data[index].tipo=='P'||data[index].tipo=='R'?10.0:0.0, color: Colors.white,fontWeight: FontWeight.bold,backgroundColor: Colors.deepOrange),
                      ),
                      data[index].tipo=='P'?getbotones(data[index].tipo,data[index].id,data[index].encuesta,data[index].link,data[index].nombre,data[index].fecha,data[index].hi,
                      data[index].hf, data[index].ponente,data[index].asistio,data[index].envivo):SizedBox(height: 0.0)

                    ],
                  )),
              padding: const EdgeInsets.all(8.0),
            ),
          );

        });
  }

  Color getMyColor(String tipo) {
    Color col;
    if (tipo == "S") {
       col=Colors.orange;
    }
    if (tipo=="G")  {
     col=Colors.black12;
    }
    if (tipo=="R")  {
      col=Colors.green;
    }
    if (tipo=="P")  {
      col=Colors.white;
    }
    return col;
  }

  ButtonBar getbotones(String tipo,int id,int encuesta,String enlace,String nombre,String fecha,String hi,String hf,
      String ponente,int asistio,int envivo) {
    ButtonBar col;
    final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
    if (tipo=="P")  {
      col=  ButtonBar(
        buttonPadding: new EdgeInsets.all(0.0),

        alignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(

            children: <Widget>[
              Column(
                children: <Widget>[
            SizedBox(
                 width: 40,
                child:encuesta>0?new FlatButton(
                    child: Icon(
                      Icons.receipt,
                      color: Colors.white,
                      size: 18,
                    ),
                    color: Colors.teal,
                    shape: CircleBorder(),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ListEncuesta(id,nombre,"P")));
                    },
                  ):Container()),
                ],
              ),
              Column(
                children: <Widget>[
                SizedBox(
                width: 50,
                child:enlace!=""?
                  new FlatButton(
                    child: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                      size: 18,
                    ),
                    color: Colors.deepOrange,
                    shape: CircleBorder(),
                    onPressed: () {
                            //Descargar archivo flutter
                            if(enlace!=""){

                              _launchURL(enlace);

                            }else{
                              Fluttertoast.showToast(
                                  msg: "Archivo no disponible",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1
                              );
                            }
                    },
                  ):Container()),
                ],
              ),
              Column(
                children: <Widget>[
              envivo>0?SizedBox(
                width: 50,
                  child:new FlatButton(
                    child: Icon(
                      Icons.help,
                      color: Colors.white,
                      size: 18,
                    ),
                    color: Colors.teal,
                    shape: CircleBorder(),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Preguntavivo(id,nombre)));
                    },
                  )):SizedBox(width: 0,),
                ],
              ),
              Column(
                children: <Widget>[
                SizedBox(
                width: 50,
                  child:new FlatButton(
                    child: Icon(
                      Icons.date_range,
                      color: Colors.white,
                      size: 18,
                    ),
                    color: Colors.deepOrange,
                    shape: CircleBorder(),
                    onPressed: () {
                      String dateWithT1 = fecha + 'T' + hi;
                      String dateWithT2 = fecha + 'T' + hf;

                      final Event event = Event(
                        title: nombre,
                        description: ponente,
                        location: 'ProExplo',
                        startDate:  DateTime.parse(dateWithT1),
                        endDate:  DateTime.parse(dateWithT2),
                      );


                      Add2Calendar.addEvent2Cal(event).then((success) {
                        scaffoldState.currentState.showSnackBar(
                            SnackBar(content: Text(success ? 'Success' : 'Error')));
                      });
                    },
                  )),
                ],
              ),
              Column(
                children: <Widget>[
                SizedBox(
                width: 50,
                  child:new FlatButton(
                    child: Icon(
                      Icons.group,
                      color: Colors.white,
                      size: 18,
                    ),
                    color: Colors.teal,
                    shape: CircleBorder(),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ListParticipante(id,nombre)));
                    },
                  )),
                ],
              ),
              Column(
                children: <Widget>[
                  asistio==0?SizedBox(
    width: 50,
    child:new FlatButton(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.black87,
                      size: 18,
                    ),
                    color: Colors.yellow,
                    shape: CircleBorder(),
                    onPressed: () {
                      _SaveAsistencia(id);
                    },
                  )):SizedBox(
    width: 50,
    child:new FlatButton(
                    child: Icon(
                      Icons.star_half,
                      color: Colors.orange,
                      size: 18,
                    ),
                    color: Colors.yellow,
                    shape: CircleBorder(),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ListPonente(id,nombre)));
                    },
                  )),
                ],
              ),

            ],

          ),

        ],

      );
    }else{
      col=ButtonBar();
    }
    return col;
  }

  _launchURL(String url2) async {
    String url = url2;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Border getborder(String tipo,int ix,int importante){
    Border col;
    if (tipo=="P" && importante==0)  {
       if(ix%2==0){
         col = Border(left: BorderSide(color: Colors.orange, width: 5));
       } else {
         col = Border(left: BorderSide(color: Colors.teal, width: 5));
       }
    }else if(tipo=="P" && importante==1){
      col=Border(left: BorderSide(color: Colors.red, width: 2),right: BorderSide(color: Colors.red, width: 2),
      top:BorderSide(color: Colors.red, width: 2),bottom: BorderSide(color: Colors.red, width: 2) );
    }else{
      col=Border(left: BorderSide(color: Colors.red, width: 0));
    }
    return col;
  }

  Color getMyColorletra(String tipo) {
    Color col;
    if (tipo == "S") {
      col=Colors.white;
    }
    if (tipo=="G")  {
      col=Colors.white;
    }
    if (tipo=="R")  {
      col=Colors.white;
    }
    if (tipo=="P")  {
      col=Colors.black87;
    }
    return col;
  }

  double getMytam(String tipo) {
    double col;
    if (tipo == "S") {
      col=14;
    }
    if (tipo=="G")  {
      col=11;
    }
    if (tipo=="R")  {
      col=11;
    }
    if (tipo=="P")  {
      col=16;
    }
    return col;
  }

    void _SaveAsistencia(int programa) async {

    final jobsListAPIUrl = 'https://admin.proexplo.com.pe/rest/isertarparti';
    //final response = await http.get(jobsListAPIUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String parti=sharedPreferences.getString("token").toString();
    String IDIOMA=sharedPreferences.getString("idioma").toString();

    Map data = {
      'programa': programa,
      'participante':parti,
      'idioma':IDIOMA
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
