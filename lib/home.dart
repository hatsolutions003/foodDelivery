import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddelivery/cart.dart';
import 'package:fooddelivery/major_menu_picker.dart';
import 'package:fooddelivery/models/cart.dart';
import 'package:fooddelivery/services.dart';
import 'package:fooddelivery/sparkling_picker.dart';
import 'package:fooddelivery/webView.dart';
import 'package:fooddelivery/webView2.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/dom.dart' as dom;

import 'cheese_burger_picker.dart';
import 'models/menu.dart';
import 'models/presentation.dart';
import 'models/product.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Support support;
  ProgressHUD progressHUD;
  @override
  Widget build(BuildContext context) {
    if (support == null) {
      support = Support(this.context, updateState, progressDialog);
      progressHUD = new ProgressHUD(
        backgroundColor: Colors.black12,
        color: Color(0xFF075E55),
        containerColor: Colors.transparent,
        borderRadius: 5.0,
        text: 'Loading...',
        loading: true,
      );
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              support.statusBar(),
              support.actionBar(),
              support.menuList != null ? support.menuBar() : Container(),
              SizedBox(
                height: 3,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFEDEDED),
              ),
              support.tempList != null ? support.itemGridView() : Container(),
              support.safeArea(),
            ],
          ),
          progressHUD,
          Positioned(
            top: (MediaQuery.of(context).padding.top + 60),
            child: support.dropDownContainer(),
          )
        ],
      ),
    );
  }

  void initState() {
    // TODO: implement initState
//    support.scrollController.addListener(() {
//      if(support.scrollController.offset > 50)
//      {
////          closePresentationContainer = scrollController.offset > 50;
//        support.closePresentationContainer = true;
//      }
//      else if(support.scrollController.offset < 50)
//      {
//        support.closePresentationContainer = false;
//      }
//      updateState();
//    });
    super.initState();
  }

  void updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void progressDialog(bool value) {
    setState(() {
      if (value) {
        progressHUD.state.show();
      } else {
        progressHUD.state.dismiss();
      }
    });
  }
}

class Support {
  BuildContext context;
  Function updateState, progressDialog;
  List<ProductModel> itemsList;
  List<ProductModel> tempList;
  List<MenuModel> menuList;
  List<String> languageList = ['English', 'Spanish', 'Swedish'];
  List<String> deliveryTypeList = ['Eat in', 'Take away'];
  String selectedLanguage = 'en';
  List<DropDownlist> dropDownList = [
    DropDownlist('Home'),
    DropDownlist('Reserve a Table')
  ];
  DropDownlist dropDownList2;
  PresentationModel presentationData;
  ScrollController scrollController = ScrollController();
  bool closePresentationContainer = false;

  static int cartQuantity;

  int selectedMenu = 0;
  double dropDownHeight = 0;
  String deliveryType = '';
  int deliveryindex = 0;

  SharedPreferences preferences;

  Support(this.context, this.updateState, this.progressDialog) {
    SharedPreferences.getInstance().then((preferencesInstance) {
      preferences = preferencesInstance;
      preferences.setStringList('cartList', []);
      cartQuantity = 0;
    });

    scrollController.addListener(() {
      if (scrollController.offset > 10) {
        closePresentationContainer = true;
      }
      updateState();
    });
    getMenuData();
  }

  Widget statusBar() {
    return Container(
      height: MediaQuery.of(context).padding.top,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFCFDBD9),
    );
  }

  Widget safeArea() {
    return Container(
      height: MediaQuery.of(context).padding.bottom,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFCFDBD9),
    );
  }

  Widget actionBar() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 2),
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFF075E55),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (dropDownHeight == 120) {
                      dropDownHeight = 0;
                    } else {
                      dropDownHeight = 120;
                    }
                    updateState();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Image.asset('assets/images/open-menu.png'),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                deliveryContainer()
