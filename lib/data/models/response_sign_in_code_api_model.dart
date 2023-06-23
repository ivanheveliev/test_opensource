class ResponseSignInCodeAPIModel {
  String? message;
  int? codeOut;

  ResponseSignInCodeAPIModel({this.message, this.codeOut});

  ResponseSignInCodeAPIModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    codeOut = json['code_out'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code_out'] = codeOut;
    return data;
  }
}