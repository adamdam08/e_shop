class PaymentModel {
  String? message;
  List<PaymentData>? paymentData;

  PaymentModel({this.message, this.paymentData});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      paymentData = <PaymentData>[];
      json['data'].forEach((v) {
        paymentData!.add(new PaymentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.paymentData != null) {
      data['data'] = this.paymentData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentData {
  String? kategori;
  List<ChildData>? child;

  PaymentData({this.kategori, this.child});

  PaymentData.fromJson(Map<String, dynamic> json) {
    kategori = json['kategori'];
    if (json['child'] != null) {
      child = <ChildData>[];
      json['child'].forEach((v) {
        child!.add(new ChildData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kategori'] = this.kategori;
    if (this.child != null) {
      data['child'] = this.child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildData {
  String? metode;
  String? nama;
  String? image;

  ChildData({this.metode, this.nama, this.image});

  ChildData.fromJson(Map<String, dynamic> json) {
    metode = json['metode'];
    nama = json['nama'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['metode'] = this.metode;
    data['nama'] = this.nama;
    data['image'] = this.image;
    return data;
  }
}
