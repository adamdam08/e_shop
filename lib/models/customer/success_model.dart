class SuccessModel {
  String? message;
  String? PaymentData;

  SuccessModel({this.message, this.PaymentData});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    PaymentData = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['data'] = this.PaymentData;
    return data;
  }
}
