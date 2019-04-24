class MeetingDetail{
  int meetingId;
  int id;
  String city;
  String summary;
  DateTime date;
  int gender;
  int approve;
  String type;
  String loveType;
  int age;
  String marry;
  int height;
  String job;
  String figure;
  String xingzuo;
  String content;
  int commentCount;
  String enlistersName;
  int score;
  int pics;
  String reason;

  MeetingDetail(this.id,this.city,this.content,this.summary,{this.date,this.age,this.height,this.job,this.gender,this.figure,this.xingzuo});

  MeetingDetail.fromJson(Map<String, dynamic> json)
    : meetingId = json['meetingId'],
    id = json['id'],
    city = (json['city'] as String)?.replaceAll('^', ' '),
    summary = (json['summary'] as String)?.replaceAll('^', ' '),
    date = DateTime.parse(json['date']),
    gender = json['gender'],
    approve = json['approve'],
    type = json['type'],
    loveType = json['loveType'],
    age = json['age'],
    marry = json['marry'],
    height = json['height'],
    job = json['job']?.replaceAll('^', ' '),
    figure = json['figure'],
    xingzuo = json['xingzuo'],
    content = (json['content'] as String)?.replaceAll('^', ' '),
    commentCount = json['commentCount'],
    enlistersName = json['enlistersName'],
    score = json['score'],
    pics = json['pics'],
    reason = json['reason'];

  Map<String, dynamic> toJson() =>
  {
    'meetingId' : meetingId,
    'id' : id,
    'city' : city?.replaceAll(' ', '^'),
    'summary' : summary?.replaceAll(' ', '^'),
    'date' : date,
    'gender' : gender,
    'approve' : approve,
    'type' : type,
    'loveType' : loveType,
    'age' : age,
    'marry' : marry,
    'height' : height,
    'job' : job,
    'figure' : figure,
    'xingzuo' : xingzuo,
    'content' : content?.replaceAll(' ', '^'),
    'commentCount' : commentCount,
    'enlistersName' : enlistersName,
    'score' : score,
    'pics' : pics,
    'reason' : reason
  };
}