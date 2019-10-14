import 'package:flutter/material.dart';
import './article_list.dart';
import '../utils/custom_route.dart';
import '../utils/http.dart';
import '../api/api.dart';

class WeeklyList extends StatefulWidget {
  String title = '';
  String id = '';
  WeeklyList(this.title, this.id);
  @override
  State<StatefulWidget> createState() {
    // 将创建的State返回
    return WeeklyListState(title, id);
  }
}

class WeeklyListState extends State<WeeklyList> {
  List weeklies = [];
  String title = '';
  String id = '';
  List articleList = [];
  List category = [];
  WeeklyListState(this.title, this.id);
  // 获取期数
  _getWeeklies() {
    HttpUtil.post(Api.WEEKLIES_QUERY, data: {'topic': id}, success: (data) {
      setState(() {
        weeklies = data;
      });
    }, error: (errorMsg) {});
  }

  // 获取文章
  _getArticle(title, id) async {
    HttpUtil.post(Api.ARTICLES_QUERY, data: {'weekly': id}, success: (data) {
      List tempArr = [];
      data.forEach((value) {
        if (tempArr.isEmpty) {
          tempArr.add({
            'key': value['category']['key'],
            'name': value['category']['name']
          });
        }
        if (tempArr.isNotEmpty &&
            tempArr.every((item) => item['key'] != value['category']['key'])) {
          tempArr.add({
            'key': value['category']['key'],
            'name': value['category']['name']
          });
        }
      });
      setState(() {
        articleList = data;
        category = tempArr;
      });
      Navigator.push(
        context,
        CustomRouteSlide(ArticleList(title, category, articleList)),
      );
    }, error: (errorMsg) {
      print(errorMsg);
    });
  }

  @override
  void initState() {
    super.initState();
    _getWeeklies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> _refresh() async {
    // _dataList.clear();
    await _getWeeklies();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: RefreshIndicator(
            onRefresh: _refresh,
            //  backgroundColor: Colors.blue,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: weeklies.length, // item 的个数
              itemExtent: 50.0, // 如果为非null，则强制子项在滚动方向上具有给定范围
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ListTile(
                      title: Text("第${weeklies[index]['number']}期"), // item 标题r
                      // leading: Icon(Icons.keyboard), // item 前置图标
                      // subtitle: Text("subtitle $index"), // item 副标题
                      trailing: Icon(Icons.keyboard_arrow_right), // item 后置图标
                      isThreeLine: false, // item 是否三行显示
                      dense: true, // item 直观感受是整体大小
                      contentPadding:
                          EdgeInsets.fromLTRB(10, 0, 0, 0), // item 内容内边距
                      enabled: true,
                      onTap: () {
                        _getArticle("${title}第${weeklies[index]['number']}期",
                            "${weeklies[index]['_id']}");
                      }, // item onTap 点击事件
                      selected: false, // item 是否选中状态
                    ));
              },
            )));
  }
}
