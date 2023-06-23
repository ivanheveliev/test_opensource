class ResponseUserInfoAPIModel {
  String? message;
  String? name;
  String? phone;
  String? typeUser;

  ResponseUserInfoAPIModel(
      {this.message, this.name, this.phone, this.typeUser});

  ResponseUserInfoAPIModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    name = json['name'];
    phone = json['phone'];
    typeUser = json['type_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['type_user'] = this.typeUser;
    return data;
  }
}