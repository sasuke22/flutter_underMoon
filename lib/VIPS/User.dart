class User{
  int id;
  String account;
  String userName;
  String password;
  int gender; // 0代表女生 1代表男生
  bool isOnline;
  String location;
  int age;
  String userBriefIntro;
  int height;
  String marry;
  String job;
  String figure;
  String xingzuo;
  String photoAddress;
  int score;
  int lock;
  bool bigVip;
  bool isVip;

  User({this.account,this.password,this.id,this.userName,this.location,this.age,this.height,this.marry,this.job,this.figure,
    this.xingzuo,this.userBriefIntro = '暂无介绍',this.lock});

  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
    account = json['account']?.replaceAll('^', ' '),
    userName = json['userName']?.replaceAll('^', ' '),
    password = json['password']?.replaceAll('^', ' '),
    gender = json['gender'],
    isOnline = json['isOnline'],
    location = json['location']?.replaceAll('^', ' '),
    age = json['age'],
    userBriefIntro = json['userBriefIntro']?.replaceAll('^', ' '),
    height = json['height'],
    marry = json['marry'],
    job = json['job']?.replaceAll('^', ' '),
    figure = json['figure'],
    xingzuo = json['xingzuo'],
    photoAddress = json['photoAddress'],
    score = json['score'],
    lock = json['lock'],
    isVip = DateTime.parse(json['vipDate']).isAfter(DateTime.now().add(Duration(seconds: 5))),
    bigVip = DateTime.parse(json['bigVip']).isAfter(DateTime.now());

  Map<String, dynamic> toJson() =>
    {
      'id' : id,
      'account' : account?.replaceAll(' ', '^'),
      'userName' : userName?.replaceAll(' ', '^'),
      'password' : password?.replaceAll(' ', '^'),
      'gender' : gender,
      'isOnline' : isOnline,
      'location' : location?.replaceAll(' ', '^'),
      'age' : age,
      'userBriefIntro' : userBriefIntro == '' ? null : userBriefIntro?.replaceAll(' ', '^'),
      'height' : height,
      'marry' : marry,
      'job' : job?.replaceAll(' ', '^'),
      'figure' : figure == '' ? null : figure,
      'xingzuo' : xingzuo,
      'photoAddress' : photoAddress == '' ? null : photoAddress,
      'score' : score,
      'lock' : lock
    };
}