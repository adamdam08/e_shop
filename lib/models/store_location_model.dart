class StoreLocationModel {
  String? message;
  List<Data>? data;

  StoreLocationModel({this.message, this.data});

  StoreLocationModel.fromJson(Map<String, dynamic> json) {
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
  int? cabangKelasId;
  String? namaCabang;
  String? alamatCabang;
  double? latitude;
  double? longitude;
  int? jarak;
  String? jarakSatuan;
  bool? terdekat;

  Data(
      {this.id,
      this.cabangKelasId,
      this.namaCabang,
      this.alamatCabang,
      this.latitude,
      this.longitude,
      this.jarak,
      this.jarakSatuan,
      this.terdekat});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangKelasId = json['cabang_kelas_id'];
    namaCabang = json['nama_cabang'];
    alamatCabang = json['alamat_cabang'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    jarak = json['jarak'];
    jarakSatuan = json['jarak_satuan'];
    terdekat = json['terdekat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cabang_kelas_id'] = this.cabangKelasId;
    data['nama_cabang'] = this.namaCabang;
    data['alamat_cabang'] = this.alamatCabang;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['jarak'] = this.jarak;
    data['jarak_satuan'] = this.jarakSatuan;
    data['terdekat'] = this.terdekat;
    return data;
  }
}
