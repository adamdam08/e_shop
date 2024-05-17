class CartListModel {
  String? message;
  List<ListData>? listData;

  CartListModel({this.message, this.listData});

  CartListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      listData = <ListData>[];
      json['data'].forEach((v) {
        listData!.add(new ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.listData != null) {
      data['data'] = this.listData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  int? id;
  String? namaCabang;
  List<CartData>? cartData;

  ListData({this.id, this.namaCabang, this.cartData});

  ListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaCabang = json['nama_cabang'];
    if (json['data'] != null) {
      cartData = <CartData>[];
      json['data'].forEach((v) {
        cartData!.add(new CartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_cabang'] = this.namaCabang;
    if (this.cartData != null) {
      data['data'] = this.cartData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartData {
  String? sId;
  int? pelangganId;
  int? cabangId;
  dynamic produkId;
  int? jumlah;
  String? catatan;
  String? createdAt;
  String? namaProduk;
  String? imageUrl;
  int? harga;
  int? hargaDiskon;
  int? diskon;
  int? stok;

  CartData(
      {this.sId,
      this.pelangganId,
      this.cabangId,
      this.produkId,
      this.jumlah,
      this.catatan,
      this.createdAt,
      this.namaProduk,
      this.imageUrl,
      this.harga,
      this.hargaDiskon,
      this.diskon,
      this.stok});

  CartData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    pelangganId = json['pelanggan_id'];
    cabangId = json['cabang_id'];
    produkId = json['produk_id'];
    jumlah = json['jumlah'];
    catatan = json['catatan'];
    createdAt = json['created_at'];
    namaProduk = json['nama_produk'];
    imageUrl = json['image_url'];
    harga = json['harga'];
    hargaDiskon = json['harga_diskon'];
    diskon = json['diskon'];
    stok = json['stok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['pelanggan_id'] = this.pelangganId;
    data['cabang_id'] = this.cabangId;
    data['produk_id'] = this.produkId;
    data['jumlah'] = this.jumlah;
    data['catatan'] = this.catatan;
    data['created_at'] = this.createdAt;
    data['nama_produk'] = this.namaProduk;
    data['image_url'] = this.imageUrl;
    data['harga'] = this.harga;
    data['harga_diskon'] = this.hargaDiskon;
    data['diskon'] = this.diskon;
    data['stok'] = this.stok;
    return data;
  }
}
