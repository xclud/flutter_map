import 'dart:math';

import 'package:latlng/latlng.dart';

const double _arcsecPerDeg = 3600.0;
const double _degPerArcsec = 1.0 / _arcsecPerDeg;

const double _t360 = 360.0;
const _deg2rad = pi / 180.0;

LatLng getSunLocation(DateTime utcNow) {
  final gst = toGreenwichMeanSiderealTime(utcNow);
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

  final latlng = toLatLng(gst, sunX, sunY, sunZ);
  return latlng;
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

LatLng getMoonLocation(DateTime utcNow) {
  final coef = <double>[0, 0, 0, 0, 0];
  final gst = toGreenwichMeanSiderealTime(utcNow);

  // -----------------'
  // Initialisations '
  // -----------------'
  var b0 = 0.0;
  var l0 = 0.0;
  var r0 = 0.0;
  final t = toJulian(utcNow) / 36525.0;
  final t2 = t * t;
  final t3 = t2 * t;
  final t4 = t3 * t;

  // Longitude moyenne de la Lune
  final ll = _deg2rad *
      ((218.3164477 +
              481267.88123421 * t -
              0.0015786 * t2 +
              t3 / 538841.0 -
              t4 / 65194000.0) %
          _t360);

  // Elongation moyenne de la Lune
  coef[0] = _deg2rad *
      ((297.8501921 +
              445267.1114034 * t -
              0.0018819 * t2 +
              t3 / 545868.0 -
              t4 / 113065000.0) %
          _t360);

  // Anomalie moyenne du Soleil
  coef[1] = _deg2rad *
      ((357.5291092 + 35999.0502909 * t - 0.0001536 * t2 + t3 / 24490000.0) %
          _t360);

  // Anomalie moyenne de la Lune
  coef[2] = _deg2rad *
      ((134.9633964 +
              477198.8675055 * t +
              0.0087414 * t2 +
              t3 / 69699.0 -
              t4 / 14712000.0) %
          _t360);

  // Argument de latitude de la Lune
  coef[3] = _deg2rad *
      ((93.272095 +
              483202.0175233 * t -
              0.0036539 * t2 -
              t3 / 3526000.0 +
              t4 / 863310000.0) %
          _t360);

  coef[4] = 1.0 - 0.002516 * t - 0.0000074 * t2;

  // ---------------------'
  // Corps de la methode '
  // ---------------------'
  for (var i = 0; i <= 59; i++) {
    var ang1 = 0.0;
    var ang2 = 0.0;
    var fact1 = 1.0;
    var fact2 = 1.0;
    for (var j = 0; j <= 3; j++) {
      ang1 += coef[j] * _tabCoef1[i][j];
      ang2 += coef[j] * _tabCoef2[i][j];
    }
    if (_tabCoef1[i][1] != 0) {
      fact1 = pow(coef[4], (_tabCoef1[i][1]).abs()).toDouble();
    }
    if (_tabCoef2[i][1] != 0) {
      fact2 = pow(coef[4], (_tabCoef2[i][1]).abs()).toDouble();
    }
    // Terme en longitude
    l0 += _tabLon[i] * fact1 * sin(ang1);

    // Terme en distance
    r0 += _tabDist[i] * fact1 * cos(ang1);

    // Terme en latitude
    b0 += _tabLat[i] * fact2 * sin(ang2);
  }

  // Principaux termes planetaires
  final a1 = _deg2rad * ((119.75 + 131.849 * t) % _t360);
  final a2 = _deg2rad * ((53.09 + 479264.29 * t) % _t360);
  final a3 = _deg2rad * ((313.45 + 481266.484 * t) % _t360);
  l0 += 3958.0 * sin(a1) + 1962.0 * sin(ll - coef[3]) + 318.0 * sin(a2);
  b0 += -2235.0 * sin(ll) +
      382.0 * sin(a3) +
      175.0 * (sin(a1 - coef[3]) + sin(a1 + coef[3])) +
      127.0 * sin(ll - coef[2]) -
      115.0 * sin(ll + coef[2]);

  // Coordonnees ecliptiques en repere spherique
  final lv = ll + _deg2rad * l0 * 0.000001;
  final bt = _deg2rad * b0 * 0.000001;
  final rp = 385000.56 + r0 * 0.001;

  final cb = cos(bt);
  final sb = sin(bt);
  final obliquite = _deg2rad *
      (84381.448 - 46.815 * t - 0.00059 * t2 + 0.001813 * t3) *
      _degPerArcsec;
  final ce = cos(obliquite);
  final se = sin(obliquite);
  final xx = rp * cb * sin(lv);

  final moonX = rp * cb * cos(lv);
  final moonY = xx * ce - rp * se * sb;
  final moonZ = xx * se + rp * ce * sb;

  final latlng = toLatLng(gst, moonX, moonY, moonZ);

  return latlng;
}

// Pour le calcul de la position
const _tabLon = <double>[
  6288774.0,
  1274027.0,
  658314.0,
  213618.0,
  -185116.0,
  -114332.0,
  58793.0,
  57066.0,
  53322.0,
  45758.0,
  -40923.0,
  -34720.0,
  -30383.0,
  15327.0,
  -12528.0,
  10980.0,
  10675.0,
  10034.0,
  8548.0,
  -7888.0,
  -6766.0,
  -5163.0,
  4987.0,
  4036.0,
  3994.0,
  3861.0,
  3665.0,
  -2689.0,
  -2602.0,
  2390.0,
  -2348.0,
  2236.0,
  -2120.0,
  -2069.0,
  2048.0,
  -1773.0,
  -1595.0,
  1215.0,
  -1110.0,
  -892.0,
  -810.0,
  759.0,
  -713.0,
  -700.0,
  691.0,
  596.0,
  549.0,
  537.0,
  520.0,
  -487.0,
  -399.0,
  -381.0,
  351.0,
  -340.0,
  330.0,
  327.0,
  -323.0,
  299.0,
  294.0,
  0.0
];
const _tabDist = <double>[
  -20905355.0,
  -3699111.0,
  -2955968.0,
  -569925.0,
  48888.0,
  -3149.0,
  246158.0,
  -152138.0,
  -170733.0,
  -204586.0,
  -129620.0,
  108743.0,
  104755.0,
  10321.0,
  0.0,
  79661.0,
  -34782.0,
  -23210.0,
  -21636.0,
  24208.0,
  30824.0,
  -8379.0,
  -16675.0,
  -12831.0,
  -10445.0,
  -11650.0,
  14403.0,
  -7003.0,
  0.0,
  10056.0,
  6322.0,
  -9884.0,
  5751.0,
  0.0,
  -4950.0,
  4130.0,
  0.0,
  -3958.0,
  0.0,
  3258.0,
  2616.0,
  -1897.0,
  -2117.0,
  2354.0,
  0.0,
  0.0,
  -1423.0,
  -1117.0,
  -1571.0,
  -1739.0,
  0.0,
  -4421.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1165.0,
  0.0,
  0.0,
  8752.0
];

const _tabLat = <double>[
  5128122.0,
  280602.0,
  277693.0,
  173237.0,
  55413.0,
  46271.0,
  32573.0,
  17198.0,
  9266.0,
  8822.0,
  8216.0,
  4324.0,
  4200.0,
  -3359.0,
  2463.0,
  2211.0,
  2065.0,
  -1870.0,
  1828.0,
  -1794.0,
  -1749.0,
  -1565.0,
  -1491.0,
  -1475.0,
  -1410.0,
  -1344.0,
  -1335.0,
  1107.0,
  1021.0,
  833.0,
  777.0,
  671.0,
  607.0,
  596.0,
  491.0,
  -451.0,
  439.0,
  422.0,
  421.0,
  -366.0,
  -351.0,
  331.0,
  315.0,
  302.0,
  -283.0,
  -229.0,
  223.0,
  223.0,
  -220.0,
  -220.0,
  -185.0,
  181.0,
  -177.0,
  176.0,
  166.0,
  -164.0,
  132.0,
  -119.0,
  115.0,
  107.0
];

const List<List<int>> _tabCoef1 = [
  [0, 0, 1, 0],
  [2, 0, -1, 0],
  [2, 0, 0, 0],
  [0, 0, 2, 0],
  [0, 1, 0, 0],
  [0, 0, 0, 2],
  [2, 0, -2, 0],
  [2, -1, -1, 0],
  [2, 0, 1, 0],
  [2, -1, 0, 0],
  [0, 1, -1, 0],
  [1, 0, 0, 0],
  [0, 1, 1, 0],
  [2, 0, 0, -2],
  [0, 0, 1, 2],
  [0, 0, 1, -2],
  [4, 0, -1, 0],
  [0, 0, 3, 0],
  [4, 0, -2, 0],
  [2, 1, -1, 0],
  [2, 1, 0, 0],
  [1, 0, -1, 0],
  [1, 1, 0, 0],
  [2, -1, 1, 0],
  [2, 0, 2, 0],
  [4, 0, 0, 0],
  [2, 0, -3, 0],
  [0, 1, -2, 0],
  [2, 0, -1, 2],
  [2, -1, -2, 0],
  [1, 0, 1, 0],
  [2, -2, 0, 0],
  [0, 1, 2, 0],
  [0, 2, 0, 0],
  [2, -2, -1, 0],
  [2, 0, 1, -2],
  [2, 0, 0, 2],
  [4, -1, -1, 0],
  [0, 0, 2, 2],
  [3, 0, -1, 0],
  [2, 1, 1, 0],
  [4, -1, -2, 0],
  [0, 2, -1, 0],
  [2, 2, -1, 0],
  [2, 1, -2, 0],
  [2, -1, 0, -2],
  [4, 0, 1, 0],
  [0, 0, 4, 0],
  [4, -1, 0, 0],
  [1, 0, -2, 0],
  [2, 1, 0, -2],
  [0, 0, 2, -2],
  [1, 1, 1, 0],
  [3, 0, -2, 0],
  [4, 0, -3, 0],
  [2, -1, 2, 0],
  [0, 2, 1, 0],
  [1, 1, -1, 0],
  [2, 0, 3, 0],
  [2, 0, -1, -2]
];
const List<List<int>> _tabCoef2 = [
  [0, 0, 0, 1],
  [0, 0, 1, 1],
  [0, 0, 1, -1],
  [2, 0, 0, -1],
  [2, 0, -1, 1],
  [2, 0, -1, -1],
  [2, 0, 0, 1],
  [0, 0, 2, 1],
  [2, 0, 1, -1],
  [0, 0, 2, -1],
  [2, -1, 0, -1],
  [2, 0, -2, -1],
  [2, 0, 1, 1],
  [2, 1, 0, -1],
  [2, -1, -1, 1],
  [2, -1, 0, 1],
  [2, -1, -1, -1],
  [0, 1, -1, -1],
  [4, 0, -1, -1],
  [0, 1, 0, 1],
  [0, 0, 0, 3],
  [0, 1, -1, 1],
  [1, 0, 0, 1],
  [0, 1, 1, 1],
  [0, 1, 1, -1],
  [0, 1, 0, -1],
  [1, 0, 0, -1],
  [0, 0, 3, 1],
  [4, 0, 0, -1],
  [4, 0, -1, 1],
  [0, 0, 1, -3],
  [4, 0, -2, 1],
  [2, 0, 0, -3],
  [2, 0, 2, -1],
  [2, -1, 1, -1],
  [2, 0, -2, 1],
  [0, 0, 3, -1],
  [2, 0, 2, 1],
  [2, 0, -3, -1],
  [2, 1, -1, 1],
  [2, 1, 0, 1],
  [4, 0, 0, 1],
  [2, -1, 1, 1],
  [2, -2, 0, -1],
  [0, 0, 1, 3],
  [2, 1, 1, -1],
  [1, 1, 0, -1],
  [1, 1, 0, 1],
  [0, 1, -2, -1],
  [2, 1, -1, -1],
  [1, 0, 1, 1],
  [2, -1, -2, -1],
  [0, 1, 2, 1],
  [4, 0, -2, -1],
  [4, -1, -1, -1],
  [1, 0, 1, -1],
  [4, 0, 1, -1],
  [1, 0, -1, -1],
  [4, -1, 0, -1],
  [2, -2, 0, 1]
];

LatLng toLatLng(double gst, double x, double y, double z) {
  var longitude = 180.0 / pi * ((atan2(y, x) - gst) % (2.0 * pi));
  if (longitude > 180.0) longitude -= 360.0;
  if (longitude < -180.0) longitude += 360.0;
  final r0 = sqrt(x * x + y * y);
  double latitude = atan2(z, r0);
  const e2 = 0.00669431777826672;
  const radius = 6378.136658;

  while (true) {
    final lat = latitude;
    final sph = sin(latitude);
    final c = 1.0 / sqrt(1.0 - e2 * sph * sph);
    latitude = atan((z + radius * c * e2 * sph) / r0);

    if ((lat - latitude).abs() <= 1E-07) {
      break;
    }
  }

  latitude = 180.0 / pi * latitude;

  return LatLng(latitude, longitude);
}
