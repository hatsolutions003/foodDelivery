import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/cart.dart';
import 'models/product.dart';

class MajorMenuBox extends StatefulWidget {
  ProductModel itemsList;
  MajorMenuBox(this.itemsList);
  @override
  _MajorMenuBoxState createState() => _MajorMenuBoxState();
}

class _MajorMenuBoxState extends State<MajorMenuBox> {
  Support support;
  @override
  Widget build(BuildContext context) {
    if (support == null) {
      support = Support(this.context, updateState, widget.itemsList);
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              support.statusBar(),
              support.actionBar(),
              support.imageContainer(),

              support.tabContainer(),
              support.safeArea(),

            ],
          )
        ],
      ),
    );

  }

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void updateState() {
    if (mounted) {
      setState(() {});
    }
  }
}

class Support {
  BuildContext context;
  ProductModel itemsList;
  String soup = '17';
  String mainCourse = '27';
  String drink = '29';
  int quantity = 0;
  SharedPreferences preferences;
  List<CartModel> cartList = [];
  bool itemExist = false;

  Function updateState;
  Map result = Map();
  Support(this.context, this.updateState, this.itemsList){
    SharedPreferences.getInstance().then((preferencesInstance){
      preferences = preferencesInstance;
      getCartList();
    });
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
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white,),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Text(itemsList.name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                    ),),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 55,
              child: null,
            ),
          )
        ],
      ),
    );
  }

  Widget imageContainer(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: 300,
            child: CachedNetworkImage(
              imageUrl: itemsList.imageurl,
              fit: BoxFit.fill,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(
                      value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: MediaQuery.of(context).size.width,
            child: Text(
              itemsList.name,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            child: Text(
              itemsList.description,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget tabContainer(){
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.bottomLeft,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap:(){

                    },
                    child: Container(
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.black45, width: 2),
                          right: BorderSide(color: Colors.black45, width: 2),
                          top: BorderSide(color: Colors.black45, width: 2),

                        ),
                        color: Colors.white,
                      ),
                      height: 50,
                      width: 100,
                      child: Text('Change',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16
                        ),),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              height: 50,
              child: Text( 'Select a soup',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16
                ),),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text('Chicken soup',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                      ),),
                  ),
                  InkWell(
                    onTap: (){
                      soup = '8';
                      updateState();
                      if(quantity > 0)
                        {
                          saveOrder();
                        }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2)
                      ),
                      child: soup == '8'? Icon(Icons.done) : null,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text('Bean soup',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                      ),),
                  ),
                  InkWell(
                    onTap: (){
                      soup = '17';
                      updateState();
                      if(quantity > 0)
                      {
                        saveOrder();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2)
                      ),
                      child:  soup == '17'? Icon(Icons.done) : null,
                    ),
                  )
                ],
              ),
            ),
////////////////////////////////////////////////////////
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              height: 50,
              child: Text( 'Select a main course',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16
                ),),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text('Chicharron',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                      ),),
                  ),
                  InkWell(
                    onTap: (){
                      mainCourse = '28';
                      updateState();
                      if(quantity > 0)
                      {
                        saveOrder();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2)
                      ),
                      child: mainCourse == '28'? Icon(Icons.done) : null,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text('Falafel',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                      ),),
                  ),
                  InkWell(
                    onTap: (){
                      mainCourse = '26';
                      updateState();
                      if(quantity > 0)
                      {
                        saveOrder();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2)
                      ),
                      child:  mainCourse == '26'? Icon(Icons.done) : null,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text('Grilled chicken breast',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                      ),),
                  ),
                  InkWell(
                    onTap: (){
                      mainCourse = '27';
                      updateState();
                      if(quantity > 0)
                      {
                        saveOrder();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2)
                      ),
                      child:  mainCourse == '27'? Icon(Icons.done) : null,
                    ),
                  )
                ],
              ),
            ),
////////////////////////////////////////////////////////
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              height: 50,
              child: Text( 'Select a drink',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16
                ),),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text('Maracuya juice',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                      ),),
                  ),
                  InkWell(
                    onTap: (){
                      drink = '30';
                      updateState();
                      if(quantity > 0)
                      {
                        saveOrder();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2)
                      ),
                      child: drink == '30'? Icon(Icons.done) : null,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text('Aguapanela',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                      ),),
                  ),
                  InkWell(
                    onTap: (){
                      drink = '29';
                      updateState();
                      if(quantity > 0)
                      {
                        saveOrder();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2)
                      ),
                      child:  drink == '29'? Icon(Icons.done) : null,
                    ),
                  )
                ],
              ),
            ),


            Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap:(){
                        if(quantity > 1)
                        {
                          quantity--;
                          updateState();
                          saveOrder();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        height: 35,
                        width: 35,
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black
                            ),
                            child: Icon(Icons.remove, color: Colors.white, size: 17,)),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    InkWell(
                      onTap: (){
                        quantity++;
                        updateState();
                        saveOrder();
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        height: 35,
                        width: 35,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black
                          ),
                            child: Icon(Icons.add, color: Colors.white, size: 17,)),
                      ),
                    )
                  ],
                )
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }


  Future<void> getCartList() async {
    List<String> cartListInString;
    cartListInString = preferences.getStringList('cartList') ?? [];
    if (cartListInString.length > 0) {
      try {
        for (var item in cartListInString) {
          Map<String, dynamic> jsonObject = JsonDecoder().convert(item);
          cartList.add(CartModel.fromJson(jsonObject));
        }
        for(int i = 0; i < cartList.length; i++)
        {
          if(itemsList.id == cartList[i].id)
          {
            soup = cartList[i].soup;
            mainCourse = cartList[i].mainCourse;
            drink = cartList[i].drink;
            quantity = int.parse(cartList[i].quantity);
            itemExist = true;
            updateState();
          }
          else{
            itemExist = false;
          }
        }

      } catch (e) {
        print(e);
      }


    }

    updateState();


  }

  Future<void> saveOrder() async {
    if(itemExist)
    {
      for (int i = 0; i < cartList.length; i++) {
        if (itemsList.id == cartList[i].id) {
          double tp = 0;
          tp += quantity * double.parse(cartList[i].price);
          cartList[i].quantity = quantity.toString();
          cartList[i].soup = soup;
          cartList[i].mainCourse = mainCourse;
          cartList[i].drink = drink;
          updateState();
          print('hi i m there');
        }
      }
    }
    else{
      CartModel cartObject = CartModel();
      cartObject.id = itemsList.id;
      cartObject.product_name = itemsList.name;
      cartObject.price = itemsList.price;
      cartObject.perpieceprice = itemsList.price;
      cartObject.quantity = quantity.toString();
      cartObject.default_image = itemsList.imageurl;
      cartObject.optionid = itemsList.optionid;
      cartObject.soup = soup;
      cartObject.mainCourse = mainCourse;
      cartObject.drink = drink;

      cartList.add(cartObject);
      updateState();

    }
    preferences.setStringList('cartList', null);
    List<String> cartListInString = [];
    for(var item in cartList){
      cartListInString.add(JsonEncoder().convert(item));
    }
    await preferences.setStringList('cartList', cartListInString).then((value){
//      showToast('Order Saved Successfully');
//      Navigator.of(context).pop();
    });

    updateState();
  }

  void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }



}
