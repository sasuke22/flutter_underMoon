import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_undermoon/CustomView/PhotoPageView.dart';
import 'package:flutter_undermoon/VIPS/User.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EnlisterInfo extends StatefulWidget {
  final User _user;
  EnlisterInfo(this._user);

  @override
  State createState() => _EnlisterInfoState();
}

class _EnlisterInfoState extends State<EnlisterInfo> {
  List<String> _picUrls = List<String>();
  ScrollController _scrollController = ScrollController();
  String _genderString;
  List<Widget> _photoList;
  List<ImageProvider> _imgProviderList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final height = screenWidth/1.72;
    double _statusBarHeight = MediaQuery.of(context).padding.top;
    var _photoGrid;

    if(_picUrls.length > 0){
      _photoGrid = GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(5.0),
        crossAxisCount: _picUrls.length < 3 ? _picUrls.length : 3,
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
        children: _displayPhoto(),
      );
    }else
      _photoGrid = Text('');

    return Scaffold(
      backgroundColor: Colors.white,
      body: null == widget._user ?
        SpinKitFadingCube (
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            );
          },
        )
        : Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              padding: EdgeInsets.only(bottom: 50),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      alignment: FractionalOffset(0.5, 1),
                      children: <Widget>[
                        Container(
                            height: height,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('images/background.jpg'),fit: BoxFit.cover),
                            )),
                        Padding(padding: EdgeInsets.only(bottom: 10),child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(DioUtil.PIC_SERVER + '${widget._user.id}/0.jpg'),
                              radius: 36.0,
                            ),
                            Text(
                              widget._user.userName,
                              textScaleFactor: 1.4,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${widget._user.location}  id:${widget._user.id}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('基本资料  $_genderString  ${widget._user.age}岁  ${widget._user.height}  ${widget._user.xingzuo}  ${widget._user.marry}  ${widget._user.job}'),
                    ),
                    Divider(height: 1),
                    Padding(padding: EdgeInsets.only(top: 8,left: 8,bottom: 8),child: Text('自我独白')),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(null == widget._user.userBriefIntro ? '暂无介绍' : widget._user.userBriefIntro),
                    ),
                    _photoGrid,
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: _statusBarHeight),child: BackButton(color: Colors.white,),),
          ]
        ),
    );
  }

  List<Widget> _displayPhoto() {
    _photoList = List<Widget>();
    _imgProviderList = [];
    Image _image;
    for(int i = 0;i < _picUrls.length;i++){
      _image = Image.network(_picUrls[i],height: 80.0,width: 80.0,fit: BoxFit.cover,);
      _imgProviderList.add(_image.image);
      _photoList.add(GestureDetector(
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoPageView(_imgProviderList,i)));},
        child: Card(
            elevation: 2.0,
            child: _image),
      ),
      );
    }
    return _photoList;
  }
}
