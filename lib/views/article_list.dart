import 'package:flutter/material.dart';
import '../components/article_card.dart';

class ArticleList extends StatelessWidget {
  String title = '';
  String id = '';
  List articleList = [];
  List category = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 500.0,
      child: MyTabbedPage(title, category, articleList),
    );
  }

  ArticleList(this.title, this.category, this.articleList);
}

class MyTabbedPage extends StatefulWidget {
  String title = '';
  List articleList = [];
  List category = [];
  MyTabbedPage(this.title, this.category, this.articleList);
  @override
  _MyTabbedPageState createState() =>
      _MyTabbedPageState(title, category, articleList);
}

class _MyTabbedPageState extends State<MyTabbedPage>
    with SingleTickerProviderStateMixin {
  List articleList = [];
  List category = [];
  String title = '';
  List<Tab> myTabs = [];

  TabController tabController;

  _mapArticle(type) {
    List tempArr = [];
    articleList.forEach((value) {
      if (value['category']['key'] == type) {
        tempArr.add(value);
      }
    });
    return tempArr;
  }

  _MyTabbedPageState(this.title, this.category, this.articleList);
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: category.length);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: TabBar(
            controller: tabController,
            tabs: category.map((value) {
              return Tab(
                text: value['name'],
              );
            }).toList()),
      ),
      body: TabBarView(
          controller: tabController,
          children: category.map((value) {
            List tempArr = _mapArticle(value['key']);
            return ListView.builder(
                itemCount: tempArr.length,
                itemBuilder: (BuildContext context, int position) {
                  return ArticleItem(subject: tempArr[position]);
                });
          }).toList()),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _getArticle,
      //   child: Icon(Icons.refresh),
      // ),
    );
  }
}
