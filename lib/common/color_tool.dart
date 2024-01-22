import 'package:flutter/material.dart';

const Color colorUnknown = Color.fromARGB(255, 128, 128, 128);
const Color colorNeedEffort = Color.fromARGB(255, 205, 51, 51);
const Color colorLowerAvg = Color.fromARGB(255, 254, 121, 3);
const Color colorAvg = Color.fromARGB(255, 255, 193, 7);
const Color colorGood = Color.fromARGB(255, 68, 179, 0);
const Color colorVeryGood = Color.fromARGB(255, 49, 128, 0);
const Color colorSuperGood = Color.fromARGB(255, 52, 186, 211);
const Color colorPink = Color.fromARGB(255, 121, 61, 182);
const Color colorSuperPink = Color.fromARGB(255, 88, 43, 128);


Color colorFromePR(final int pr) {
  if (pr >= 2450){
    return colorSuperPink;
  } else if (pr >= 2100) {
    return colorPink;
  } else if (pr >= 1750) {
    return colorSuperGood;
  } else if (pr >= 1550){
    return colorVeryGood;
  } else if (pr >= 1350) {
    return colorGood;
  } else if (pr >= 1100) {
    return colorAvg;
  } else if (pr >= 750) {
    return colorLowerAvg;
  } else if (pr >= 0) {
    return colorNeedEffort;
  }
  return colorUnknown;
}

Color colorFromeWR(int wr) {
  if (wr >= 70){
    return colorSuperPink;
  } else if (wr >= 60) {
    return colorPink;
  } else if (wr >= 55) {
    return colorSuperGood;
  } else if (wr >= 52.5){
    return colorVeryGood;
  } else if (wr >= 51) {
    return colorGood;
  } else if (wr >= 49) {
    return colorAvg;
  } else if (wr >= 45) {
    return colorLowerAvg;
  } else if (wr >= 0) {
    return colorNeedEffort;
  }
  return colorUnknown;
}

Color colorFromeDd(double dd) {
  if (dd >= 1.7){
    return colorSuperPink;
  } else if (dd >= 1.4) {
    return colorPink;
  } else if (dd >= 1.2) {
    return colorSuperGood;
  } else if (dd >= 1.1){
    return colorVeryGood;
  } else if (dd >= 1.0) {
    return colorGood;
  } else if (dd >= 0.95) {
    return colorAvg;
  } else if (dd >= 0.8) {
    return colorLowerAvg;
  } else if (dd >= 0) {
    return colorNeedEffort;
  }
  return colorUnknown;
}

Color colorFromeF(double f) {
  if (f >= 2.0){
    return colorSuperPink;
  } else if (f >= 1.5) {
    return colorPink;
  } else if (f >= 1.3) {
    return colorSuperGood;
  } else if (f >= 1.0){
    return colorVeryGood;
  } else if (f >= 0.6) {
    return colorGood;
  } else if (f >= 0.3) {
    return colorAvg;
  } else if (f >= 0.2) {
    return colorLowerAvg;
  } else if (f >= 0) {
    return colorNeedEffort;
  }
  return colorUnknown;
}