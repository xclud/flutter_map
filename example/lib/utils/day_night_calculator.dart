import 'dart:math';

import 'package:latlng/latlng.dart';

class DayNightCalculator {
  static DayNightBorder calculate(DateTime time, [int resolution = 2]) {
    var julianDay = _julian(time.millisecondsSinceEpoch);
    var gst = _gmst(julianDay);
    var latLng = <LatLng>[];

    var sunEclPos = _sunEclipticPosition(julianDay);
    var eclObliq = _eclipticObliquity(julianDay);
    var sunEqPos = _sunEquatorialPosition(sunEclPos.lambda, eclObliq);
    for (var i = 0; i <= 360 * resolution; i++) {
      var lng = -180 + i / resolution;
      var ha = _hourAngle(lng, sunEqPos, gst);
      latLng.add(LatLng(_latitude(ha, sunEqPos), lng));
    }

    return DayNightBorder._(latLng, sunEqPos.delta);
  }

  static LatLng calculateSunPosition(DateTime time) {
    var julianDay = _julian(time.millisecondsSinceEpoch);
    var gst = _gmst(julianDay);
    double num1 = gst * 2.7378507871321E-05;
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
    final distanceUA = 1.000001018 * (1.0 - num5 * cos(d));
    double num10 = distanceUA * 149597870.0;
    double num11 = pi /
        180.0 *
        (84381.448 - 46.815 * num1 - 0.00059 * num2 + 0.001813 * num1 * num2) *
        0.000277777777777778;
    double num12 = num10 * sin(num9);
    final sunX = num10 * cos(num9);
    final sunY = num12 * cos(num11);
    final sunZ = num12 * sin(num11);

    var sunLong = 180.0 / pi * ((atan2(sunY, sunX) - gst) % (2.0 * pi));
    if (sunLong > 180.0) sunLong -= 360.0;
    if (sunLong < -180.0) sunLong += 360.0;

    double x = sqrt(sunX * sunX + sunY * sunY);
    double num14 = atan2(sunZ, x);
    var sunLat = 0.0;
    do {
      sunLat = num14;
      double num15 = sin(sunLat);
      num14 = atan((sunZ +
              6378.136658 *
                  (1.0 / sqrt(1.0 - 0.00669431777826672 * num15 * num15)) *
                  0.00669431777826672 *
                  num15) /
          x);
    } while ((num14 - sunLat).abs() > 1E-07);
    sunLat = 180.0 / pi * sunLat;

    return LatLng(sunLat, sunLong);
  }
}

const double _r2d = 180 / pi;
const double d2r = pi / 180;

_LambdaRadius _sunEclipticPosition(double julianDay) {
  /* Compute the position of the Sun in ecliptic coordinates at
			 julianDay.  Following
			 http://en.wikipedia.org/wiki/Position_of_the_Sun */
  // Days since start of J2000.0
  var n = julianDay - 2451545.0;
  // mean longitude of the Sun
  var L = 280.460 + 0.9856474 * n;
  L %= 360;
  // mean anomaly of the Sun
  var g = 357.528 + 0.9856003 * n;
  g %= 360;
  // ecliptic longitude of Sun
  var lambda = L + 1.915 * sin(g * d2r) + 0.02 * sin(2 * g * d2r);
  // distance from Sun in AU
  var radius = 1.00014 - 0.01671 * cos(g * d2r) - 0.0014 * cos(2 * g * d2r);
  return _LambdaRadius(lambda: lambda, radius: radius);
}

double _eclipticObliquity(double julianDay) {
  // Following the short term expression in
  // http://en.wikipedia.org/wiki/Axial_tilt#Obliquity_of_the_ecliptic_.28Earth.27s_axial_tilt.29
  var n = julianDay - 2451545.0;
  // Julian centuries since J2000.0
  var T = n / 36525;
  var epsilon = 23.43929111 -
      T *
          (46.836769 / 3600 -
              T *
                  (0.0001831 / 3600 +
                      T *
                          (0.00200340 / 3600 -
                              T * (0.576e-6 / 3600 - T * 4.34e-8 / 3600))));
  return epsilon;
}

_AlphaDelta _sunEquatorialPosition(double sunEclLng, double eclObliq) {
  /* Compute the Sun's equatorial position from its ecliptic
		 * position. Inputs are expected in degrees. Outputs are in
		 * degrees as well. */
  var alpha = atan(cos(eclObliq * d2r) * tan(sunEclLng * d2r)) * _r2d;
  var delta = asin(sin(eclObliq * d2r) * sin(sunEclLng * d2r)) * _r2d;

  var lQuadrant = (sunEclLng / 90.0).floor() * 90;
  var raQuadrant = (alpha / 90.0).floor() * 90;
  alpha = alpha + (lQuadrant - raQuadrant);

  return _AlphaDelta(alpha: alpha, delta: delta);
}

double _hourAngle(double lng, _AlphaDelta sunPos, double gst) {
  /* Compute the hour angle of the sun for a longitude on
		 * Earth. Return the hour angle in degrees. */
  var lst = gst + lng / 15;
  return lst * 15 - sunPos.alpha;
}

double _latitude(double ha, _AlphaDelta sunPos) {
  /* For a given hour angle and sun position, compute the
		 * latitude of the terminator in degrees. */
  var lat = atan(-cos(ha * d2r) / tan(sunPos.delta * d2r)) * _r2d;
  return lat;
}

double _julian(int date) {
  /* Calculate the present UTC Julian Date. Function is valid after
	 * the beginning of the UNIX epoch 1970-01-01 and ignores leap
	 * seconds. */
  return (date / 86400000.0) + 2440587.5;
}

double _gmst(double julianDay) {
  /* Calculate Greenwich Mean Sidereal Time according to 
		 http://aa.usno.navy.mil/faq/docs/GAST.php */
  var d = julianDay - 2451545.0;
  // Low precision equation is good enough for our purposes.
  return (18.697374558 + 24.06570982441908 * d) % 24;
}

class _LambdaRadius {
  _LambdaRadius({required this.lambda, required this.radius});

  final double lambda;
  final double radius;
}

class _AlphaDelta {
  _AlphaDelta({required this.alpha, required this.delta});

  final double alpha;
  final double delta;
}

class DayNightBorder {
  DayNightBorder._(this.polyline, this.delta);
  final List<LatLng> polyline;
  final double delta;
}
