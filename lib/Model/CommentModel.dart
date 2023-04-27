class CommentModel {
  String title;
  String username;

  CommentModel(this.title,this.username);

  CommentModel.fromJson(Map<String, dynamic> json)
      :title = json['title'],
        username = json['username'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'username': username,
  };
}