class CustomerRequestUpdateModel {
  String? message;
  RequestData? requestData;

  CustomerRequestUpdateModel({this.message, this.requestData});

  CustomerRequestUpdateModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    requestData =
        json['data'] != null ? new RequestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.requestData != null) {
      data['data'] = this.requestData!.toJson();
    }
    return data;
  }
}

class RequestData {
  int? id;
  int? pelangganId;
  int? pegawaiId;
  String keterangan = "";
  String? confirmedAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? confirmed;

  RequestData(
      {this.id,
      this.pelangganId,
      this.pegawaiId,
      required this.keterangan,
      this.confirmedAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.confirmed});

  RequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pelangganId = json['pelanggan_id'];
    pegawaiId = json['pegawai_id'];
    keterangan = json['keterangan'];
    confirmedAt = json['confirmed_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    confirmed = json['confirmed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pelanggan_id'] = this.pelangganId;
    data['pegawai_id'] = this.pegawaiId;
    data['keterangan'] = this.keterangan;
    data['confirmed_at'] = this.confirmedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['confirmed'] = this.confirmed;
    return data;
  }
}
