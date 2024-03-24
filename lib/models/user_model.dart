import 'dart:convert';

UserModel userModelFromJson(String str) {
  final jsonData = json.decode(str);
  return UserModel.fromJson(jsonData);
}

String userModelToJson(UserModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UserModel {
  String? token;
  Data data;

  UserModel({
    this.token,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json["token"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "data": data.toJson(),
      };
}

class Data {
  int? id;
  int? pegawaiKategoriId;
  int? cabangId;
  dynamic gudangId;
  String? bagian;
  String? username;
  String? password;
  String? email;
  String? namaLengkap;
  String? namaDepan;
  String? namaBelakang;
  String? telp;
  String? alamat;
  dynamic foto;
  dynamic roles;
  int? isSuperadmin;
  int? status;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.pegawaiKategoriId,
    this.cabangId,
    required this.gudangId,
    this.bagian,
    this.username,
    this.password,
    this.email,
    this.namaLengkap,
    this.namaDepan,
    this.namaBelakang,
    this.telp,
    this.alamat,
    required this.foto,
    required this.roles,
    this.isSuperadmin,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        pegawaiKategoriId: json["pegawai_kategori_id"],
        cabangId: json["cabang_id"],
        gudangId: json["gudang_id"],
        bagian: json["bagian"],
        username: json["username"],
        password: json["password"],
        email: json["email"],
        namaLengkap: json["nama_lengkap"],
        namaDepan: json["nama_depan"],
        namaBelakang: json["nama_belakang"],
        telp: json["telp"],
        alamat: json["alamat"],
        foto: json["foto"],
        roles: json["roles"],
        isSuperadmin: json["is_superadmin"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pegawai_kategori_id": pegawaiKategoriId,
        "cabang_id": cabangId,
        "gudang_id": gudangId,
        "bagian": bagian,
        "username": username,
        "password": password,
        "email": email,
        "nama_lengkap": namaLengkap,
        "nama_depan": namaDepan,
        "nama_belakang": namaBelakang,
        "telp": telp,
        "alamat": alamat,
        "foto": foto,
        "roles": roles,
        "is_superadmin": isSuperadmin,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
