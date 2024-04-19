class BannerModel {
  String? message;
  List<Data>? data;

  BannerModel({this.message, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
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
  String? namaPromo;
  String? gambarPromo;
  String? expiredAt;

  Data({this.id, this.namaPromo, this.gambarPromo, this.expiredAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaPromo = json['nama_promo'];
    gambarPromo = json['gambar_promo'];
    expiredAt = json['expired_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_promo'] = this.namaPromo;
    data['gambar_promo'] = this.gambarPromo;
    data['expired_at'] = this.expiredAt;
    return data;
  }
}
