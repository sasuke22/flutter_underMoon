import 'package:flutter/material.dart';

class PhotoPageView extends StatefulWidget{
  final List<ImageProvider> _list;
  final int _index;

  PhotoPageView(this._list,this._index);

  @override
  State<StatefulWidget> createState() => PhotoPageViewState();
}

class PhotoPageViewState extends State<PhotoPageView>{
  PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: widget._index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
          physics: BouncingScrollPhysics(),
          controller: _controller,
          itemCount: widget._list.length,
          itemBuilder: _buildItem
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: (){Navigator.pop(context);},
      child: Image(
        image: widget._list[index],
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}