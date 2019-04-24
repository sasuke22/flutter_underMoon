import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UnderMoonDialog extends StatefulWidget{
  final String title;

  UnderMoonDialog(this.title);

  @override
  State<StatefulWidget> createState() =>DialogState(title);

}

class DialogState extends State<UnderMoonDialog>{
  String title;

  DialogState(this.title);

  @override
  Widget build(BuildContext context) {
    return Material( //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Center( //保证控件居中效果
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitFadingCube(
                  color: Colors.lightBlue,
                  size: 40.0,
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}