import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/color_tool.dart';
import 'package:wows_kokomi_app/models/auto_size_model.dart';
import 'package:wows_kokomi_app/models/user_model.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPage();
}

class _UserInfoPage extends State<UserInfoPage> {
  late Future<void> _refreshData;
  UserInfo userInfo = UserInfo();
  @override
  void initState() {
    super.initState();
    _refreshData = _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final defaultFront = FontSize.of(context, 0.05);
    final size2 = defaultFront * 0.8;
    final size3 = defaultFront * 0.5;
    final size4 = defaultFront * 0.25;
    final size5 = defaultFront * 0.6;

    return Scaffold(
        body: FutureBuilder<void>(
            future: _refreshData,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return RefreshIndicator(
                  onRefresh: () {
                    setState(() {
                      _refreshData = _loadData();
                    });
                    return _refreshData;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        Text(
                          '[TIF-K] Sangonomi yaKokomi_',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: defaultFront),
                        ),
                        SizedBox(height: size3),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '注册日期: ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextSpan(
                                text: '2019.06.14 12:24:36',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: const TextSpan(children: [
                              TextSpan(
                                text: '最后战斗: ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextSpan(
                                text: '2023.01.18 12:00:00',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ])),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: defaultFront / 2,
                                  vertical: defaultFront / 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '亚服',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size3),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: defaultFront / 2),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colorFromePR(-1),
                          ),
                          child: const Text(
                            '水平未知（+000)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: size3),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          childAspectRatio: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            buildStatCard('战斗场次', '100000',
                                titleFontSize: size5,
                                valueFontSize: size2),
                            buildStatCard('平均胜率', '60%',
                                titleFontSize: size5,
                                valueFontSize: size2,
                                valueFontColor: colorFromeWR(60)),
                            buildStatCard('场均伤害', '2000',
                                titleFontSize: size5,
                                valueFontSize: size2,
                                valueFontColor: colorFromeDd(1.1)),
                            buildStatCard('场均击杀', '2',
                                titleFontSize: size5,
                                valueFontSize: size2,
                                valueFontColor: colorFromeF(2)),
                            buildStatCard('场均经验', '500',
                                titleFontSize: size5,
                                valueFontSize: size2),
                            buildStatCard('主炮命中', '80%',
                                titleFontSize: size5,
                                valueFontSize: size2),
                          ],
                        ),
                        SizedBox(height: size3),
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('TODO:详细战绩'),
                              SizedBox(height: size3),
                              // 在此处添加其他布局内容
                            ],
                          ),
                        ),
                        SizedBox(height: defaultFront),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '最高记录',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: defaultFront),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  Widget buildStatCard(String title, String value,
      {double titleFontSize = 12,
      double valueFontSize = 16,
      FontWeight titleFontWeight = FontWeight.bold,
      FontWeight valueFontWeight = FontWeight.bold,
      Color valueFontColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: titleFontSize,
                fontWeight: titleFontWeight),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style:
                TextStyle(fontSize: valueFontSize, fontWeight: valueFontWeight, color: valueFontColor),
          ),
        ],
      ),
    );
  }
}
