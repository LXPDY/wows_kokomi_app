import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/color_tool.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/auto_size_model.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/enum_name.dart';
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
    final size6 = defaultFront * 0.9;
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
                                      horizontal: size3, vertical: size4),
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
                              padding: EdgeInsets.symmetric(vertical: size3),
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
                              padding: const EdgeInsets.all(0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('详细数据',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: defaultFront)),
                                      const Divider(),
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 0.0),
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(Icons.person,
                                              color: Colors.white, size: 24),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('单野',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: defaultFront)),
                                            Text(
                                                '${strFromePR(widget.userInfo.userInfoModel!.data.battleType.pvpSolo.avgPr)} (+${widget.userInfo.userInfoModel!.data.battleType.pvpSolo.avgPrDis})',
                                                style: TextStyle(
                                                    color: colorFromStr(widget
                                                        .userInfo
                                                        .userInfoModel!
                                                        .data
                                                        .battleType
                                                        .pvpSolo
                                                        .avgPrColor),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: size5)),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${widget.userInfo.userInfoModel!.data.battleType.pvpSolo.battlesCount} 场',
                                                style:
                                                    TextStyle(fontSize: size6)),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.pvpSolo.winRate}%',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .pvpSolo
                                                                .winRateColor),
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text: ' | ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.pvpSolo.avgDamage}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .pvpSolo
                                                                .avgDamageColor),
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text: ' | ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.pvpSolo.avgFrags}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .pvpSolo
                                                                .avgFragsColor),
                                                        fontSize: size5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 0.0),
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(Icons.group,
                                              color: Colors.white, size: 24),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('自行车',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: defaultFront)),
                                            Text(
                                                '${strFromePR(widget.userInfo.userInfoModel!.data.battleType.pvpDiv2.avgPr)} (+${widget.userInfo.userInfoModel!.data.battleType.pvpDiv2.avgPrDis})',
                                                style: TextStyle(
                                                    color: colorFromStr(widget
                                                        .userInfo
                                                        .userInfoModel!
                                                        .data
                                                        .battleType
                                                        .pvpDiv2
                                                        .avgPrColor),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: size5)),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${widget.userInfo.userInfoModel!.data.battleType.pvpDiv2.battlesCount} 场',
                                                style:
                                                    TextStyle(fontSize: size6)),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.pvpDiv2.winRate}%',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .pvpDiv2
                                                                .winRateColor),
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text: ' | ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.pvpDiv2.avgDamage}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .pvpDiv2
                                                                .avgDamageColor),
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text: ' | ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.pvpDiv2.avgFrags}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .pvpDiv2
                                                                .avgFragsColor),
                                                        fontSize: size5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 0.0),
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(Icons.groups,
                                              color: Colors.white, size: 24),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('三轮车',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: defaultFront)),
                                            Text(
                                                '${strFromePR(widget.userInfo.userInfoModel!.data.battleType.pvpDiv3.avgPr)} (+${widget.userInfo.userInfoModel!.data.battleType.pvpDiv3.avgPrDis})',
                                                style: TextStyle(
                                                    color: colorFromStr(widget
                                                        .userInfo
                                                        .userInfoModel!
                                                        .data
                                                        .battleType
                                                        .pvpDiv3
                                                        .avgPrColor),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: size5)),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${widget.userInfo.userInfoModel!.data.battleType.pvpDiv3.battlesCount} 场',
                                                style:
                                                    TextStyle(fontSize: size6)),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.pvpDiv3.winRate}%',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .pvpDiv3
                                                                .winRateColor),
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text: ' | ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.pvpDiv3.avgDamage}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .pvpDiv3
                                                                .avgDamageColor),
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text: ' | ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.pvpDiv3.avgFrags}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .pvpDiv3
                                                                .avgFragsColor),
                                                        fontSize: size5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 0.0),
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(Icons.perm_identity_sharp,
                                              color: Colors.white, size: 24),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('排位',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: defaultFront)),
                                            Text(
                                                '${strFromePR(widget.userInfo.userInfoModel!.data.battleType.rankSolo.avgPr)} (+${widget.userInfo.userInfoModel!.data.battleType.rankSolo.avgPrDis})',
                                                style: TextStyle(
                                                    color: colorFromStr(widget
                                                        .userInfo
                                                        .userInfoModel!
                                                        .data
                                                        .battleType
                                                        .rankSolo
                                                        .avgPrColor),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: size5)),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${widget.userInfo.userInfoModel!.data.battleType.rankSolo.battlesCount} 场',
                                                style:
                                                    TextStyle(fontSize: size6)),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.rankSolo.winRate}%',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .rankSolo
                                                                .winRateColor),
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text: ' | ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.rankSolo.avgDamage}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .rankSolo
                                                                .avgDamageColor),
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text: ' | ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: size5),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${widget.userInfo.userInfoModel!.data.battleType.rankSolo.avgFrags}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: colorFromStr(
                                                            widget
                                                                .userInfo
                                                                .userInfoModel!
                                                                .data
                                                                .battleType
                                                                .rankSolo
                                                                .avgFragsColor),
                                                        fontSize: size5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'TODO:最高记录',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: defaultFront),
                          ),
                          FutureBuilder<Image>(
                            future: LocalStorage.getImage('http://www.wows-coral.com/ship_icons/PASA002.png'),
                            builder: (BuildContext context,
                                AsyncSnapshot<Image> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return snapshot.data ?? const SizedBox();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.error != null) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const Text('Unknown error');
                              }
                            },
                          ),
                        ],
                      ),
                      if (!isDefaultAccount)
                        ElevatedButton(
                          onPressed: () async {
                            await LocalStorage.bindDefaultAccount(
                                widget.aid,
                                widget.userInfo.userInfoModel!.data.nickname,
                                widget.serverName);
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
