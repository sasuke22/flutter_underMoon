import 'package:flutter/material.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:flutter_undermoon/meetings/MeetingItem.dart';

class MeetingListView extends StatelessWidget {
  final List<MeetingDetail> list;

  MeetingListView(this.list);

  @override
  Widget build(BuildContext context) {
    // ListView.builder 可以按需生成子控件
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return new MeetingItem(index, list[index]);
        }
    );
  }
}