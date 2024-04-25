class ShippingModel {
  String? message;
  List<ShipData>? shipData;

  ShippingModel({this.message, this.shipData});

  ShippingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      shipData = <ShipData>[];
      json['data'].forEach((v) {
        shipData!.add(new ShipData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.shipData != null) {
      data['data'] = this.shipData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShipData {
  int? id;
  int? cabangId;
  String? namaKurir;

  ShipData({this.id, this.cabangId, this.namaKurir});

  ShipData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangId = json['cabang_id'];
    namaKurir = json['nama_kurir'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cabang_id'] = this.cabangId;
    data['nama_kurir'] = this.namaKurir;
    return data;
  }
}
