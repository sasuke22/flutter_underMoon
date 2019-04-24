import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_undermoon/articles/ArticleListScreen.dart';
import 'package:flutter_undermoon/meetings/MeetingListScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        textTheme: TextTheme(display1: TextStyle(
          fontFamily: '.SF UI Text',
          inherit: false,
          fontSize: 13.4,
          fontWeight: FontWeight.w500,
          color: CupertinoColors.activeBlue,
          height: 1.036,
          letterSpacing: -0.25,
          textBaseline: TextBaseline.alphabetic,
        ),display2: TextStyle(
          fontFamily: '.SF UI Text',
          inherit: false,
          fontSize: 13.4,
          fontWeight: FontWeight.w500,
          color: CupertinoColors.destructiveRed,
          height: 1.036,
          letterSpacing: -0.25,
          textBaseline: TextBaseline.alphabetic,
        )),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Under moon server'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> _pages = List<Widget>();

  @override
  void initState() {
    _pages..add(MeetingListScreen())
      ..add(ArticleListScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _bottomNavigationBar = BottomNavigationBar(
      iconSize: 20,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            title: Text('邀约')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          title: Text('反馈'),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index){
        setState(() {
          _currentIndex = index;
        });
      },
    );
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _bottomNavigationBar,
    );
  }
}
