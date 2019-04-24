class Article {
  int id;//反馈id
  int userId;//反馈作者id
  int gender;//反馈作者性别
  DateTime date;//反馈上传时间
  String title;//反馈标题
  String content;//反馈内容
  int pics;//反馈图片数量
  int approve;//0:未审核,1:审核通过,-1:审核不通过
  String reason;

  Article({this.id,this.userId,this.gender,this.date,this.title,this.content,this.pics});

  Article.fromJson(Map<String,dynamic> json)
  : id = json['id'],
  userId = json['userId'],
  gender = json['gender'],
  date = DateTime.parse(json['date']),
  title = json['title']?.replaceAll('^', ' '),
  content = json['content']?.replaceAll('^', ' '),
  pics = json['pics'],
  approve = json['approve'],
  reason = json['reason']?.replaceAll('^', ' ');

  Map<String,dynamic> toJson() =>
      {
        'id' : id,
        'userId' : userId,
        'gender' : gender,
        'date' : date,
        'title' : title?.replaceAll(' ', '^'),
        'content' : content?.replaceAll(' ', '^'),
        'pics' : pics,
        'approve' : approve,
        'reason' : reason?.replaceAll(' ', '^')
      };
}