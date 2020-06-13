import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddelivery/cheese_burger_picker.dart';
import 'package:fooddelivery/major_menu_picker.dart';
import 'package:fooddelivery/models/cart.dart';
import 'package:fooddelivery/sparkling_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';

import 'models/product.dart';

class CartPage extends StatefulWidget {
  int deliveryId;
  CartPage(this.deliveryId);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Support support;
  ProgressHUD progressHUD;
  @override
  Widget build(BuildContext context) {
    if(support == null)
    {
      support = Support(this.context, updateState, progressDialog, widget.deliveryId);
      progressHUD = new ProgressHUD(
        backgroundColor: Colors.black12,
        color: Color(0xFF075E55),
        containerColor: Colors.transparent,
        borderRadius: 5.0,
        text: 'Loading...',
        loading: false,
      );
    }
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              support.statusBar(),
              support.actionBar(),
              support.body(),
              support.cartList != null? support.orderListView() : Container(
                child: Text('No Items Found'),
              ),
              support.checkOutData(),
              support.safeArea(),
            ],
          ),
          progressHUD
        ],
      ),
    );
  }

  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void updateState(){
    if(mounted)
    {
      setState(() {

      });
    }
  }
  void progressDialog(bool value){
    setState(() {
      if(value){
        progressHUD.state.show();
      }
      else{
        progressHUD.state.dismiss();
      }
    });
  }
}

class Support{
  BuildContext context;
  Function updateState, progressDialog;
  String date;
  int quantity = 1;
  double totalAmount = 0;
  List<CartModel> cartList = [];
  int temp = 0;
  String name = '';
  String phone = '';
  String burgerChanges = '45';
  String burgerAddHamburger = '';
  String burgerAddCheese = '';
  String burgerRemove = '';
  String drinkTemperature = '';
  String soup = '17';
  String mainCourse = '27';
  String drink = '29';
  int deliveryId;
  String isoTime = '';
  ProductModel itemsList;

  String uid = '';

  List<String> deliveryTime = ['5','10', '15', '25', '35', '45', '55', '1:00', '1:10', '1:20', '1:30', '1:40', '1:50', '2:00'];

  int timeIndex = 0;
  String timeString = '';

  SharedPreferences preferences;
  var currentTime;

  Support(this.context, this.updateState, this.progressDialog, this.deliveryId){
    SharedPreferences.getInstance().then((preferencesInstance){
      preferences = preferencesInstance;
      getCartList();
      var uuid = Uuid();
      uid = uuid.v1();
      String tempname = preferences.getString('name');
      String tempphone = preferences.getString('phone');

      if(tempname.length > 0 && tempphone.length > 0)
        {
          name = tempname;
          phone = tempphone;
          updateState();
        }
    });
    timeString = deliveryTime[0];
    var temp = DateTime.now();
    temp = temp.add(Duration(minutes: 5));
    DateTime todayDate = DateTime.parse(temp.toString());
    isoTime = DateFormat('Hm').format(todayDate);
    currentTime = formatDate(todayDate, [hh, ':', nn, ':', ss, ' ', am]);
    updateState();
    getCurrentDate();
  }

