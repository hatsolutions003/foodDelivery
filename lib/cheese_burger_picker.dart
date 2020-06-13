import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/cart.dart';
import 'models/product.dart';

class Cheese_burger_picker extends StatefulWidget {
  ProductModel itemsList;
  Cheese_burger_picker(this.itemsList);
  @override
  _Cheese_burger_pickerState createState() => _Cheese_burger_pickerState();
}

class _Cheese_burger_pickerState extends State<Cheese_burger_picker> {
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

  ProductModel itemsList;
  BuildContext context;
  SharedPreferences preferences;
  Function updateState;
  List<CartModel> cartList = [];

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

  
  int changes = 1;
  int add = 0;
  int remove = 0;
  String burgerChanges = '45';
  String burgerAddHamburger = '';
  String burgerAddCheese = '';
  String burgerRemove = '46';
  bool itemExist = false;
  int quantity = 0;


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
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomLeft,
              width: MediaQuery.of(context).size.width,
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
                          left: BorderSide(color: changes == 0? Colors.transparent : Colors.black45, width: 2),
                          right: BorderSide(color: changes == 0? Colors.transparent : Colors.black45, width: 2),
                          top: BorderSide(color: changes == 0? Colors.transparent : Colors.black45, width: 2),

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
                        ),
                        color: Colors.white,
                      ),
                      height: 50,
                      width: 100,
                      child: Text('Add',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16
                        ),),
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
                        ),
                        color: Colors.white,
                      ),
                      height: 50,
                      width: 100,
                      child: Text('Remove',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16
                        ),),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              height: 50,
              child: Text( changes == 1?  'Desired grill depth' : add == 1? 'Add to burger' : remove == 1? 'Remove from burger' : '',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16
                ),),
            ),
            changes == 1? Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              height: 200,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text('Rare',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20
                          ),),
                      ),
                      InkWell(
                        onTap: (){
                          burgerChanges = '43';
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
                          child: burgerChanges == '43'? Icon(Icons.done) : null,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text('Well done',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20
                          ),),
                      ),
                      InkWell(
                        onTap: (){
                          burgerChanges = '44';
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
                          child: burgerChanges == '44'? Icon(Icons.done) : null,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text('Medium',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20
                          ),),
                      ),
                      InkWell(
                        onTap: (){
                          burgerChanges = '45';
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
                          child: burgerChanges == '45'? Icon(Icons.done) : null,
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ) : Container(),
            add == 1? Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              height: 200,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text('Extra cheese slice',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20
                          ),),
                      ),
                      InkWell(
                        onTap: (){
                          if(burgerAddCheese == '48')
                          {
                            burgerAddCheese = '';
                          }
                          else{
                            burgerAddCheese = '48';

                          }
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
                          child: burgerAddCheese == '48'? Icon(Icons.done) : null,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text('Extra hamburger 110g.',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20
                          ),),
                      ),
                      InkWell(
                        onTap: (){
                          if(burgerAddHamburger == '49')
                          {
                            burgerAddHamburger = '';
                          }
                          else{
                            burgerAddHamburger = '49';

                          }
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
                          child: burgerAddHamburger == '49'? Icon(Icons.done) : null,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ) : Container(),
            remove == 1? Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              height: 200,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text('Onion',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20
                          ),),
                      ),
                      InkWell(
                        onTap: (){
                          if(burgerRemove == '46')
                          {
                            burgerRemove = '';
                          }
                          else
                          {
                            burgerRemove = '46';
                          }
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
                          child: burgerRemove == '46'? Icon(Icons.done) : null,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ) : Container(),
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
                          color: Colors.black,
                          shape: BoxShape.circle
                        ),
                          child: Icon(Icons.add, color: Colors.white, size: 17,)),
                    ),
                  )
                ],
              )
            ),
            SizedBox(height: 10,),
//            InkWell(
//              onTap: (){
//                if(quantity > 0)
//                  {
//                    saveOrder();
//                  }
//                else
//                  {
//                    showToast('Please add Quantity');
//                  }
//
//              },
//              child: Container(
//                alignment: Alignment.center,
//                margin: EdgeInsets.symmetric(horizontal: 125),
//                height: 40,
//              width: 70,
//              color: Color(0xFF075E55),
//              child: Text('Save',
//              style: TextStyle(
//                fontSize: 18,
//                color: Colors.white
//              ),),),
//            )
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
              burgerChanges = cartList[i].burgerChanges;
              if(cartList[i].burgerCheeseAdd != ''){
                burgerAddCheese = cartList[i].burgerCheeseAdd;
              }
              if(cartList[i].burgerExtraHam != '')
                {
                  burgerAddHamburger = cartList[i].burgerExtraHam;
                }
              if(cartList[i].burgerRemove != '')
                {
                  burgerRemove = cartList[i].burgerRemove;
                }
                  burgerRemove = cartList[i].burgerRemove;

              quantity = int.parse(cartList[i].quantity);
              itemExist = true;
              updateState();
              break;
              print('hi i m there');
            }
          else{
            itemExist = false;
            print('i m not there');
          }


//          cartList[i].price = (double.parse(cartList[i].quantity) * double.parse(cartList[i].price)).toString();
        }

//        updateTotalBill();
      } catch (e) {
        print('hell');
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
            cartList[i].burgerChanges = burgerChanges;
            if(burgerChanges != '')
              {
                cartList[i].burgerChanges = burgerChanges;
              }
            else
              {
                cartList[i].burgerChanges = '';
              }
            if(burgerAddCheese != '')
            {
              cartList[i].burgerCheeseAdd = burgerAddCheese;
              tp += 5.0 * quantity;
            }
            else{
              cartList[i].burgerCheeseAdd = '';
            }
            if(burgerAddHamburger != '')
            {
              cartList[i].burgerExtraHam = burgerAddHamburger;
              tp += 12.0 * quantity;
            }
            else
              {
                cartList[i].burgerExtraHam = '';
              }
            cartList[i].burgerRemove = burgerRemove;
            cartList[i].totalPrice = tp.toString();
            updateState();
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
        cartObject.burgerChanges = burgerChanges;
        cartObject.description = itemsList.description;
        double tp = 0;
        tp += quantity * double.parse(itemsList.price);
        if(burgerChanges != '')
        {
          cartObject.burgerChanges = burgerChanges;
        }
        else
        {
          cartObject.burgerChanges = '';
        }
        if(burgerAddCheese != '')
          {
            cartObject.burgerCheeseAdd = burgerAddCheese;
            tp += 5.0 * quantity;
          }
        if(burgerAddHamburger != '')
          {
            cartObject.burgerExtraHam = burgerAddHamburger;
            tp += 12.0 * quantity;
          }
        if(burgerRemove != '')
          {
            cartObject.burgerRemove = burgerRemove;
          }
        else
          {
            cartObject.burgerRemove = '';
          }
        cartObject.totalPrice = tp.toString();

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
