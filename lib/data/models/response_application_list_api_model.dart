class ResponseApplicationListAPIModel {
  String? message;
  List<Application>? items;

  ResponseApplicationListAPIModel({this.message, this.items});

  ResponseApplicationListAPIModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['items'] != null) {
      items = <Application>[];
      json['items'].forEach((v) {
        items!.add(new Application.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Application {
  String? id;
  String? name;
  String? created;
  String? content;
  Author? author;
  String? status;

  Application({this.id, this.name, this.created, this.content, this.author});

  Application.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    created = json['created'];
    content = json['content'];
    status = json['status'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created'] = this.created;
    data['content'] = this.content;
    data['status'] = this.status;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    return data;
  }
}

class Author {
  String? id;
  String? name;
  String? phone;

  Author({this.id, this.name, this.phone});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}