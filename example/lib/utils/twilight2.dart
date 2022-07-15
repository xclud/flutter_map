import 'dart:math';

const double sunriseSunsetAltitude = -35.0 / 60.0;
const double civilTwilightAltitude = -6.0;
const double nauticalTwilightAltitude = -12.0;
const double astronomicalTwilightAltitude = -18.0;

class Sunriset {
  Sunriset._(this.tsunrise, this.tsunset, this.code);

  final double tsunrise;
  final double tsunset;
  final int code;
}

/// <summary>
/// Compute sunrise/sunset times UTC
/// </summary>
/// <param name="year">The year</param>
/// <param name="month">The month of year</param>
/// <param name="day">The day of month</param>
/// <param name="lat">The latitude</param>
/// <param name="lng">The longitude</param>
/// <param name="tsunrise">The computed sunrise time (in seconds)</param>
/// <param name="tsunset">The computed sunset time (in seconds)</param>
Sunriset sunRiseSet(int year, int month, int day, double lat, double lng) {
  return calculate(year, month, day, lng, lat, sunriseSunsetAltitude, true);
}

/// <summary>
/// Compute civil twilight times UTC
/// </summary>
/// <param name="year">The year</param>
/// <param name="month">The month of year</param>
/// <param name="day">The day of month</param>
/// <param name="lat">The latitude</param>
/// <param name="lng">The longitude</param>
/// <param name="tsunrise">The computed civil twilight time at sunrise (in seconds)</param>
/// <param name="tsunset">The computed civil twilight time at sunset (in seconds)</param>
Sunriset civil(int year, int month, int day, double lat, double lng) {
  return calculate(year, month, day, lng, lat, civilTwilightAltitude, false);
}

/// <summary>
/// Compute nautical twilight times UTC
/// </summary>
/// <param name="year">The year</param>
/// <param name="month">The month of year</param>
/// <param name="day">The day of month</param>
/// <param name="lat">The latitude</param>
/// <param name="lng">The longitude</param>
/// <param name="tsunrise">The computed nautical twilight time at sunrise (in seconds)</param>
/// <param name="tsunset">The computed nautical twilight time at sunset (in seconds)</param>
Sunriset nautical(
  int year,
  int month,
  int day,
  double lat,
  double lng,
) {
  return calculate(
    year,
    month,
    day,
    lng,
    lat,
    nauticalTwilightAltitude,
    false,
  );
}

/// <summary>
/// Compute astronomical twilight times UTC
/// </summary>
/// <param name="year">The year</param>
/// <param name="month">The month of year</param>
/// <param name="day">The day of month</param>
/// <param name="lat">The latitude</param>
/// <param name="lng">The longitude</param>
/// <param name="tsunrise">The computed astronomical twilight time at sunrise (in seconds)</param>
/// <param name="tsunset">The computed astronomical twilight time at sunset (in seconds)</param>
Sunriset astronomical(
  int year,
  int month,
  int day,
  double lat,
  double lng,
) {
  return calculate(
    year,
    month,
    day,
    lng,
    lat,
    astronomicalTwilightAltitude,
    false,
  );
}

/// <summary>
/// The "workhorse" function for sun rise/set times
/// Note: year,month,date = calendar date, 1801-2099 only.
/// Eastern longitude positive, Western longitude negative
/// Northern latitude positive, Southern latitude negative
/// The longitude value IS critical in this function!
/// </summary>
/// <param name="year"></param>
/// <param name="month"></param>
/// <param name="day"></param>
/// <param name="lon"></param>
/// <param name="lat"></param>
/// <param name="altit">
/// the altitude which the Sun should cross
/// Set to -35/60 degrees for rise/set, -6 degrees
/// for civil, -12 degrees for nautical and -18
/// degrees for astronomical twilight.
/// </param>
/// <param name="upper_limb">
/// true -> upper limb, false -> center
/// Set to true (e.g. 1) when computing rise/set
/// times, and to false when computing start/end of twilight.
/// </param>
/// <param name="trise">where to store the rise time</param>
/// <param name="tset">where to store the set time</param>
/// <returns>
///  0	=	sun rises/sets this day, times stored at trise and tset
/// +1	=	sun above the specified "horizon" 24 hours.
///			trise set to time when the sun is at south,
///			minus 12 hours while *tset is set to the south
///			time plus 12 hours. "Day" length = 24 hours
/// -1	=	sun is below the specified "horizon" 24 hours
///			"Day" length = 0 hours, *trise and *tset are
///			both set to the time when the sun is at south.
/// </returns>
Sunriset calculate(
  int year,
  int month,
  int day,
  double lon,
  double lat,
  double altit,
  bool upperLimb,
) {
  int rc = 0; /* Return code from function - usually 0 */

  /* Compute d of 12h local mean solar time */

  // Days since 2000 Jan 0.0 (negative before).
  final d = _daysSince2000Jan0(year, month, day) + 0.5 - lon / 360.0;

  /* Compute the local sidereal time of this moment */
  // Local sidereal time */
  final sidtime = _revolution(_gmst0(d) + 180.0 + lon);

  /* Compute Sun's RA, Decl and distance at this moment */
  final sun = _sunRightADec(d);

  /* Compute time when Sun is at south - in hours UT */

  // Time when Sun is at south.
  final tsouth = 12.0 - _rev180(sidtime - sun.rightAscencation) / 15.0;

  /* Compute the Sun's apparent radius in degrees */
  // Sun's apparent radius.
  final sradius = 0.2666 / sun.distance;

  /* Do correction to upper limb, if necessary */
  if (upperLimb) altit -= sradius;

  /* Compute the diurnal arc that the Sun traverses to reach */
  /* the specified altitude altit: */

  // Diurnal arc.
  var t = 0.0;

  {
    final cost = (sin(altit) - sin(lat) * sin(sun.declination)) /
        (cos(lat) * cos(sun.declination));

// Sun always below altit.
    if (cost >= 1.0) {
      rc = -1;
      t = 0.0;
    } else if (cost <= -1.0) /* Sun always above altit */
    {
      rc = 1;
      t = 12.0;
    } else {
      t = acos(cost) / 15.0; /* The diurnal arc, hours */
    }
  }

  /* Store rise and set times - in hours UT */
  final rise = tsouth - t;
  final set = tsouth + t;

  return Sunriset._(rise, set, rc);
}

