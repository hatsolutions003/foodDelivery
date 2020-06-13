class CartModel{

  String id;
  String default_image;
  String product_name;
  String manufacturer_id;
  String address;
  String price;
  String quantity;
  String productStockQuantity;
  String selectedOption;
  String addedOption;
  String deletedOption;
  String optionid;
  String perpieceprice;
  String burgerChanges;
  String burgerCheeseAdd;
  String burgerExtraHam;
  String burgerRemove;
  String totalPrice;
  String price2;
  String description;


  String soup;
  String mainCourse;
  String drink;
  String drinkTemperature;


  CartModel();
  CartModel.fromJson(Map json):
        id = json['id'] != null ? json['id'] : '',
        default_image = json['default_image'] != null ? json['default_image'] : '',
        product_name = json['product_name'] != null ? json['product_name'] : '',
        manufacturer_id = json['manufacturer_id'] != null ? json['manufacturer_id'] : '',
        address = json['address'] != null ? json['address'] : '',
        quantity = json['quantity'] != null ? json['quantity'] : '',

        productStockQuantity = json['productQuantity'] != null ? json['productQuantity'] : '',
        price = json['price'] != null ? json['price'] : '',
        perpieceprice = json['perpieceprice'] != null ? json['perpieceprice'] : '',
        optionid = json['optionid'] != null ? json['optionid'] : '',
        burgerChanges = json['burgerChanges'] != null ? json['burgerChanges'] : '45',
        burgerCheeseAdd = json['burgerCheeseAdd'] != null ? json['burgerCheeseAdd'] : '',
        burgerExtraHam = json['burgerExtraHam'] != null ? json['burgerExtraHam'] : '',
        burgerRemove = json['burgerRemove'] != null ? json['burgerRemove'] : '46',
        totalPrice = json['totalPrice'] != null ? json['totalPrice'] : '',
        price2 = json['price2'] != null ? json['price2'] : '',
        soup = json['soup'] != null ? json['soup'] : '17',
        mainCourse = json['mainCourse'] != null ? json['mainCourse'] : '27',
        drink = json['drink'] != null ? json['drink'] : '29',
        drinkTemperature = json['drinkTemperature'] != null ? json['drinkTemperature'] : '',
        description = json['description'] != null ? json['description'] : '';

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'manufacturer_id' : manufacturer_id,
        'product_name' : product_name,
        'default_image' : default_image,
        'address' : address,
        'quantity' : quantity,
        'productQuantity' : productStockQuantity,
        'price' : price,
        'selectedOption' : selectedOption,
        'addedOption' : addedOption,
        'deletedOption' : deletedOption,
        'optionid' : optionid,
        'perpieceprice' : perpieceprice,
        'burgerChanges' : burgerChanges,
        'burgerCheeseAdd' : burgerCheeseAdd,
        'burgerExtraHam' : burgerExtraHam,
        'burgerRemove' : burgerRemove,
        'totalPrice' : totalPrice,
        'price2' : price2,
        'soup' : soup,
        'mainCourse' : mainCourse,
        'drink' : drink,
        'drinkTemperature' : drinkTemperature,
        'description' : description,
      };


}