//                Container(
//                  alignment: Alignment.centerLeft,
//                  height: 40,
//                  width: 104,
//                  decoration: BoxDecoration(
//                    image: DecorationImage(
//                      image: ExactAssetImage('assets/images/open-menu.png'),
//                    ),
//                  ),
//                  child: dropDownContainer(),
////                    width: MediaQuery.of(context).size.width/4,
//  //                  padding: EdgeInsets.only(top: 19),
////                    child: null
////                    Column(
////                      children: <Widget>[
////                        Text('Home', style: TextStyle(fontSize: 18, color: Colors.white),),
////                        SizedBox(height: 2,),
////                        Container(
////                          height: 2,
////                          width: 50,
////                          color: Colors.white,
////                        )
////                      ],
////                    )
//                ),
//                SizedBox(width: 10,),
//                InkWell(
//                  onTap: (){
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReserveTablePopUpPage()));
//                  },
//                    child: Text('Reserve a Table', style: TextStyle(fontSize: 18, color: Colors.white),)),
//                SizedBox(width: 10,),
//                InkWell(
//                  onTap: (){
//                    languageDialog();
//                  },
//                    child: Text('Language', style: TextStyle(fontSize: 18, color: Colors.white),)),
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartPage(deliveryindex)))
                    .then((onValue) {
                  cartQuantity = 0;
                  updateState();
                  getCartQuantity();
                });
              },
              child: Container(
                height: 55,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        height: 17,
                        width: 17,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: Text(cartQuantity.toString()),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget dropDownContainer() {
    return AnimatedContainer(
      curve: Curves.bounceOut,
      duration: Duration(seconds: 400),
      child: InkWell(
        onTap: () {
          if (dropDownHeight == 120) {
            dropDownHeight = 0;
          } else {
            dropDownHeight = 120;
          }
          updateState();
        },
        child: Container(
          padding: EdgeInsets.all(10),
          color: Color(0xFF075E55),
          height: dropDownHeight,
          width: MediaQuery.of(context).size.width / 2,
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.all(0),
            children: <Widget>[
              InkWell(
                onTap: () {
                  dropDownHeight = 0;
                  updateState();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePopUpPage()));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  child: Text(
                    'Home',
                    style: TextStyle(
                        fontSize: 20.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 1,
                color: Colors.white,
              ),
              SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  dropDownHeight = 0;
                  updateState();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReserveTablePopUpPage()));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    'Reserve a Table',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

//    return Container(
////      color: Colors.red,
////      width: MediaQuery.of(context).size.width/3,
//      alignment: Alignment.centerLeft,
//      child: DropdownButton<DropDownlist>(
//        iconSize: 0,
//        underline: Container(),
//
////      value: selectedUser,
//        onChanged: (DropDownlist Value) {
////          selectedUser = Value;
//
//        },
//        items: dropDownList.map((DropDownlist data) {
//          return  DropdownMenuItem<DropDownlist>(
//
//            value: data,
//            child: Container(
//              color: Colors.red,
////              width: MediaQuery.of(context).size.width/4,
//                child: Text(data.name, style:  TextStyle(
//                    color: Colors.black,),)),
//          );
//        }).toList(),
//      ),
//    );
  }

  Widget menuBar() {
    return Container(
      height: 55,
      child: ListView.builder(
        itemBuilder: menuItems,
        itemCount: menuList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget menuItems(BuildContext, int index) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
//        progressDialog(true);
        selectedMenu = index;
        double counter = 0;
        for(int i = 0; i < itemsList.length; i++)
          {
            if(menuList[index].id == itemsList[i].groupid)
              {
                break;
              }
            else{
              counter++;
            }
          }
        if(selectedMenu == 0)
          {
            scrollController.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.bounceOut);
          }
        else{
          scrollController.animateTo((counter * 160), duration: Duration(milliseconds: 1000), curve: Curves.bounceOut);
        }

        print(counter);
        print(itemsList.indexOf(itemsList[index]));
        updateState();
//        filters();
      },
      child: Container(

        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        decoration: BoxDecoration(
          color: Color(0xFFCFDBD9),
          borderRadius: BorderRadius.circular(20)
        ),
        height: 40,
        child: Text(
          menuList[index].name,
          style: TextStyle(
            color: selectedMenu == index? Colors.white : Colors.black
          ),
        ),
      ),
    );
  }

  double presentationContainerHeight = 350;

  Widget itemGridView() {
    if (selectedMenu == 0) {
      scrollController.addListener(() {
        if (scrollController.offset > 10) {
          closePresentationContainer = true;
        } else {
          closePresentationContainer = false;
        }
        updateState();
      });
    } else {
      closePresentationContainer = true;
      updateState();
    }
    return Expanded(
      child: Column(
        children: <Widget>[
          AnimatedOpacity(
            duration: Duration(milliseconds: 1000),
            opacity: closePresentationContainer ? 0 : 1,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              alignment: Alignment.topCenter,
              height:
                  closePresentationContainer ? 0 : presentationContainerHeight,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: presentationContainerHeight,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 120,
                      child: CachedNetworkImage(
                        imageUrl: presentationData.url,
                        fit: BoxFit.fill,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Html(
                        customTextAlign: (_) {
                          return TextAlign.start;
                        },
                        data: presentationData.name,
                        showImages: false,
                        defaultTextStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'regular',
                        ),
                        customTextStyle: (dom.Node node, TextStyle baseStyle) {
                          if (node is dom.Element) {
                            switch (node.localName) {
                              case "p":
                                return baseStyle.merge(TextStyle(
                                    color: Color(0xFF666666),
                                    fontFamily: 'regular',
                                    fontSize: 13));
                                break;
                              case "h1":
                                return baseStyle.merge(TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontFamily: 'bold'));
                                break;
                            }
                          }
                          return baseStyle;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 3, right: 3, top: 0),
            height: closePresentationContainer
                ? MediaQuery.of(context).size.height / 1.33
                : MediaQuery.of(context).size.height / 2.33,
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              padding: EdgeInsets.all(0),
              controller: scrollController,
//          physics: ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.6
//            MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.04)
                  ),
              itemBuilder: itemCard,
              itemCount: tempList.length,
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  Widget itemCard(BuildContext, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Column(
        children: <Widget>[
          Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: tempList[index].imageurl,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                        value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 45,
                  child: Text(
                    tempList[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 50,
                  child: Text(
                    tempList[index].description,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '\$' + tempList[index].price,
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {

                        if(selectedMenu == 0)
                          {
                            if (itemsList[index].id == '6')
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Cheese_burger_picker(itemsList[index]))).then((value) {
                                cartQuantity = 0;
                                updateState();
                                getCartQuantity();
                              });
                            }
                            else if(itemsList[index].id == '16')
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MajorMenuBox(itemsList[index])));
                            }
                            else if(itemsList[index].id == '13')
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SparklingBox(itemsList[index])));
                            }
                            else{
                              addToCart(index);
                            }
                          }
                        else{
                          print(index);
                          if (tempList[index].id == '6')
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Cheese_burger_picker(tempList[index]))).then((value) {
                              cartQuantity = 0;
                              updateState();
                              getCartQuantity();
                            });
                          }
                          else if(tempList[index].id == '16')
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MajorMenuBox(tempList[index])));
                          }
                          else if(tempList[index].id == '13')
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SparklingBox(tempList[index])));
                          }
                          else{
                            addToCart(index);
                          }
                        }

                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Color(0xFFFAF4D1),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.5,
                              blurRadius: 1,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getMenuData() {

    cartQuantity = 0;
    String url = 'https://bonored.com/demo/data?json=[{"languageid":"' +
        selectedLanguage +
        '"},{"dataid":"1"},{"appid":"3"},{"version":"3"}]';
    http.get(url).then((result) async {
      progressDialog(false);
      getCartQuantity();
      Map response = jsonDecode(result.body);
      itemsList = (response['data']['product'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      tempList = (response['data']['product'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      menuList = (response['data']['group'] as List)
          .map((e) => MenuModel.fromJson(e))
          .toList();
      presentationData =
          PresentationModel.fromJson(response['data']['presentation']);
//      if (selectedLanguage == 'en') {
//        menuList.insert(0, MenuModel('All'));
//      } else if (selectedLanguage == 'es') {
//        menuList.insert(0, MenuModel('Todas'));
//      } else if (selectedLanguage == 'sv') {
//        menuList.insert(0, MenuModel('Todas'));
//      }
    });
  }

  Future<void> addToCart(int index) async {
//    preferences.setStringList('cartList', null);
    CartModel cartObject = CartModel();
    if (selectedMenu == 0) {

      cartObject.id = itemsList[index].id;
      cartObject.product_name = itemsList[index].name;
      cartObject.price = itemsList[index].price;
      cartObject.description = itemsList[index].description;
      cartObject.perpieceprice = itemsList[index].price;
      cartObject.quantity = '1';
      cartObject.default_image = itemsList[index].imageurl;
      cartObject.optionid = itemsList[index].optionid;
      cartObject.perpieceprice = itemsList[index].price;
    } else {
      cartObject.id = tempList[index].id;
      cartObject.product_name = tempList[index].name;
      cartObject.price = tempList[index].price;
      cartObject.perpieceprice = tempList[index].price;
      cartObject.description = tempList[index].description;
      cartObject.quantity = '1';
      cartObject.default_image = tempList[index].imageurl;
      cartObject.optionid = tempList[index].optionid;
    }

    List<CartModel> cartList = [];
    bool itemExist = false;
    List<String> ListInString = preferences.getStringList('cartList') ?? [];
    if (ListInString.length > 0) {
      try {
        for (var item in ListInString) {
          Map<String, dynamic> jsonObject = JsonDecoder().convert(item);
          cartList.add(CartModel.fromJson(jsonObject));
        }
      } catch (e) {
        print(e);
      }
    }
    if (cartList != null) {
      for (int i = 0; i < cartList.length; i++) {
        if (cartList[i].id == cartObject.id) {
          int temp = int.parse(cartObject.quantity);
          int temp2 = int.parse(cartList[i].quantity);
          temp2 += temp;
          cartList[i].quantity = temp2.toString();
          itemExist = true;
        }
      }
    }
    if (itemExist == false) {
      cartList.add(cartObject);
    }
    cartQuantity = 0;
    updateState();
    for (int i = 0; i < cartList.length; i++) {
      cartQuantity += int.parse(cartList[i].quantity);
    }

    ListInString = [];
    for (var item in cartList) {
//      print(JsonEncoder().convert(item));
      ListInString.add(JsonEncoder().convert(item));
    }
    await preferences.setStringList('cartList', ListInString).then((value) {
      Fluttertoast.showToast(
          msg: 'Successfully Added',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      updateState();
    });
  }

  Future<void> getCartQuantity() async {
    List<CartModel> cartList2 = [];
    List<String> cartListInString;
    cartListInString = preferences.getStringList('cartList') ?? [];
    if (cartListInString.length > 0) {
      for (var item in cartListInString) {
        Map<String, dynamic> jsonObject = JsonDecoder().convert(item);
        cartList2.add(CartModel.fromJson(jsonObject));
      }
      for (int i = 0; i < cartList2.length; i++) {
        cartQuantity += int.parse(cartList2[i].quantity);
      }
    } else {
      cartQuantity = 0;
    }

    updateState();
  }

  void languageDialog() {
    showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return new SimpleDialog(
            titlePadding: EdgeInsets.all(0.0),
            title: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Color(0xFF075E55)),
                    child: Center(
                        child: Text(
                      'Select Language',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'bold',
                          fontSize: 18),
                    ))),
              ],
            ),
            children: languageList.map((value) {
              return new SimpleDialogOption(
                onPressed: () {
                  print(languageList.indexOf(value));
                  print(value);
                  if (languageList.indexOf(value) == 0) {
                    selectedLanguage = 'en';
                  } else if (languageList.indexOf(value) == 1) {
                    selectedLanguage = 'es';
                  } else if (languageList.indexOf(value) == 2) {
                    selectedLanguage = 'sv';
                  }
                  preferences.setStringList('cartList', null);
                  menuList.clear();
                  itemsList.clear();
                  progressDialog(true);
                  selectedMenu = 0;
                  updateState();
                  getMenuData();
                  updateState();
                  Navigator.pop(context);
                },
                child: new Text(
                  value,
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'medium',
                      color: Color(0xFF666666)),
                ), //item value
              );
            }).toList(),
          );
        });
  }

  void deliveryTypeDialog() {
    showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return new SimpleDialog(
            titlePadding: EdgeInsets.all(0.0),
            title: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Color(0xFF075E55)),
                    child: Center(
                        child: Text(
                      'Select Delivery Type',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'bold',
                          fontSize: 18),
                    ))),
              ],
            ),
            children: deliveryTypeList.map((value) {
              return new SimpleDialogOption(
                onPressed: () {
                  print(deliveryTypeList.indexOf(value));
                  deliveryindex = deliveryTypeList.indexOf(value);
                  deliveryType = value;
                  updateState();
                  Navigator.of(context).pop();
                },
                child: new Text(
                  value,
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'medium',
                      color: Color(0xFF666666)),
                ), //item value
              );
            }).toList(),
          );
        });
  }

  void filters() {
    if (selectedMenu == 0) {
      tempList.clear();
      for (int i = 0; i < itemsList.length; i++) {
        ProductModel model = ProductModel();
        model.groupid = itemsList[i].groupid;
        model.groupname = itemsList[i].groupname;
        model.id = itemsList[i].id;
        model.name = itemsList[i].name;
        model.description = itemsList[i].description;
        model.preparationminute = itemsList[i].preparationminute;
        model.price = itemsList[i].price;
        model.priceForTakeaway = itemsList[i].priceForTakeaway;
        model.imageurl = itemsList[i].imageurl;
        model.showForEatin = itemsList[i].showForEatin;
        model.showForcatering = itemsList[i].showForcatering;
        model.optionid = itemsList[i].optionid;
        tempList.add(model);
      }
      updateState();
      progressDialog(false);
    } else {
      tempList.clear();
      for (int i = 0; i < itemsList.length; i++) {
        if (itemsList[i].groupid == menuList[selectedMenu].id) {
          ProductModel model = ProductModel();
          model.groupid = itemsList[i].groupid;
          model.groupname = itemsList[i].groupname;
          model.id = itemsList[i].id;
          model.name = itemsList[i].name;
          model.description = itemsList[i].description;
          model.preparationminute = itemsList[i].preparationminute;
          model.price = itemsList[i].price;
          model.priceForTakeaway = itemsList[i].priceForTakeaway;
          model.imageurl = itemsList[i].imageurl;
          model.showForEatin = itemsList[i].showForEatin;
          model.showForcatering = itemsList[i].showForcatering;
          model.optionid = itemsList[i].optionid;
          tempList.add(model);
        }
      }
      updateState();
      progressDialog(false);
    }
  }

  Widget deliveryContainer() {
    return InkWell(
      onTap: () {
        deliveryTypeDialog();
      },
      child: Container(
        padding: EdgeInsets.all(5),
        height: 40,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1.4)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  deliveryType,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Transform.rotate(
              angle: 4.7,
              child: Container(
                child: Icon(Icons.arrow_back_ios),
              ),
            )
          ],
        ),
      ),
    );
  }

  int changes = 1;
  int add = 0;
  int remove = 0;
  Widget alert() {
     showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child:
            Container(
                height: 400.0,
                width: 360.0,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[

                    Container(
                      alignment: Alignment.bottomLeft,
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.deepPurple,
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap:(){
                              changes = 1;
                              add = 0;
                              remove = 0;
                              updateState();
                            },
                            child: Container(
                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: Colors.black45, width: 2),
                                  right: BorderSide(color: Colors.black45, width: 2),
                                  top: BorderSide(color: Colors.black45, width: 2),
                                  bottom: BorderSide(color: changes == 1? Colors.transparent : Colors.black45, width: 2)
                                ),
                                color: Colors.white,
                              ),
                              height: 50,
                              width: 100,
                              child: Text('Change'),
                            ),
                          ),
                          InkWell(
                            onTap:(){
                              changes = 0;
                              add = 1;
                              remove = 0;
                              updateState();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: add == 0? Colors.transparent : Colors.black45, width: 2),
                                    right: BorderSide(color: add == 0? Colors.transparent : Colors.black45, width: 2),
                                    top: BorderSide(color: add == 0? Colors.transparent : Colors.black45, width: 2),
                                    bottom: BorderSide(color: add == 0? Colors.transparent : Colors.black45, width: 2)
                                ),
                                color: Colors.white,
                              ),
                              height: 50,
                              width: 100,
                              child: Text('Add'),
                            ),
                          ),
                          InkWell(
                            onTap:(){
                              changes = 0;
                              add = 0;
                              remove = 1;
                              updateState();
                            },
                            child: Container(
                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: remove == 0? Colors.transparent : Colors.black45, width: 2),
                                    right: BorderSide(color: remove == 0? Colors.transparent : Colors.black45, width: 2),
                                    top: BorderSide(color: remove == 0? Colors.transparent : Colors.black45, width: 2),
                                    bottom: BorderSide(color: remove == 0? Colors.transparent : Colors.black45, width: 2)
                                ),
                                color: Colors.white,
                              ),
                              height: 50,
                              width: 100,
                              child: Text('Remove'),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }

}