/* +++Date last modified: 05-Jul-1997 */
/* Updated comments, 05-Aug-2013 */

/*
		SUNRISET.C - computes Sun rise/set times, start/end of twilight, and
		the length of the day at any date and latitude
		Written as DAYLEN.C, 1989-08-16
		Modified to SUNRISET.C, 1992-12-01
		(c) Paul Schlyter, 1989, 1992
		Released to the public domain by Paul Schlyter, December 1992
	*/

/* Converted to C# by Mursaat 05-Feb-2017 */

/// <summary>
/// A function to compute the number of days elapsed since 2000 Jan 0.0
/// (which is equal to 1999 Dec 31, 0h UT)
/// </summary>
/// <param name="y"></param>
/// <param name="m"></param>
/// <param name="d"></param>
/// <returns></returns>
int _daysSince2000Jan0(int y, int m, int d) {
  return (367 * y -
      ((7 * (y + ((m + 9) ~/ 12))) ~/ 4) +
      ((275 * m) ~/ 9) +
      d -
      730530);
}

/// <summary>
/// Note: year,month,date = calendar date, 1801-2099 only.
/// Eastern longitude positive, Western longitude negative
/// Northern latitude positive, Southern latitude negative
/// The longitude value is not critical. Set it to the correct
/// The latitude however IS critical - be sure to get it correct
/// </summary>
/// <param name="year">
/// altit = the altitude which the Sun should cross
/// Set to -35/60 degrees for rise/set, -6 degrees
/// for civil, -12 degrees for nautical and -18
/// degrees for astronomical twilight.
/// </param>
/// <param name="month"></param>
/// <param name="day"></param>
/// <param name="lon"></param>
/// <param name="lat"></param>
/// <param name="altit"></param>
/// <param name="upper_limb">
/// true -> upper limb, true -> center
/// Set to true (e.g. 1) when computing day length
/// and to false when computing day+twilight length.
/// </param>
/// <returns></returns>
double dayLength(
  int year,
  int month,
  int day,
  double lon,
  double lat,
  double altit,
  bool upperLimb,
) {
  /* Compute d of 12h local mean solar time */

  // Days since 2000 Jan 0.0 (negative before)
  final d = _daysSince2000Jan0(year, month, day) + 0.5 - lon / 360.0;

  /* Compute obliquity of ecliptic (inclination of Earth's axis) */
  // Obliquity (inclination) of Earth's axis.
  final oblEcl = 23.4393 - 3.563E-7 * d;

  /* Compute Sun's ecliptic longitude and distance */
  final sun = _sunpos(d);

  /* Compute sine and cosine of Sun's declination */

  // Sine of Sun's declination.
  final sinSunDecl = sin(oblEcl) * sin(sun.longitude);

  // Cosine of Sun's declination.
  final cosSunDecl = sqrt(1.0 - sinSunDecl * sinSunDecl);

  /* Compute the Sun's apparent radius, degrees */

  // Sun's apparent radius.
  final sradius = 0.2666 / sun.distance;

  /* Do correction to upper limb, if necessary */
  if (upperLimb) {
    altit -= sradius;
  }

  /* Compute the diurnal arc that the Sun traverses to reach */
  /* the specified altitude altit: */
  final cost = (sin(altit) - sin(lat) * sinSunDecl) / (cos(lat) * cosSunDecl);

  // Diurnal arc.
  var t = 0.0;
  /* Sun always below altit */
  if (cost >= 1.0) {
    t = 0.0;
  }
  /* Sun always above altit */
  else if (cost <= -1.0) {
    t = 24.0;
  }
  /* The diurnal arc, hours */
  else {
    t = (2.0 / 15.0) * acos(cost);
  }

  return t;
}

