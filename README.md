# Flutter 快速上手文档

**前言**：本文档主要帮助开发者快速上手 Flutter，暂无过多涉及 Flutter 开发模式、框架原理、底层原理渲染机制等等。所以切勿对于学习 Flutter 以及一门全新语言 Dart 望而却步。

## 一、什么是 Flutter
在使用一个工具之前，我们需要知道它的作用。
官方：Flutter 是谷歌主导研发的一个 UI 工具包，可以利用它，使用非常简洁的代码开发出漂亮的、原生的应用程序，无论是在移动端、Web 端还是桌面端。
个人理解：Flutter 就是一个 UI 开发工具包，可以开发各个平台，但是目前最活跃的地方依然 移动平台，虽然他也支持 Web、桌面，甚至也将是 Google Fuchsia 下开发应用的主要工具。但是现在，它只是活跃于移动端。
我们可以简单理解：Flutter 目前被应用最广泛的就是作为 iOS、Android 跨平台解决方案，而且可以说是目前最优秀的跨平台解决方案。它不仅仅性能优越，而且开发非常高效！

## 二、Flutter 开发语言
Flutter 并未选择 JavaScript 作为开发语言，尽管这样前端开发者的入门成本会更低，会有更多人选择学习和使用 Flutter。但早期的 Flutter 团队评估了十多种语言，并选择了 Dart，因为它符合他们构建用户界面的方式。
如果喜欢阅读文档学习语言，可以学习 Dart 语言中文教程
https://github.com/konieshadow/dart-tour
喜欢视频互动式学习的，可以到慕课网进行学习：Dart 编程语言入门
https://www.imooc.com/learn/1035

## 三、Flutter 环境搭建
根据官网（https://flutterchina.club/） 步骤下载好 flutter sdk、配置相关环境变量
建议安卓 SDK 直接在 Android Studio 中安装管理（后期添加模拟机型时可以具体配置，vscode 只有默认） ###使用命令行检测
所有环境准备好后，可在命令行使用 flutter doctor 进行检测
###vscode 配置
前端小伙伴可以选用 vscode，安装 flutter 扩展即可

## 四、从 0 开始撸一个技术周刊 demo
通过 flutter create [项目名] 可以快速创建一个 flutter 项目
`flutter create flutter-demo`
其中包含 Flutter 开发和测试需要的 lib、test，在开发过程中，我们主要使用的就是 lib 目录，打开发现里面有一个 main.dart，它是我们 Flutter 启动的入口文件，里面有入口函数 main 函数
另外一些是管理项目的配置文件信息等，当然也包括一些 Git 相关的文件
除此之外，还包括一个 Android 子工程和 iOS 子工程

在 main.dart 文件中声明 main 函数
runApp 是 Flutter 内部提供的一个函数，当我们启动一个 Flutter 应用程序时就是从调用这个函数开始的，该函数接受一个 Widget，即组件
使用 import 导入 Flutter 默认已经给我们提供的 Material 库，来使用其中的很多内置 Widget

> 这里涉及到项目的包管理，需要依赖的引用第三方库添加在 pubspec.yaml 文件中，执行 flutter packages get，使用时 import 进来即可

StatelessWidget 又是什么？在 Flutter 开发中，我们可以继承自 StatelessWidget 或者 StatefulWidget 来创建自己的 Widget 类

> StatelessWidget： 没有状态改变的 Widget，通常这种 Widget 仅仅是做一些展示工作而已
> StatefulWidget： 需要保存状态，并且可能出现状态改变的 Widget

```dart
//main.dart
import 'package:flutter/material.dart';
import './tab.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabDemo(),
    );
  }
}

```

在 tab.dart 文件中，我们使用了 FloatingActionButton 悬浮按钮、ListView 滚动列表等内置 Widget
其中 Scaffold 是什么呢？翻译过来是脚手架，脚手架的作用就是搭建页面的基本结构；Scaffold 也有一些属性，比如 appBar 和 body；appBar 是用于设计导航栏的
这里引入了 dio 的包，来进行 http 请求

```dart
//tab.dart
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

```

借鉴前端开发的组件化开发的思想
把每个列表项抽取为一个 Widget，接受父 Widget 传进来的每项数据
这里用到一些常用的行布局 Widget Row 和列布局 Widget Column
给每个列表项添加点击事件，使用 GestureDetector Widget，调用 url_launcher 包提供的 launch()方法，调起设备跳转链接

```dart
//article_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleItem extends StatelessWidget {
  Map subject;

  @override
  Widget build(BuildContext context) {
    return getItem();
  }

  getItem() {
    var row = GestureDetector(
        onTap: () {
          launch(subject['url']);
        },
        child: Container(
            margin: EdgeInsets.all(4.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      '${subject["title"]}',
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Image.network(
                          '${subject["img"]}',
                          width: 150.0,
                          height: 100.0,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(left: 8.0),
                        height: 100.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '分享人：',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  TextSpan(
                                    text: '${subject["submitter"]}',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
//                    原因
                            Text(
                              "${subject["reason"]}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ])));
    return Card(
      child: row,
    );
  }

  ArticleItem({this.subject});
}

```

## 五、发布
如何构建 Android 版 APP 在 Flutter 中文网上已经很详细说明
如配置 app 名称、启动图标、签名等
运行 flutter build apk，即可在相应目录打包好 apk 包
接下来就是去各个应用市场（运营商，如 360 手机助手、安卓市场、91 助手、App Store 等等）、应用商店（手机商，华为、小米、vivo、OPPO、魅族、三星等等）注册登录发布

### Flutter app 更新
Flutter 不支持 code-push
在 android 只能强制更新 apk 或者跳转到谷歌 stop 去下载
在 ios，只能提醒去 App Store 官网下载
具体实现类可参考https://www.jianshu.com/p/89f619c632dd
