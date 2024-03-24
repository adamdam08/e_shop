class ProductCategoryModel {
  String? message;
  List<Data>? data;

  ProductCategoryModel({this.message, this.data});

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? kat1;
  String? kat1Slug;
  String? kat2;
  String? kat2Slug;
  String? kat3;
  String? kat3Slug;

  Data(
      {this.id,
      this.kat1,
      this.kat1Slug,
      this.kat2,
      this.kat2Slug,
      this.kat3,
      this.kat3Slug});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kat1 = json['kat1'];
    kat1Slug = json['kat1_slug'];
    kat2 = json['kat2'];
    kat2Slug = json['kat2_slug'];
    kat3 = json['kat3'];
    kat3Slug = json['kat3_slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kat1'] = this.kat1;
    data['kat1_slug'] = this.kat1Slug;
    data['kat2'] = this.kat2;
    data['kat2_slug'] = this.kat2Slug;
    data['kat3'] = this.kat3;
    data['kat3_slug'] = this.kat3Slug;
    return data;
  }
}
