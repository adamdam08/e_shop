class DistrictModel {
  String? message;
  List<DistrictData>? districtData;

  DistrictModel({this.message, this.districtData});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      districtData = <DistrictData>[];
      json['data'].forEach((v) {
        districtData!.add(new DistrictData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.districtData != null) {
      data['data'] = this.districtData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DistrictData {
  String? name;
  String? value;

  DistrictData({this.name, this.value});

  DistrictData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