  Widget statusBar(){
    return Container(
      height: MediaQuery.of(context).padding.top,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFCFDBD9),
    );
  }

  Widget safeArea(){
    return Container(
      height: MediaQuery.of(context).padding.bottom,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFCFDBD9),
    );
  }

  Widget actionBar(){
    return Container(
      padding: EdgeInsets.all(10),
      height: 55,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Container(
              width: MediaQuery.of(context).size.width/1.2,
              child: Row(
                children: <Widget>[
                  Icon(Icons.arrow_back_ios),
                  SizedBox(width: 10,),
                  Text('Back', style: TextStyle(fontSize: 18, color: Colors.black),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget body(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          nameDate(),
//          SizedBox(height: 40,),
//          addOrder(),
        ],
      ),
    );
  }

  Widget nameDate(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text('Cart',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24
              ),),
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(date != null? date : '',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20
              ),),
          ),
        ],
      ),
    );
  }

  Widget addOrder(){
    return InkWell(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(Icons.add, size: 14),
            Text('Add to order',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),),
          ],
        ),
      ),
    );
  }

  Widget orderListView(){
    return Expanded(
      child: Container(
        child: ListView.builder(
            itemBuilder: orderList,
          itemCount: cartList.length,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }

  Widget orderList(BuildContext context, int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(10),
      height: int.parse(cartList[index].id) == 6 ? 310 :
      int.parse(cartList[index].id) == 13 ? 200 : int.parse(cartList[index].id) == 16 ? 280 : 120,
      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ]
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: cartList[index].default_image,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(width: 50),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width/2.8,
                                child: Text(
                                    cartList[index].product_name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                            Container(
                                child: Text(
                                    '\$' + (cartList[index].id == '6'? cartList[index].totalPrice : cartList[index].price),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700
                                  ),
                                )
                            ),
                          ]
                      ),
                      SizedBox(height: 30,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap:(){
                                    temp = int.parse(cartList[index].quantity);
                                    if(temp > 1)
                                      {
                                        temp--;
                                        cartList[index].quantity = temp.toString();
                                        updateState();
                                        if(cartList[index].id == '6')
                                          {
                                            print('hello');
                                            double tp = double.parse(cartList[index].totalPrice);
                                            tp -= double.parse(cartList[index].perpieceprice);
                                            cartList[index].totalPrice = tp.toString();
                                            if(cartList[index].burgerCheeseAdd != '')
                                            {
                                              double tp = double.parse(cartList[index].totalPrice);
                                              tp -= 5;
                                              cartList[index].totalPrice = tp.toString();
                                            }
                                            if(cartList[index].burgerExtraHam != '')
                                            {
                                              double tp = double.parse(cartList[index].totalPrice);
                                              tp -= 12;
                                              cartList[index].totalPrice = tp.toString();
                                            }
                                          }
                                        else{
                                          double tp = double.parse(cartList[index].price);
                                          tp -= double.parse(cartList[index].perpieceprice);
                                          cartList[index].price = tp.toString();
                                        }


                                        updateState();
                                        updateCartList();
                                        updateTotalBill();
                                      }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle
                                    ),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle
                                        ),
                                        child: Icon(Icons.remove, color: Colors.white,size: 17,)),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Container(
                                    child: Text(
                                      cartList[index].quantity,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700
                                      ),
                                    )
                                ),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: (){
                                    temp = int.parse(cartList[index].quantity);
                                    temp++;
                                    cartList[index].quantity = temp.toString();



                                    if(cartList[index].id == '6')
                                    {
                                      double tp = double.parse(cartList[index].totalPrice);
                                      tp += double.parse(cartList[index].perpieceprice);
                                      print(tp);
                                      cartList[index].totalPrice = tp.toString();
                                      updateState();
                                    }
                                    else{
                                      double tp = double.parse(cartList[index].price);
                                      tp += double.parse(cartList[index].perpieceprice);
                                      cartList[index].price = tp.toString();
                                    }
                                    if(cartList[index].burgerCheeseAdd != '')
                                    {
                                      double tp = double.parse(cartList[index].totalPrice);
                                      tp += 5;
                                      cartList[index].totalPrice = tp.toString();
                                    }
                                    if(cartList[index].burgerExtraHam != '')
                                    {
                                      double tp = double.parse(cartList[index].totalPrice);
                                      tp += 12;
                                      cartList[index].totalPrice = tp.toString();
                                    }

                                    updateState();
                                    updateTotalBill();
                                    updateCartList();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle
                                      ),
                                        child: Icon(Icons.add, color: Colors.white,size: 17,)),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: (){
                                cartList.removeAt(index);
                                updateCartList();
                                updateState();
                              },
                              child: Icon(Icons.delete_sweep, color: Colors.red,
                              size: 25,),
                            )
                          ]
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          cartList[index].id == '6'? Container(
            height: 190,
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          itemsList = ProductModel();
                          itemsList.id = cartList[index].id;
                          itemsList.name = cartList[index].product_name;
                          print(cartList[index].description);
                          itemsList.description = cartList[index].description;
                          itemsList.price = cartList[index].price;
                          itemsList.imageurl = cartList[index].default_image;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Cheese_burger_picker(itemsList))).then((value){
                            cartList.clear();
                            updateState();
                            getCartList();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 70,
                          color: Color(0xFF69E695),
                          child: Icon(Icons.compare_arrows),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          Text(cartList[index].burgerChanges == '45'? 'Medium' : cartList[index].burgerChanges == '44'? 'Well done' : cartList[index].burgerChanges == '43'? 'Rare' : '',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ],
                      ),
                      SizedBox(height: 7,),
                      cartList[index].burgerRemove == ''? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text('- Onion',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),]
                      ) : Container(),
                      SizedBox(height: 7,),
                      cartList[index].burgerCheeseAdd != ''? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('+ Extra Cheese Slice',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                          SizedBox(width: 40,),
                          Text('5.0',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ],
                      ) : Container(),
                      SizedBox(height: 7,),
                      cartList[index].burgerExtraHam != ''? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('+ Extra hamburger 110g.',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                          Text('12.0',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ],
                      ) : Container(),
                      SizedBox(height: 7,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(cartList[index].quantity + ' x ' + cartList[index].perpieceprice,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                          Text(cartList[index].totalPrice,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ): cartList[index].id == '13'?
          Container(height: 80,
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          itemsList = ProductModel();
                          itemsList.id = cartList[index].id;
                          itemsList.name = cartList[index].product_name;
                          print(cartList[index].description);
                          itemsList.description = cartList[index].description;
                          itemsList.price = cartList[index].price;
                          itemsList.imageurl = cartList[index].default_image;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SparklingBox(itemsList))).then((value){
                            cartList.clear();
                            updateState();
                            getCartList();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 70,
                          color: Color(0xFF69E695),
                          child: Icon(Icons.compare_arrows),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(cartList[index].drinkTemperature == '39'? 'Cold':
                          cartList[index].drinkTemperature == '40'? 'Room temperature' :
                          cartList[index].drinkTemperature == '42'? 'With ice' : '',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                          SizedBox(width: 40,),
                        ],
                      )
                    ],
                  ),
                ),

              ],
            ),
          ) : cartList[index].id == '16'? Container(
            height: 150,
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          itemsList = ProductModel();
                          itemsList.id = cartList[index].id;
                          itemsList.name = cartList[index].product_name;
                          print(cartList[index].description);
                          itemsList.description = cartList[index].description;
                          itemsList.price = cartList[index].price;
                          itemsList.imageurl = cartList[index].default_image;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MajorMenuBox(itemsList))).then((value){
                            cartList.clear();
                            updateState();
                            getCartList();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 70,
                          color: Color(0xFF69E695),
                          child: Icon(Icons.compare_arrows),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          Text(cartList[index].soup == '17'? 'Bean soup' : 'Chicken soup',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ],
                      ),
                      SizedBox(height: 7,),
                      Row(
                        children: <Widget>[
                          Text(cartList[index].mainCourse == '27'? 'Grilled chicken breast' :
                          cartList[index].mainCourse == '28'? 'Chicharron' :
                          cartList[index].mainCourse == '26'? 'Falafel' : '',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ],
                      ),
                      SizedBox(height: 7,),
                      Row(
                        children: <Widget>[
                          Text(cartList[index].drink == '29'? 'Aguapanela' : 'Maracuyá juice',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ],
                      ),
                      SizedBox(height: 7,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(cartList[index].quantity + ' x ' + cartList[index].perpieceprice,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                          Text(cartList[index].price,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ],
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget checkOutData(){
    return Container(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Container(
              height: 1,
              color: Color(0xFFEDEDED),
            ),
            SizedBox(height: 10,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total: ', style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700
                  ),),
                  Text(totalAmount != 0? '\$' + totalAmount.toString() : '0' , style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700
                  ),)
                ],
              ),
            ),
            SizedBox(height: 10,),
            nameField(),
            SizedBox(height: 10,),
            phoneField(),
            deliveryId == 1? SizedBox(height: 15,): Container(),
            deliveryId == 1? deliveryTimeContainer() : Container(),
            SizedBox(height: 15,),
            checkOutButton(),
            SizedBox(height: 15,),
          ],
        )
      ),
    );
  }

  Widget nameField(){
    return Container(
        padding: EdgeInsets.all(5),
        color: Colors.white,
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: TextField(
            textInputAction: TextInputAction.next,
            onSubmitted: (value) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration.collapsed(
              hintText: 'My Name',
              hintStyle: TextStyle(
                fontSize: 14.0,
                fontFamily: 'regular',
                color: Color(0xFFA3A3A3),
              ),
            ),
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'regular',
              color: Color(0xFF666666),
            ),
            maxLines: 1,
            controller: buildTextController(name),
            onChanged: (value) {
              name = value;
            }
        )
    );
  }

  Widget phoneField(){
    return Container(
        padding: EdgeInsets.all(5),
        color: Colors.white,
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: TextField(
            textInputAction: TextInputAction.next,
            onSubmitted: (value) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration.collapsed(
              hintText: 'My Phone',
              hintStyle: TextStyle(
                fontSize: 14.0,
                fontFamily: 'regular',
                color: Color(0xFFA3A3A3),
              ),
            ),
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'regular',
              color: Color(0xFF666666),
            ),
            maxLines: 1,
            controller: buildTextController(phone),
            onChanged: (value) {
              phone = value;
            }
        )
    );
  }

  Widget checkOutButton(){
    return InkWell(
      onTap: (){
        if(cartList.length > 0)
          {
            validation();
          }
        else
          {
            showToast('Please add item in cart first');
          }
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Color(0xFF528078),
        ),
        child: Text('Checkout', style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),),
      ),
    );
  }

  getCurrentDate(){
    var dayName  = DateFormat('EEEE').format(DateTime.now());
    var day  = DateFormat('d').format(DateTime.now());
    var month  = DateFormat('MMMM').format(DateTime.now());

    date = dayName + ', ';
    if(day == '1')
      {
        date = dayName + ', ' + day + 'st of ' +  month;
      }
    if(day == '2')
      {
        date = dayName + ', ' + day + 'nd of ' +  month;
      }
    if(day == '3')
      {
        date = dayName + ', ' + day + 'rd of ' +  month;
      }
    else
      {
        date = dayName + ', ' + day + 'th of ' +  month;
      }
    updateState();

  }

  Future<void> getCartList() async {
    List<String> cartListInString;
    cartListInString = preferences.getStringList('cartList') ?? [];
    if (cartListInString.length > 0) {
      try
      {
        for (var item in cartListInString)
        {
          Map<String, dynamic> jsonObject = JsonDecoder().convert(item);
          cartList.add(CartModel.fromJson(jsonObject));
        }
      }
      catch (e)
      {
        print('hell');
        print(e);
      }
      for(int i = 0; i < cartList.length; i++)
      {
        if(cartList[i].id == '6')
        {
          double tp = 0.0;
          if(cartList[i].burgerCheeseAdd != '')
          {
            tp += 5.0 * double.parse(cartList[i].quantity);
            print(tp);
            cartList[i].totalPrice = tp.toString();
          }
          if(cartList[i].burgerExtraHam != '')
          {
            tp += 12.0 * double.parse(cartList[i].quantity);
            cartList[i].totalPrice = tp.toString();
          }
          tp += double.parse(cartList[i].perpieceprice) * double.parse(cartList[i].quantity);
          cartList[i].totalPrice = tp.toString();
          updateState();


        }
        else{
          double temp = (double.parse(cartList[i].quantity) * double.parse(cartList[i].perpieceprice));
          cartList[i].price = temp.toString();
        }

      }
      updateTotalBill();


    }

    updateState();


  }

  Future<void> updateCartList() async {
    preferences.setStringList('cartList', null);
    List<String> cartListInString = [];
    for(var item in cartList){
      cartListInString.add(JsonEncoder().convert(item));
    }

    await preferences.setStringList('cartList', cartListInString).then((value){
      updateTotalBill();
    });
    updateState();
  }

  void updateTotalBill(){
    totalAmount = 0;
    updateState();
    for(int i  = 0; i < cartList.length; i++)
    {
      if(cartList[i].id == '6')
        {
          double x = double.parse(cartList[i].totalPrice);
          totalAmount += x;
        }
      else{
        totalAmount += double.parse(cartList[i].price);
      }

    }
    updateState();
  }

  Widget deliveryTimeContainer(){
    return Container(
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: (){
              deliveryTimeDialog();
            },
            child: Container(
              padding: EdgeInsets.all(5),
              height: 40,
              width: MediaQuery.of(context).size.width/2.3,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.black,
                      width: 1.4
                  )
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        timeString,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600
                        ),
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
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Minutes to Delivery'
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(currentTime,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void validation(){
    FocusScope.of(context).requestFocus(FocusNode());

    if(name.trim().isEmpty){
      showToast('Enter Name');
    }
    if(phone.isEmpty){
      showToast('Enter Phone');
    }
    else if(phone.length < 6){
      showToast('Too Short Phone');
    }
    else if(phone.length > 32){
      showToast('length long Phone');
    }
    else if(name.isEmpty && phone.isEmpty){
      showToast('Enter Name & Phone');
    }
    else {
      checkoutOrder();
    }
  }

  void checkoutOrder(){
    saveData();
    progressDialog(true);

    String url = 'https://bonored.com/demo/capture';

    Map<String, String> body = Map();

    String time = DateFormat('jm').format(DateTime.now());
    String orderString = '[{"name": "'+ name+'"}, {"address": "house123"}, {"info": ""}, {"whatsapp": ""}, {"device": ""}, {"seat": ""}, {"phone": "'+phone+'"}, {"deliverytime": "'+isoTime+'"}, {"typeid": "'+ deliveryId.toString()+'"}, {"tp": "'+totalAmount.toString()+'"}, {"paymodel": ""},';

    body['appid'] = '3';
    body['dataid'] = '1';

    for(int i = 0; i < cartList.length; i++)
      {
        if(cartList[i].optionid == '')
          {
            orderString += '{"q": "'+cartList[i].quantity+'"}, {"d": "'+cartList[i].id+'"},';
          }
        if(cartList[i].id == '6')
          {
            orderString += '{"q": "'+cartList[i].quantity+'"},{"d": "'+cartList[i].id+'"},{"o": "'+ cartList[i].burgerChanges +'"},';
            if(cartList[i].burgerCheeseAdd != ''){

              orderString += '{"a": "'+ cartList[i].burgerCheeseAdd +'"}, ';
            }
            if(cartList[i].burgerExtraHam != ''){

              orderString += '{"a": "'+ cartList[i].burgerExtraHam+'"}, ';
            }
            if(cartList[i].burgerRemove == '')
              {
                orderString += '{"not": "'+ cartList[i].burgerRemove +'"}';
              }


          }
        if(cartList[i].id == '16')
          {
            orderString += '{"q": "'+cartList[i].quantity+'"},{"d": "'+cartList[i].id+'"},';
            orderString += '{"o": "'+ cartList[i].soup +'"},';
            orderString += '{"o": "'+ cartList[i].mainCourse +'"},';
            orderString += '{"o": "'+ cartList[i].drink +'"},';
          }
        if(cartList[i].id == '13')
        {
          orderString += '{"q": "'+cartList[i].quantity+'"},{"d": "'+cartList[i].id+'"},';
          if(cartList[i].drinkTemperature != '')
            {
              orderString += '{"o": "'+ cartList[i].drinkTemperature +'"},';
            }
        }
      }
    if(deliveryId == 1)
      {
        orderString +='{"deliverytime": "'+isoTime+'"}';
      }
    orderString += '{"currency": "kr"}, {"uid": "'+ uid +'"}, {"eof": ""}]';

    body['json'] = orderString;

//    progressDialog(false);
//    print(orderString);

    http.post(url, body: body).then((result){
      progressDialog(false);
      Map response = jsonDecode(result.body);
      if(response['success'] == 1)
        {
          showToast('Order Placed Successfully');
          setEmptyCartList();
        }
      else{
        showToast('Order Failed');
      }

      print(response);
    });



  }

  Future<void> setEmptyCartList() async {
    preferences.setStringList('cartList', null).then((onValue){
      Navigator.of(context).pop();
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

  void deliveryTimeDialog() {
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
                          'Select Delivery Type' ,
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'bold', fontSize: 18),
                        ))),
              ],
            ),
            children: deliveryTime.map((value) {
              return new SimpleDialogOption(
                onPressed: () {

                  timeIndex = deliveryTime.indexOf(value);
                  timeString = value;
                  if(deliveryTime.indexOf(value) >= 0 && deliveryTime.indexOf(value) <= 6)
                    {
                      var temp = DateTime.now();
                      temp = temp.add(Duration(minutes: int.parse(value)));
                      DateTime todayDate = DateTime.parse(temp.toString());
                      isoTime = DateFormat('Hm').format(todayDate);
                      print(isoTime);
                    currentTime = formatDate(todayDate, [hh, ':', nn, ':', ss, ' ', am]);
                  }
                  else if(deliveryTime.indexOf(value) == 7)
                    {
                      var temp = DateTime.now();
                      temp = temp.add(Duration(hours: 1));
                      DateTime todayDate = DateTime.parse(temp.toString());
                      isoTime = DateFormat('Hm').format(todayDate);
                      currentTime = formatDate(todayDate, [hh, ':', nn, ':', ss, ' ', am]);
                    }
                  else if(deliveryTime.indexOf(value) == 8)
                  {
                    var temp = DateTime.now();
                    temp = temp.add(Duration(hours: 1, minutes: 10));
                    DateTime todayDate = DateTime.parse(temp.toString());
                    isoTime = DateFormat('Hm').format(todayDate);
                    currentTime = formatDate(todayDate, [hh, ':', nn, ':', ss, ' ', am]);

                  }
                  else if(deliveryTime.indexOf(value) == 9)
                  {
                    var temp = DateTime.now();
                    temp = temp.add(Duration(hours: 1, minutes: 20));
                    DateTime todayDate = DateTime.parse(temp.toString());
                    isoTime = DateFormat('Hm').format(todayDate);
                    currentTime = formatDate(todayDate, [hh, ':', nn, ':', ss, ' ', am]);

                  }
                  else if(deliveryTime.indexOf(value) == 10)
                  {
                    var temp = DateTime.now();
                    temp = temp.add(Duration(hours: 1, minutes: 30));
                    DateTime todayDate = DateTime.parse(temp.toString());
                    isoTime = DateFormat('Hm').format(todayDate);
                    currentTime = formatDate(todayDate, [hh, ':', nn, ':', ss, ' ', am]);

                  }
                  else if(deliveryTime.indexOf(value) == 11)
                  {
                    var temp = DateTime.now();
                    temp = temp.add(Duration(hours: 1, minutes: 40));
                    DateTime todayDate = DateTime.parse(temp.toString());
                    isoTime = DateFormat('Hm').format(todayDate);
                    currentTime = formatDate(todayDate, [hh, ':', nn, ':', ss, ' ', am]);

                  }
                  else if(deliveryTime.indexOf(value) == 12)
                  {
                    var temp = DateTime.now();
                    temp = temp.add(Duration(hours: 1, minutes: 50));
                    DateTime todayDate = DateTime.parse(temp.toString());
                    isoTime = DateFormat('Hm').format(todayDate);
                    currentTime = formatDate(todayDate, [hh, ':', nn, ':', ss, ' ', am]);

                  }
                  else if(deliveryTime.indexOf(value) == 13)
                  {
                    var temp = DateTime.now();
                    temp = temp.add(Duration(hours: 2));
                    DateTime todayDate = DateTime.parse(temp.toString());
                    isoTime = DateFormat('Hm').format(todayDate);
                    currentTime = formatDate(todayDate, [hh, ':', nn, ':', ss, ' ', am]);
                  }
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

  TextEditingController buildTextController(String text){
    TextEditingController controller = TextEditingController();
    controller.text = text;
    controller.selection = TextSelection.fromPosition(TextPosition(offset: text.length));

    return controller;
  }

  void saveData(){
    preferences.setString('name', name);
    preferences.setString('phone', phone);
    updateState();
  }

}
