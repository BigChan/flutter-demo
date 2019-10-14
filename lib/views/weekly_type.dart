import 'package:flutter/material.dart';
import './weekly_list.dart';
import '../utils/custom_route.dart';
import '../utils/http.dart';
import '../api/api.dart';

class WeeklyType extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // 将创建的State返回
    return WeeklyTypeState();
  }
}

class WeeklyTypeState extends State<WeeklyType> {
  List topics = [];
  _getTopics() {
    HttpUtil.post(Api.TOPICS_QUERY, success: (data) {
      setState(() {
        topics = data;
      });
    }, error: (errorMsg) {});
  }

  @override
  void initState() {
    super.initState();
    _getTopics();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> _refresh() async {
    // _dataList.clear();
    await _getTopics();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('专题'),
        ),
        body: RefreshIndicator(
            onRefresh: _refresh,
            //  backgroundColor: Colors.blue,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: topics.length, // item 的个数
              itemExtent: 50.0, // 如果为非null，则强制子项在滚动方向上具有给定范围
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ListTile(
                      title: Text("${topics[index]['name']}"), // item 标题r
                      // leading: Icon(Icons.keyboard), // item 前置图标
                      // subtitle: Text("subtitle $index"), // item 副标题
                      trailing: Icon(Icons.keyboard_arrow_right), // item 后置图标
                      isThreeLine: false, // item 是否三行显示
                      dense: true, // item 直观感受是整体大小
                      contentPadding:
                          EdgeInsets.fromLTRB(10, 0, 0, 0), // item 内容内边距
                      enabled: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          CustomRouteSlide(WeeklyList(
                              "${topics[index]['name']}",
                              "${topics[index]['_id']}")),
                        );
                      }, // item onTap 点击事件
                      selected: false, // item 是否选中状态
                    ));
              },
            )));
  }
}
