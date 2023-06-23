class ResponseRegistrationAPIModel {
  String? message;
  String? token;

  ResponseRegistrationAPIModel({this.message, this.token});

  ResponseRegistrationAPIModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['token'] = token;
    return data;
  }
}