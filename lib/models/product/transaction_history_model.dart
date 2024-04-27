class TransactionHistoryModel {
  String? message;
  List<ListTransaksi>? listTransaksi;

  TransactionHistoryModel({this.message, this.listTransaksi});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      listTransaksi = <ListTransaksi>[];
      json['data'].forEach((v) {
        listTransaksi!.add(new ListTransaksi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.listTransaksi != null) {
      data['data'] = this.listTransaksi!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListTransaksi {
  String? sId;
  String? noInvoice;
  int? pelangganId;
  int? cabangId;
  int? kurirId;
  int? pengirimanId;
  String? namaKurir;
  int? totalHarga;
  int? totalOngkosKirim;
  int? totalBelanja;
  String? metodePembayaran;
  String? namaPenerima;
  String? alamatPenerima;
  String? bankTransfer;
  String? norekeningTransfer;
  int? status;
  String? keteranganStatus;
  bool? online;
  List<Produk>? produk;

  ListTransaksi(
      {this.sId,
      this.noInvoice,
      this.pelangganId,
      this.cabangId,
      this.kurirId,
      this.pengirimanId,
      this.namaKurir,
      this.totalHarga,
      this.totalOngkosKirim,
      this.totalBelanja,
      this.metodePembayaran,
      this.namaPenerima,
      this.alamatPenerima,
      this.bankTransfer,
      this.norekeningTransfer,
      this.status,
      this.keteranganStatus,
      this.online,
      this.produk});

  ListTransaksi.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    noInvoice = json['no_invoice'];
    pelangganId = json['pelanggan_id'];
    cabangId = json['cabang_id'];
    kurirId = json['kurir_id'];
    pengirimanId = json['pengiriman_id'];
    namaKurir = json['nama_kurir'];
    totalHarga = json['total_harga'];
    totalOngkosKirim = json['total_ongkos_kirim'];
    totalBelanja = json['total_belanja'];
    metodePembayaran = json['metode_pembayaran'];
    namaPenerima = json['nama_penerima'];
    alamatPenerima = json['alamat_penerima'];
    bankTransfer = json['bank_transfer'];
    norekeningTransfer = json['norekening_transfer'];
    status = json['status'];
    keteranganStatus = json['keterangan_status'];
    online = json['online'];
    if (json['produk'] != null) {
      produk = <Produk>[];
      json['produk'].forEach((v) {
        produk!.add(new Produk.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['no_invoice'] = this.noInvoice;
    data['pelanggan_id'] = this.pelangganId;
    data['cabang_id'] = this.cabangId;
    data['kurir_id'] = this.kurirId;
    data['pengiriman_id'] = this.pengirimanId;
    data['nama_kurir'] = this.namaKurir;
    data['total_harga'] = this.totalHarga;
    data['total_ongkos_kirim'] = this.totalOngkosKirim;
    data['total_belanja'] = this.totalBelanja;
    data['metode_pembayaran'] = this.metodePembayaran;
    data['nama_penerima'] = this.namaPenerima;
    data['alamat_penerima'] = this.alamatPenerima;
    data['bank_transfer'] = this.bankTransfer;
    data['norekening_transfer'] = this.norekeningTransfer;
    data['status'] = this.status;
    data['keterangan_status'] = this.keteranganStatus;
    data['online'] = this.online;
    if (this.produk != null) {
      data['produk'] = this.produk!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Produk {
  String? sId;
  String? noInvoice;
  int? id;
  int? cabangId;
  String? namaProduk;
  String? imageUrl;
  int? harga;
  int? jumlah;
  int? totalHarga;
  String? catatan;
  String? createdAt;

  Produk(
      {this.sId,
      this.noInvoice,
      this.id,
      this.cabangId,
      this.namaProduk,
      this.imageUrl,
      this.harga,
      this.jumlah,
      this.totalHarga,
      this.catatan,
      this.createdAt});

  Produk.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    noInvoice = json['no_invoice'];
    id = json['id'];
    cabangId = json['cabang_id'];
    namaProduk = json['nama_produk'];
    imageUrl = json['image_url'];
    harga = json['harga'];
    jumlah = json['jumlah'];
    totalHarga = json['total_harga'];
    catatan = json['catatan'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['no_invoice'] = this.noInvoice;
    data['id'] = this.id;
    data['cabang_id'] = this.cabangId;
    data['nama_produk'] = this.namaProduk;
    data['image_url'] = this.imageUrl;
    data['harga'] = this.harga;
    data['jumlah'] = this.jumlah;
    data['total_harga'] = this.totalHarga;
    data['catatan'] = this.catatan;
    data['created_at'] = this.createdAt;
    return data;
  }
}
