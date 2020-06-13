import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ReserveTablePopUpPage extends StatefulWidget {
  @override
  _ReserveTablePopUpPageState createState() => new _ReserveTablePopUpPageState();
}

class _ReserveTablePopUpPageState extends State<ReserveTablePopUpPage> {

  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075E55),
          title: const Text('Reserve a Table'),
          leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios
            ),
          ),
        ),
        body: Container(
            child: Column(children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(20.0),
//                child: Text(
//                    "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
//              ),
//              Container(
//                  padding: EdgeInsets.all(10.0),
//                  child: progress < 1.0
//                      ? LinearProgressIndicator(value: progress)
//                      : Container()),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  child: InAppWebView(
                    initialUrl: "https://tableagent.com/iframe/qar-kitchen/v/medium/",
                    initialHeaders: {},
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: false,
                        )
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {
                      setState(() {
                        this.url = url;
                      });
                    },
                    onLoadStop: (InAppWebViewController controller, String url) async {
                      setState(() {
                        this.url = url;
                      });
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}