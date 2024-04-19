class CategoryTreeModel {
  String? message;
  List<Data>? data;

  CategoryTreeModel({this.message, this.data});

  CategoryTreeModel.fromJson(Map<String, dynamic> json) {
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
  String? kat1;
  String? kat1Slug;
  List<Child>? child;

  Data({this.kat1, this.kat1Slug, this.child});

  Data.fromJson(Map<String, dynamic> json) {
    kat1 = json['kat1'];
    kat1Slug = json['kat1_slug'];
    if (json['child'] != null) {
      child = <Child>[];
      json['child'].forEach((v) {
        child!.add(new Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kat1'] = this.kat1;
    data['kat1_slug'] = this.kat1Slug;
    if (this.child != null) {
      data['child'] = this.child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  String? kat2;
  String? kat1Slug;
  String? kat2Slug;
  List<Kat2Child>? kat2Child;

  Child({this.kat2, this.kat1Slug, this.kat2Slug, this.kat2Child});

  Child.fromJson(Map<String, dynamic> json) {
    kat2 = json['kat2'];
    kat1Slug = json['kat1_slug'];
    kat2Slug = json['kat2_slug'];
    if (json['child'] != null) {
      kat2Child = <Kat2Child>[];
      json['child'].forEach((v) {
        kat2Child!.add(new Kat2Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kat2'] = this.kat2;
    data['kat1_slug'] = this.kat1Slug;
    data['kat2_slug'] = this.kat2Slug;
    if (this.kat2Child != null) {
      data['kat2_child'] = this.kat2Child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Kat2Child {
  String? kat3;
  String? kat1Slug;
  String? kat2Slug;
  String? kat3Slug;

  Kat2Child({this.kat3, this.kat1Slug, this.kat2Slug, this.kat3Slug});

  Kat2Child.fromJson(Map<String, dynamic> json) {
    kat3 = json['kat3'];
    kat1Slug = json['kat1_slug'];
    kat2Slug = json['kat2_slug'];
    kat3Slug = json['kat3_slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kat3'] = this.kat3;
    data['kat1_slug'] = this.kat1Slug;
    data['kat2_slug'] = this.kat2Slug;
    data['kat3_slug'] = this.kat3Slug;
    return data;
  }
}
