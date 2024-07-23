class TotalCartModel {
  String? message;
  TotalData? totalData;

  TotalCartModel({this.message, this.totalData});

  TotalCartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    totalData =
        json['data'] != null ? new TotalData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.totalData != null) {
      data['data'] = this.totalData!.toJson();
    }
    return data;
  }
}

class TotalData {
  int? total;

  TotalData({this.total});

  TotalData.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    return data;
  }
}
