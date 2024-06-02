class CustomerDataModel {
  String? message;
  List<Data>? data;

  CustomerDataModel({this.message, this.data});

  CustomerDataModel.fromJson(Map<String, dynamic> json) {
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
  int? cabangId;
  int? cabangAktif;
  int? salesId;
  int? kategoriPelangganId;
  String? username;
  String? password;
  String? namaPelanggan;
  String? tglLahirPelanggan;
  String? jenisKelaminPelanggan;
  String? telpPelanggan;
  String? emailPelanggan;
  String? alamatPelanggan;
  String? provinsi;
  String? kabkota;
  String? kecamatan;
  String? kelurahan;
  double? lat;
  double? lon;

  Data(
      {this.id,
      this.cabangId,
      this.cabangAktif,
      this.salesId,
      this.kategoriPelangganId,
      this.username,
      this.password,
      this.namaPelanggan,
      this.tglLahirPelanggan,
      this.jenisKelaminPelanggan,
      this.telpPelanggan,
      this.emailPelanggan,
      this.alamatPelanggan,
      this.provinsi,
      this.kabkota,
      this.kecamatan,
      this.kelurahan,
      this.lat,
      this.lon});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangId = json['cabang_id'];
    cabangAktif = json['cabang_aktif'];
    salesId = json['sales_id'];
    kategoriPelangganId = json['kategori_pelanggan_id'];
    username = json['username'];
    password = json['password'];
    namaPelanggan = json['nama_pelanggan'];
    tglLahirPelanggan = json['tgl_lahir_pelanggan'];
    jenisKelaminPelanggan = json['jenis_kelamin_pelanggan'];
    telpPelanggan = json['telp_pelanggan'];
    emailPelanggan = json['email_pelanggan'];
    alamatPelanggan = json['alamat_pelanggan'];
    provinsi = json['provinsi'];
    kabkota = json['kabkota'];
    kecamatan = json['kecamatan'];
    kelurahan = json['kelurahan'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cabang_id'] = this.cabangId;
    data['cabang_aktif'] = this.cabangAktif;
    data['sales_id'] = this.salesId;
    data['kategori_pelanggan_id'] = this.kategoriPelangganId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['nama_pelanggan'] = this.namaPelanggan;
    data['tgl_lahir_pelanggan'] = this.tglLahirPelanggan;
    data['jenis_kelamin_pelanggan'] = this.jenisKelaminPelanggan;
    data['telp_pelanggan'] = this.telpPelanggan;
    data['email_pelanggan'] = this.emailPelanggan;
    data['alamat_pelanggan'] = this.alamatPelanggan;
    data['provinsi'] = this.provinsi;
    data['kabkota'] = this.kabkota;
    data['kecamatan'] = this.kecamatan;
    data['kelurahan'] = this.kelurahan;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}