/// <summary>
/// Computes the Sun's ecliptic longitude and distance
/// at an instant given in d, number of days since
/// 2000 Jan 0.0.  The Sun's ecliptic latitude is not
/// computed, since it's always very near 0.
/// </summary>
/// <param name="d"></param>
/// <param name="lon"></param>
/// <param name="r"></param>
_SunPos _sunpos(double julianDay) {
  /* Compute mean elements */

  // Mean anomaly of the Sun.
  final m = _revolution(356.0470 + 0.9856002585 * julianDay);

  // Mean longitude of perihelion.
  final w = 282.9404 + 4.70935E-5 * julianDay;

  // Note: Sun's mean longitude = M + w.

  // Eccentricity of Earth's orbit.
  final e = 0.016709 - 1.151E-9 * julianDay;

  /* Compute true longitude and radius vector */

  // Eccentric Anomaly
  final eccentricAnomaly = m + e * _rad2deg * sin(m) * (1.0 + e * cos(m));

  // x, y coordinates in orbit.
  final x = cos(eccentricAnomaly) - e;
  final y = sqrt(1.0 - e * e) * sin(eccentricAnomaly);
  final r = sqrt(x * x + y * y); /* Solar distance */
  final v = atan2(y, x); /* True anomaly */
  var lon = v + w; /* True solar longitude */
  while (lon >= 360.0) {
    lon -= 360.0; /* Make it 0..360 degrees */
  }

  return _SunPos(lon, r);
}

class _SunPos {
  const _SunPos(this.longitude, this.distance);

  /// True Solar Longitude.
  final double longitude;
  final double distance;
}

/// Computes the Sun's equatorial coordinates RA, Decl
/// and also its distance, at an instant given in d,
/// the number of days since 2000 Jan 0.0.
_RaDec _sunRightADec(double d) {
  /* Compute Sun's ecliptical coordinates */
  final sp = _sunpos(d);

  /* Compute ecliptic rectangular coordinates (z=0) */
  final x = sp.distance * cos(sp.longitude);
  var y = sp.distance * sin(sp.longitude);

  /* Compute obliquity of ecliptic (inclination of Earth's axis) */
  final oblEcl = 23.4393 - 3.563E-7 * d;

  /* Convert to equatorial rectangular coordinates - x is unchanged */
  final z = y * sin(oblEcl);
  y = y * cos(oblEcl);

  /* Convert to spherical coordinates */
  final ra = atan2(y, x);
  final dec = atan2(z, sqrt(x * x + y * y));

  return _RaDec(ra, dec, sp.distance);
}

class _RaDec {
  const _RaDec(this.rightAscencation, this.declination, this.distance);

  final double rightAscencation;
  final double declination;

  /// Solar distance, astronomical units.
  final double distance;
}

const double _inv360 = 1.0 / 360.0;

/// This function reduces any angle to within the first revolution
/// by subtracting or adding even multiples of 360.0 until the
/// result is >= 0.0 and < 360.0
double _revolution(double x) {
  return (x - 360.0 * (x * _inv360).floor());
}

/// Reduce angle to within +180..+180 degrees
double _rev180(double x) {
  return (x - 360.0 * (x * _inv360 + 0.5).floor());
}

/// <summary>
/// This function computes GMST0, the Greenwich Mean Sidereal Time
/// at 0h UT (i.e. the sidereal time at the Greenwhich meridian at
/// 0h UT).  GMST is then the sidereal time at Greenwich at any
/// time of the day.  I've generalized GMST0 as well, and define it
/// as:  GMST0 = GMST - UT  --  this allows GMST0 to be computed at
/// other times than 0h UT as well.
///
/// While this sounds somewhat contradictory, it is very practical:
/// instead of computing  GMST like:
/// GMST = (GMST0) + UT * (366.2422/365.2422)
/// where (GMST0) is the GMST last time UT was 0 hours, one simply
/// computes: GMST = GMST0 + UT
/// where GMST0 is the GMST "at 0h UT" but at the current moment!
///
/// Defined in this way, GMST0 will increase with about 4 min a
/// day.  It also happens that GMST0 (in degrees, 1 hr = 15 degr)
/// is equal to the Sun's mean longitude plus/minus 180 degrees!
/// (if we neglect aberration, which amounts to 20 seconds of arc
/// or 1.33 seconds of time)
/// </summary>
/// <param name="d"></param>
/// <returns></returns>
/// Private.
double _gmst0(double d) {
  double sidtim0;
  /* Sidtime at 0h UT = L (Sun's mean longitude) + 180.0 degr  */
  /* L = M + w, as defined in sunpos().  Since I'm too lazy to */
  /* add these numbers, I'll let the C compiler do it for me.  */
  /* Any decent C compiler will add the constants at compile   */
  /* time, imposing no runtime or code overhead.               */
  sidtim0 = _revolution(
      (180.0 + 356.0470 + 282.9404) + (0.9856002585 + 4.70935E-5) * d);
  return sidtim0;
}

/* Some conversion factors between radians and degrees */
const double _rad2deg = 180.0 / pi;
