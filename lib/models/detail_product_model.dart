class DetailProductModel {
  String? message;
  Data? data;

  DetailProductModel({this.message, this.data});

  DetailProductModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
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
  String? golonganProduk;
  String? merkProduk;
  String? deskripsiProduk;
  int? beratProduk;
  int? hargaPokok;
  String? multisatuanJumlah;
  String? multisatuanUnit;
  String? gambar1;
  String? gambar2;
  String? gambar3;
  String? gambar4;
  String? gambar5;
  int? isAktiva;
  String? kat1;
  String? kat1Slug;
  String? kat2;
  String? kat2Slug;
  String? kat3;
  String? kat3Slug;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<String>? gambar;
  List<Stok>? stok;
  List<Harga>? harga;
  double? rating;
  Keranjang? keranjang;

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
      this.isAktiva,
      this.kat1,
      this.kat1Slug,
      this.kat2,
      this.kat2Slug,
      this.kat3,
      this.kat3Slug,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.gambar,
      this.stok,
      this.harga,
      this.rating,
      this.keranjang});

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
    isAktiva = json['is_aktiva'];
    kat1 = json['kat1'];
    kat1Slug = json['kat1_slug'];
    kat2 = json['kat2'];
    kat2Slug = json['kat2_slug'];
    kat3 = json['kat3'];
    kat3Slug = json['kat3_slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    gambar = json['gambar'].cast<String>();
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
    rating = json['rating'];
    keranjang = json['keranjang'] != null
        ? new Keranjang.fromJson(json['keranjang'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['is_aktiva'] = this.isAktiva;
    data['kat1'] = this.kat1;
    data['kat1_slug'] = this.kat1Slug;
    data['kat2'] = this.kat2;
    data['kat2_slug'] = this.kat2Slug;
    data['kat3'] = this.kat3;
    data['kat3_slug'] = this.kat3Slug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['gambar'] = this.gambar;
    if (this.stok != null) {
      data['stok'] = this.stok!.map((v) => v.toJson()).toList();
    }
    if (this.harga != null) {
      data['harga'] = this.harga!.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    if (this.keranjang != null) {
      data['keranjang'] = this.keranjang!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cabang'] = this.cabang;
    data['harga'] = this.harga;
    data['harga_diskon'] = this.hargaDiskon;
    data['diskon'] = this.diskon;
    return data;
  }
}

class Keranjang {
  String? sId;
  int? jumlah;
  List<dynamic>? jumlahMultisatuan;

  Keranjang({this.sId, this.jumlah, this.jumlahMultisatuan});

  Keranjang.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    jumlah = json['jumlah'];
    jumlahMultisatuan = json['jumlah_multisatuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['jumlah'] = this.jumlah;
    data['jumlah_multisatuan'] = this.jumlahMultisatuan;
    return data;
  }
}
