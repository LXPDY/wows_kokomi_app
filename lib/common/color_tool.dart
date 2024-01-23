import 'package:flutter/material.dart';


String strFromePR(final int pr) {
  if (pr >= 2450){
    return "神佬平均";
  } else if (pr >= 2100) {
    return "大佬平均";
  } else if (pr >= 1750) {
    return "非常好";
  } else if (pr >= 1550){
    return "很好";
  } else if (pr >= 1350) {
    return "好";
  } else if (pr >= 1100) {
    return "平均水平";
  } else if (pr >= 750) {
    return "低于平均";
  } else if (pr >= 0) {
    return "还需努力";
  }
  return "水平未知	";
}

Color colorFromStr(String str) {
  String valueString = str.replaceAll('#', '0xFF'); // 将 # 替换为 0xFF
int value = int.parse(valueString); // 将字符串转换为整数
return Color(value);
}
