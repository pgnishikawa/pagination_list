// issue
class IssueModel {
  int number;
  String html_url;
  String title;
  DateTime updated_at;
  UserModel user;

  IssueModel({
    required this.number,
    required this.html_url,
    required this.title,
    required this.updated_at,
    required this.user,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      number: json['number'],
      html_url: json['html_url'],
      title: json['title'],
      updated_at: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(json['user']),
    );
  }

  @override
  String toString() {
    return '$number:$title:$updated_at:$user';
  }
}

// user
class UserModel {
  int id;
  String avatar_url;
  String login;

  UserModel({
    required this.id,
    required this.avatar_url,
    required this.login,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      avatar_url: json['avatar_url'],
      login: json['login'],
    );
  }

  @override
  String toString() {
    return '$id:$login';
  }
}
