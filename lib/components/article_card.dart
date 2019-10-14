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
                          '${subject["coverUrl"]}',
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
                                    // text: '${subject["submitter"]}',
                                    text: '推荐人',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
//                    原因
                            Text(
                              "${subject["description"]}",
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
