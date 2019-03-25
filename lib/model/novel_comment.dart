
class NovelComment {
  String nickName;
  String avatar;
  String content;

  NovelComment.fromJson(Map data) {
    nickName =data['nickName'];
    avatar =data['userPhoto'];
    content =data['text'];
  }
}