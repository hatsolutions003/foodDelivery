import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';


class HomePopUpPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePopUpPageState();
  }
}

class HomePopUpPageState extends State<HomePopUpPage>{
  ProgressHUD progressHUD;
  String url;
  WebViewController webViewController;

  HomePopUpPageState(){
    url =
    "https://ladekitchen.com/";
  }

  @override
  Widget build(BuildContext context) {
    if(progressHUD == null){
      progressHUD = new ProgressHUD(
        backgroundColor: Colors.black12,
        color: Color(0xFF075E55),
        containerColor: Colors.transparent,
        borderRadius: 5.0,
        text: '',
        loading: true,
      );
      //handleInstagramLogin();
    }
    return WillPopScope(
      onWillPop: onPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                buildStatusBar(),
                buildActionBar(),
                Expanded(
                  child: WebView(
                    initialUrl: url,
                    onWebViewCreated: (controller) async {
                      webViewController = controller;
                      await controller.clearCache();
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageStarted: (url){
                      showProgressDialog(true);
                    },
                    onPageFinished: (url){
                      showProgressDialog(false);
                    },
                  ),
                ),
                buildSafeArea(),
              ],
            ),
            progressHUD,
          ],
        ),
      ),
    );
  }

  Future<bool> onPop() async {
    //await flutterWebviewPlugin.close();
    Navigator.pop(context);
  }

  Widget buildStatusBar() {
    return Container(
      height: MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
          color: Color(0xFF075E55)
      ),
    );
  }

  Widget buildSafeArea() {
    return Container(
      height: MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
          color: Color(0xFF075E55)
      ),
    );
  }

  Widget buildActionBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 60.0,
          decoration: BoxDecoration(
              color: Color(0xFF075E55)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Navigator.canPop(context) ? InkWell(
                onTap: () async {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    //await flutterWebviewPlugin.close();
                  } else {
                    Navigator.pop(context, true);
                  }
                },
                child: Container(
                  height: 50,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ) : Container(width: 15,),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15),
                height: 50,
                child: Text('Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.5,
                    fontFamily: 'bold',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showProgressDialog(bool value) {
    setState(() {
      if (value) {
        progressHUD.state.show();
      } else {
        progressHUD.state.dismiss();
      }
    });
  }
}