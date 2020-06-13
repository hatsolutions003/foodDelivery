class PresentationModel{
  String showwebpage;
  String webpage;
  String name;
  String url;
  String iframesrc;
  String iframestyle;
  String currency;

  PresentationModel.fromJson(Map json)
      :
        showwebpage = json['showwebpage'] != null? json['showwebpage'] : '',
        webpage = json['webpage'] != null? json['webpage'] : '',
        name = json['name'] != null? json['name'] : '',
        url = json['url'] != null? json['url'] : '',
        iframesrc = json['iframesrc'] != null? json['iframesrc'] : '',
        iframestyle = json['iframestyle'] != null? json['iframestyle'] : '',
        currency = json['currency'] != null? json['currency'] : '';
}