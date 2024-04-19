class SuggestionModel {
  String? message;
  List<String>? data;

  SuggestionModel({this.message, this.data});

  SuggestionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> datax = new Map<String, dynamic>();
    datax['message'] = this.message;
    datax['data'] = this.data;
    return datax;
  }
}
