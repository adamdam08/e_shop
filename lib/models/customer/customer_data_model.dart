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
  int? salesId;
  int? kategoriPelangganId;
  String? username;
  String? password;
  String? namaPelanggan;
  String? tglLahirPelanggan;
  String? jenisKelaminPelanggan;
  String? alamatPelanggan;
  String? telpPelanggan;
  String? emailPelanggan;
  String? lat;
  String? lon;

  Data(
      {this.id,
      this.cabangId,
      this.salesId,
      this.kategoriPelangganId,
      this.username,
      this.password,
      this.namaPelanggan,
      this.tglLahirPelanggan,
      this.jenisKelaminPelanggan,
      this.alamatPelanggan,
      this.telpPelanggan,
      this.emailPelanggan,
      this.lat,
      this.lon});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangId = json['cabang_id'];
    salesId = json['sales_id'];
    kategoriPelangganId = json['kategori_pelanggan_id'];
    username = json['username'];
    password = json['password'];
    namaPelanggan = json['nama_pelanggan'];
    tglLahirPelanggan = json['tgl_lahir_pelanggan'];
    jenisKelaminPelanggan = json['jenis_kelamin_pelanggan'];
    alamatPelanggan = json['alamat_pelanggan'];
    telpPelanggan = json['telp_pelanggan'];
    emailPelanggan = json['email_pelanggan'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cabang_id'] = this.cabangId;
    data['sales_id'] = this.salesId;
    data['kategori_pelanggan_id'] = this.kategoriPelangganId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['nama_pelanggan'] = this.namaPelanggan;
    data['tgl_lahir_pelanggan'] = this.tglLahirPelanggan;
    data['jenis_kelamin_pelanggan'] = this.jenisKelaminPelanggan;
    data['alamat_pelanggan'] = this.alamatPelanggan;
    data['telp_pelanggan'] = this.telpPelanggan;
    data['email_pelanggan'] = this.emailPelanggan;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}
