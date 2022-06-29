import 'dart:math';

import 'package:latlng/latlng.dart';

LatLng getSunLocation(DateTime utcNow) {
  var gst = toGreenwichMeanSiderealTime(utcNow);
  double num1 = toJulian(utcNow) * 2.7378507871321E-05;
  double num2 = num1 * num1;
  double num3 = pi /
      180.0 *
      ((280.466457 + 36000.7698278 * num1 + 0.00030322 * num2) % 360.0);
  double num4 = pi /
      180.0 *
      ((282.937348 + 1.7195366 * num1 + 0.00045688 * num2) % 360.0);
  double num5 = 0.01670843 - 4.2037E-05 * num1 - 1.267E-07 * num2;
  double num6 = num3 - num4;
  double d = num6;
  double num7;
  do {
    num7 = d;
    d = num7 + (num6 + num5 * sin(num7) - num7) / (1.0 - num5 * cos(num7));
  } while ((d - num7).abs() > 1E-09);
  double num8 = 2.0 * atan(sqrt((1.0 + num5) / (1.0 - num5)) * tan(0.5 * d));
  double num9 = num4 + num8;
  var distanceUA = 1.000001018 * (1.0 - num5 * cos(d));
  double num10 = distanceUA * 149597870.0;
  double num11 = pi /
      180.0 *
      (84381.448 - 46.815 * num1 - 0.00059 * num2 + 0.001813 * num1 * num2) *
      0.000277777777777778;
  double num12 = num10 * sin(num9);
  var sunX = num10 * cos(num9);
  var sunY = num12 * cos(num11);
  var sunZ = num12 * sin(num11);

  var longitude = 180.0 / pi * ((atan2(sunY, sunX) - gst) % (2.0 * pi));
  if (longitude > 180.0) longitude -= 360.0;
  if (longitude < -180.0) longitude += 360.0;
  double x = sqrt(sunX * sunX + sunY * sunY);
  double num14 = atan2(sunZ, x);
  double latitude = num14;
  do {
    latitude = num14;
    double num15 = sin(latitude);
    num14 = atan((sunZ +
            6378.136658 *
                (1.0 / sqrt(1.0 - 0.00669431777826672 * num15 * num15)) *
                0.00669431777826672 *
                num15) /
        x);
  } while ((num14 - latitude).abs() > 1E-07);
  latitude = 180.0 / pi * latitude;

  return LatLng(latitude, longitude);
}

double toJulian(DateTime utc) {
  utc = utc.toUtc();

  int year = utc.year;
  int month = utc.month;
  var day = utc.day;
  var hour = utc.hour;
  var minute = utc.minute;
  var second = utc.second;

  double num1 = day +
      hour * (1.0 / 24.0) +
      minute * 0.000694444444444444 +
      second * 1.15740740740741E-05;
  if (month < 3) {
    year--;
    month += 12;
  }
  int num2 = year ~/ 100;
  int num3 = 2 - num2 + (num2 ~/ 4);
  var dayJulian = (365.25 * (year - 2000)).floor() +
      (30.6001 * (month + 1)).floor() +
      num1 +
      num3 -
      50.5;

  return dayJulian;
}

double toGreenwichMeanSiderealTime(DateTime utc) {
  var jd = toJulian(utc);

  double num1 = jd * 2.7378507871321E-05;
  double num2 = num1 * num1;

  var v = 280.46061837 +
      360.98564736629 * jd +
      0.000387933 * num2 -
      num2 * num1 / 38710000.0;
  return pi / 180.0 * (v % 360.0);
}
