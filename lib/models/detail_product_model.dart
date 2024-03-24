class DetailProductModel {
  String? message;
  Data? data;

  DetailProductModel({this.message, this.data});

  DetailProductModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? produkKategoriId;
  String? kodeProduk;
  String? barcodeProduk;
  String? namaProduk;
  String? satuanProduk;
  Stream? golonganProduk;
  String? merkProduk;
  String? deskripsiProduk;
  int? beratProduk;
  String? hargaPokok;
  String? multisatuanJumlah;
  String? multisatuanUnit;
  String? gambar1;
  String? gambar2;
  String? gambar3;
  String? gambar4;
  String? gambar5;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Stok>? stok;
  List<Harga>? harga;

  Data(
      {this.id,
      this.produkKategoriId,
      this.kodeProduk,
      this.barcodeProduk,
      this.namaProduk,
      this.satuanProduk,
      this.golonganProduk,
      this.merkProduk,
      this.deskripsiProduk,
      this.beratProduk,
      this.hargaPokok,
      this.multisatuanJumlah,
      this.multisatuanUnit,
      this.gambar1,
      this.gambar2,
      this.gambar3,
      this.gambar4,
      this.gambar5,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.stok,
      this.harga});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    produkKategoriId = json['produk_kategori_id'];
    kodeProduk = json['kode_produk'];
    barcodeProduk = json['barcode_produk'];
    namaProduk = json['nama_produk'];
    satuanProduk = json['satuan_produk'];
    golonganProduk = json['golongan_produk'];
    merkProduk = json['merk_produk'];
    deskripsiProduk = json['deskripsi_produk'];
    beratProduk = json['berat_produk'];
    hargaPokok = json['harga_pokok'];
    multisatuanJumlah = json['multisatuan_jumlah'];
    multisatuanUnit = json['multisatuan_unit'];
    gambar1 = json['gambar1'];
    gambar2 = json['gambar2'];
    gambar3 = json['gambar3'];
    gambar4 = json['gambar4'];
    gambar5 = json['gambar5'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['stok'] != null) {
      stok = <Stok>[];
      json['stok'].forEach((v) {
        stok!.add(new Stok.fromJson(v));
      });
    }
    if (json['harga'] != null) {
      harga = <Harga>[];
      json['harga'].forEach((v) {
        harga!.add(new Harga.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['produk_kategori_id'] = this.produkKategoriId;
    data['kode_produk'] = this.kodeProduk;
    data['barcode_produk'] = this.barcodeProduk;
    data['nama_produk'] = this.namaProduk;
    data['satuan_produk'] = this.satuanProduk;
    data['golongan_produk'] = this.golonganProduk;
    data['merk_produk'] = this.merkProduk;
    data['deskripsi_produk'] = this.deskripsiProduk;
    data['berat_produk'] = this.beratProduk;
    data['harga_pokok'] = this.hargaPokok;
    data['multisatuan_jumlah'] = this.multisatuanJumlah;
    data['multisatuan_unit'] = this.multisatuanUnit;
    data['gambar1'] = this.gambar1;
    data['gambar2'] = this.gambar2;
    data['gambar3'] = this.gambar3;
    data['gambar4'] = this.gambar4;
    data['gambar5'] = this.gambar5;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.stok != null) {
      data['stok'] = this.stok!.map((v) => v.toJson()).toList();
    }
    if (this.harga != null) {
      data['harga'] = this.harga!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stok {
  String? cabang;
  int? stok;

  Stok({this.cabang, this.stok});

  Stok.fromJson(Map<String, dynamic> json) {
    cabang = json['cabang'];
    stok = json['stok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cabang'] = this.cabang;
    data['stok'] = this.stok;
    return data;
  }
}

class Harga {
  String? cabang;
  int? harga;
  int? hargaDiskon;
  int? diskon;

  Harga({this.cabang, this.harga, this.hargaDiskon, this.diskon});

  Harga.fromJson(Map<String, dynamic> json) {
    cabang = json['cabang'];
    harga = json['harga'];
    hargaDiskon = json['harga_diskon'];
    diskon = json['diskon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cabang'] = this.cabang;
    data['harga'] = this.harga;
    data['harga_diskon'] = this.hargaDiskon;
    data['diskon'] = this.diskon;
    return data;
  }
}
