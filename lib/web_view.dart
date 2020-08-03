import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer2 extends StatefulWidget {
  final url;
  final title;
  WebViewContainer2(this.url,this.title);

  @override
  createState() => _WebViewContainerState2(this.url,this.title);
}

class _WebViewContainerState2 extends State<WebViewContainer2> {
  var _url;
  var _title;
  bool _isLoadingPage;
  final _key = UniqueKey();

  _WebViewContainerState2(this._url,this._title);
  @override
  void initState() {
    super.initState();
    _isLoadingPage = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
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
        ));
  }
}
