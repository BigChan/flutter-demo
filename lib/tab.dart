import 'package:flutter/material.dart';
import 'article_card.dart';
import 'package:dio/dio.dart';

class TabDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      child: MyTabbedPage(),
    );
  }
}

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({Key key}) : super(key: key);
  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage>
    with SingleTickerProviderStateMixin {
  List articleList = [];
  final List<Tab> myTabs = <Tab>[
    Tab(text: '最近资讯'),
    Tab(text: '技术推荐'),
    Tab(text: '工具推荐'),
    Tab(text: '安全更新'),
  ];

  TabController _tabController;
  // 获取文章
  _getArticle() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get("http://172.18.30.55:8888/api/article");
    if (response.data is List) {
      setState(() {
        articleList = response.data;
      });
    }
  }

  _mapArticle(int type) {
    List tempArr = [];
    articleList.forEach((value) {
      if (value['type'] == type) {
        tempArr.add(value);
      }
    });
    return ListView.builder(
        itemCount: tempArr.length,
        itemBuilder: (BuildContext context, int position) {
          return ArticleItem(subject: tempArr[position]);
        });
  }

  _MyTabbedPageState() {
    _getArticle();
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _getArticle();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('技术周刊'),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _mapArticle(1),
          _mapArticle(2),
          _mapArticle(3),
          _mapArticle(4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getArticle,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
