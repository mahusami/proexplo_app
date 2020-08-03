import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final title;
  WebViewContainer(this.url,this.title);

  @override
  createState() => _WebViewContainerState(this.url,this.title);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  var _title;
  bool _isLoadingPage;
  final _key = UniqueKey();

  _WebViewContainerState(this._url,this._title);
  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(51.0),
          child:AppBar(
          titleSpacing: 0.0,
          title: ConstrainedBox(
              constraints: BoxConstraints(

              minWidth: 269,
              minHeight: 50,
              maxWidth: 269,
              maxHeight: 50,
              ),
              child: Image.asset('assets/images/logoapp.png', fit: BoxFit.contain, alignment: Alignment(-0.9, 0.0),),
              )),),
        body:
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new ExactAssetImage('assets/images/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child:Stack(
              children: <Widget>[
                new WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url,
                    onPageFinished: (String url) {
                      // should be called when page finishes loading
                        setState(() {
                          _isLoadingPage  = false;
                        });
                    }),
            _isLoadingPage ? Center( child: CircularProgressIndicator()) : Container(),
          ],
        )));
  }
}
