class ProductModel{
  String groupid;
  String groupname;
  String id;
  String name;
  String description;
  String preparationminute;
  String price;
  String priceForTakeaway;
  String imageurl;
  String showForEatin;
  String showForcatering;
  String optionid;

  ProductModel();
//  ProductModel(this.name, this.id, this.groupid, this.price, this.description, this.imageurl,this.groupname,
//  this.optionid, this.preparationminute, this.priceForTakeaway, this.showForcatering, this.showForEatin);
  ProductModel.fromJson(Map json)
  :
        groupid = json['groupid'] != null? json['groupid'] : '',
        groupname = json['groupname'] != null? json['groupname'] : '',
        id = json['id'] != null? json['id'] : '',
        name = json['name'] != null? json['name'] : '',
        description = json['description'] != null? json['description'] : '',
        preparationminute = json['preparationminute'] != null? json['preparationminute'] : '',
        price = json['price'] != null? json['price'] : '',
        priceForTakeaway = json['priceForTakeaway'] != null? json['priceForTakeaway'] : '',
        imageurl = json['imageurl'] != null? json['imageurl'] : '',
        showForEatin = json['showForEatin'] != null? json['showForEatin'] : '',
        showForcatering = json['showForcatering'] != null? json['showForcatering'] : '',
        optionid = json['optionid'] != null? json['optionid'] : '';
}


class DropDownlist{
  String name;
  DropDownlist(this.name);
}