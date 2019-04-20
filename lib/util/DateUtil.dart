class DateUtil {
  static DateTime formatExpiresTime(String str) {
    var expiresTime =
        RegExp("Expires[^;]*;").stringMatch(str).split(" ")[1].split("-");
    var year = expiresTime[2];
    var day = expiresTime[0];
    var month = _getMonthByStr(expiresTime[1]);
    return DateTime.parse("$year$month$day");
  }

  static String getFormattedTime(DateTime time){
    return "${time.month}-${time.day} ${time.hour}:${time.minute}";
  }

  static String getFormattedTimeSecond(DateTime time){
    var year = time.year;
    var month = time.month;
    var day = time.day;
    var hour = time.hour;
    var min = time.minute;
    var sec = time.second;
    return "$year-$month-$day $hour:$min:$sec";
  }

  static DateTime getDaysAgo(int days) {
    return DateTime.now().subtract(Duration(days: days));
  }

  static int getAge(DateTime date){
    int nowYear = DateTime.now().year;
    int nowMonth = DateTime.now().month;
    int nowDay = DateTime.now().day;
    int age = nowYear - date.year;
    if(nowMonth > date.month){
      age += 1;
    }else if(nowMonth == date.month){
      if(nowDay >= date.day) age += 1;
    }
    return age;
  }

  static String getConstellation(DateTime date){
    int month = date.month;
    int day = date.day;
    int temp = month *100 + day;
    if (temp >= 120 && temp <= 218) {
      return "水瓶座";
    } else if (temp >= 219 && temp <= 320) {
      return "双鱼座";
    } else if (temp >= 321 && temp <= 419) {
      return "白羊座";
    } else if (temp >= 420 && temp <= 520) {
      return "金牛座";
    } else if (temp >= 521 && temp <= 621) {
      return "双子座";
    } else if (temp >= 622 && temp <= 722) {
      return "巨蟹座";
    } else if (temp >= 723 && temp <= 822) {
      return "狮子座";
    } else if (temp >= 823 && temp <= 922) {
      return "处女座";
    } else if (temp >= 923 && temp <= 1023) {
      return "天秤座";
    } else if (temp >= 1024 && temp <= 1122) {
      return "天蝎座";
    } else if (temp >= 1123 && temp <= 1221) {
      return "射手座";
    } else
      return "摩羯座";
  }

  static int _getMonthByStr(String str) {
    int output = 1;
    switch (str) {
      case "Jan":
        output = 1;
        break;
      case "Feb":
        output = 2;
        break;
      case "Mar":
        output = 3;
        break;
      case "Apr":
        output = 4;
        break;
      case "May":
        output = 5;
        break;
      case "Jun":
        output = 6;
        break;
      case "Jul":
        output = 7;
        break;
      case "Aug":
        output = 8;
        break;
      case "Sep":
        output = 9;
        break;
      case "Oct":
        output = 10;
        break;
      case "Nov":
        output = 11;
        break;
      case "Dec":
        output = 12;
        break;
    }
    return output;
  }
}
