import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/color_tool.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/auto_size_model.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/server_name.dart';
import 'package:wows_kokomi_app/models/user_model.dart';
import 'package:wows_kokomi_app/widgets/app_sys_page/error_widget.dart';

class UserInfoPage extends StatefulWidget {
  final String aid;
  final ServerName serverName;
  UserInfoPage({Key? key, required this.aid, required this.serverName})
      : super(key: key);
  final UserInfo userInfo = UserInfo();
  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool isDefaultAccount = false;
  late Future<void> _refreshData;
  @override
  void initState() {
    super.initState();
    _refreshData = _loadData();
    checkDefaultAccount();
  }

  void checkDefaultAccount() async {
    final defaultAccount = await LocalStorage.getDefaultAccount();
    if (defaultAccount != null) {
      final aidAndServerName = defaultAccount.split(':');
      if (aidAndServerName[0] == widget.aid &&
          aidAndServerName[2] == widget.serverName.name) {
        setState(() {
          isDefaultAccount = true;
        });
      }
    }
  }

  Future<void> _loadData() async {
    await widget.userInfo.init(widget.serverName, widget.aid);

    setState(() {});
  }

  void errorWidge(ErrorHttpModel? errorHttpModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HttpErrorWidget(errorModel: errorHttpModel)),
    );
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
              if (widget.userInfo.userInfoModel != null) {
                return SingleChildScrollView(
                  child: Column(
                    
                    children: [
                      Container(
                        
                        padding: const EdgeInsets.all(16),
                        child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '[${widget.userInfo.userInfoModel!.data.clan.tag}] ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: defaultFront,
                                      color: colorFromStr(widget
                                          .userInfo
                                          .userInfoModel!
                                          .data
                                          .clan
                                          .color), // 设置第一段文本的颜色
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${widget.userInfo.userInfoModel?.data.nickname}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: defaultFront,
                                      color: Colors.black, // 设置第二段文本的颜色
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size3),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: '注册日期: ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  TextSpan(
                                    text: widget.userInfo.userInfoModel!.data
                                        .user.accountCreationTime,
                                    style: const TextStyle(
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
                                    text: TextSpan(children: [
                                  const TextSpan(
                                    text: '最后战斗: ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  TextSpan(
                                    text:
                                        '${widget.userInfo.userInfoModel?.data.user.lastBattleTime}',
                                    style: const TextStyle(
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
                                  child: Text(
                                    widget.serverName.str,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size3),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: defaultFront / 2),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: colorFromStr(widget
                                    .userInfo
                                    .userInfoModel!
                                    .data
                                    .battleType
                                    .pvp
                                    .avgPrColor),
                              ),
                              child: Text(
                                '${strFromePR(widget.userInfo.userInfoModel!.data.battleType.pvp.avgPr)} (+${widget.userInfo.userInfoModel!.data.battleType.pvp.avgPrDis})',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
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
                                buildStatCard('战斗场次',
                                    '${widget.userInfo.userInfoModel?.data.battleType.pvp.battlesCount}',
                                    titleFontSize: size5, valueFontSize: size2),
                                buildStatCard('平均胜率',
                                    '${widget.userInfo.userInfoModel!.data.battleType.pvp.winRate}%',
                                    titleFontSize: size5,
                                    valueFontSize: size2,
                                    valueFontColor: colorFromStr(widget
                                        .userInfo
                                        .userInfoModel!
                                        .data
                                        .battleType
                                        .pvp
                                        .winRateColor)),
                                buildStatCard(
                                    '场均伤害',
                                    widget.userInfo.userInfoModel!.data
                                        .battleType.pvp.avgDamage
                                        .toString(),
                                    titleFontSize: size5,
                                    valueFontSize: size2,
                                    valueFontColor: colorFromStr(widget
                                        .userInfo
                                        .userInfoModel!
                                        .data
                                        .battleType
                                        .pvp
                                        .avgDamageColor)),
                                buildStatCard(
                                    '场均击杀',
                                    widget.userInfo.userInfoModel!.data
                                        .battleType.pvp.avgFrags
                                        .toString(),
                                    titleFontSize: size5,
                                    valueFontSize: size2,
                                    valueFontColor: colorFromStr(widget
                                        .userInfo
                                        .userInfoModel!
                                        .data
                                        .battleType
                                        .pvp
                                        .avgFragsColor)),
                                buildStatCard(
                                  '场均经验',
                                  widget.userInfo.userInfoModel!.data.battleType
                                      .pvp.avgExp
                                      .toString(),
                                  titleFontSize: size5,
                                  valueFontSize: size2,
                                ),
                                buildStatCard('主炮命中',
                                    '${widget.userInfo.userInfoModel!.data.battleType.pvp.hitRatio.toString()}%',
                                    titleFontSize: size5, valueFontSize: size2),
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
                          
                          ],
                        ),
                        
                      ),
                      Column(
                              
                              children: [
                                Text(
                                  '最高记录',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: defaultFront),
                                ),
                              ],
                            ),
                      if (!isDefaultAccount)
                        ElevatedButton(
                          onPressed: () async {
                            await LocalStorage.bindDefaultAccount(
                                widget.aid,widget.userInfo.userInfoModel!.data.nickname, widget.serverName);
                            setState(() {
                              isDefaultAccount = true;
                            });
                          },
                          child: const Text('绑定账号'),
                        ),
                    ],
                    
                  ),
                );
              } else {
                return HttpErrorWidget(errorModel: widget.userInfo.errorModel);
              }
            }
          }),
    );
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
            style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: valueFontWeight,
                color: valueFontColor),
          ),
        ],
      ),
    );
  }
}
