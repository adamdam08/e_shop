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
  int? id;
  int? cabangId;
  String? namaBank;
  String? logoBank;
  String? noRekening;

  PaymentData(
      {this.id, this.cabangId, this.namaBank, this.logoBank, this.noRekening});

  PaymentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangId = json['cabang_id'];
    namaBank = json['nama_bank'];
    logoBank = json['logo_bank'];
    noRekening = json['no_rekening'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cabang_id'] = this.cabangId;
    data['nama_bank'] = this.namaBank;
    data['logo_bank'] = this.logoBank;
    data['no_rekening'] = this.noRekening;
    return data;
  }
}
