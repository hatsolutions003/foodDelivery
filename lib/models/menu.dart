class MenuModel{
  String id;
  String name;
  String showForEatin;
  String showForTakeaway;

  MenuModel(this.name);
  MenuModel.fromJson(Map json)
      :
        id = json['id'] != null? json['id'] : '',
        name = json['name'] != null? json['name'] : '',
        showForEatin = json['showForEatin'] != null? json['showForEatin'] : '',
        showForTakeaway = json['showForTakeaway'] != null? json['showForTakeaway'] : '';
}