import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MetroLinesPage extends StatefulWidget {
  @override
  _MetroLinesPageState createState() => _MetroLinesPageState();
}

class _MetroLinesPageState extends State<MetroLinesPage> {
  final controller = MapController(
    location: LatLng(35.68, 51.41),
    zoom: 11,
  );

  void _gotoDefault() {
    controller.center = LatLng(35.68, 51.41);
    setState(() {});
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tehran Metro'),
      ),
      body: MapLayoutBuilder(
        controller: controller,
        builder: (context, transformer) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta;

                  controller.zoom -= delta.dy / 1000.0;
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  Map(
                    controller: controller,
                    builder: (context, x, y, z) {
                      //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
                      //Google Maps
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  CustomPaint(
                    painter: PolylinePainter(transformer),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: Icon(Icons.my_location),
      ),
    );
  }
}

class PolylinePainter extends CustomPainter {
  PolylinePainter(this.transformer);

  final MapTransformer transformer;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 4;

    for (var line in _lines) {
      paint.color = line.color;

      for (int i = 0; i < line.stations.length - 1; i++) {
        var p1 = transformer.fromLatLngToXYCoords(line.stations[i].position);
        var p2 =
            transformer.fromLatLngToXYCoords(line.stations[i + 1].position);

        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(PolylinePainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(PolylinePainter oldDelegate) => false;
}

final _aryashahr = MetroStation(
  name: 'Arya Shahr',
  position: LatLng(35.71757937340565, 51.330969328113085),
);

final _tarasht = MetroStation(
  name: 'Tarasht',
  position: LatLng(35.71622385160099, 51.34340074353702),
);

final _sharifUniversity = MetroStation(
  name: 'Sharif University',
  position: LatLng(35.705823580454656, 51.353618416990045),
);

final _shademan = MetroStation(
  name: 'Shademan Street',
  position: LatLng(35.70062850581121, 51.36367669313273),
);

final _navab = MetroStation(
  name: 'Navab',
  position: LatLng(35.694488236784835, 51.37924806014357),
);

final _hor = MetroStation(
  name: 'Hor',
  position: LatLng(35.69100301426342, 51.38843201173324),
);

final _emamAli = MetroStation(
  name: 'Emam Ali University',
  position: LatLng(35.68724055807456, 51.399367325687905),
);

final _hasanAbad = MetroStation(
  name: 'Hasan Abad',
  position: LatLng(35.68655399193537, 51.41001912596496),
);

final _toopkhaneh = MetroStation(
  name: 'Toopkhaneh',
  position: LatLng(35.68551852849885, 51.41997232631562),
);

final _mellat = MetroStation(
  name: 'Mellat',
  position: LatLng(35.68864898375998, 51.426800270768936),
);

final _baharestan = MetroStation(
  name: 'Baharestan',
  position: LatLng(35.69192672557228, 51.43280904141429),
);
final _shemiran = MetroStation(
  name: 'Shemiran',
  position: LatLng(35.69909850226239, 51.43772481540947),
);

final _emamHossein = MetroStation(
  name: 'Emam Hossein',
  position: LatLng(35.70217888885868, 51.44564502671469),
);

final _madani = MetroStation(
  name: 'Madani',
  position: LatLng(35.709210342581805, 51.45336520872064),
);

final _sabalan = MetroStation(
  name: 'Sabalan',
  position: LatLng(35.71820650723393, 51.46465956495724),
);

final _fadak = MetroStation(
  name: 'Fadak',
  position: LatLng(35.72649785014192, 51.47591927983872),
);

final _golbarg = MetroStation(
  name: 'Golbarg',
  position: LatLng(35.73349925482848, 51.48457964845982),
);

final _sarsabz = MetroStation(
  name: 'Sarsabz',
  position: LatLng(35.73537402841984, 51.49490066392291),
);

final _scienceIndustryUniversity = MetroStation(
  name: 'Science & Industry University',
  position: LatLng(35.73470025614792, 51.504932905858375),
);

final _bagheri = MetroStation(
  name: 'Bagheri',
  position: LatLng(35.733206036178046, 51.516336540855036),
);

final _tehranPars = MetroStation(
  name: 'Tehran Pars',
  position: LatLng(35.73103838268802, 51.53163754759502),
);

final _farhangsara = MetroStation(
  name: 'Farhang Sara',
  position: LatLng(35.72971980408225, 51.54679410705018),
);

final _tajrish = MetroStation(
  name: 'Tajrish',
  position: LatLng(35.80474825918548, 51.43340567819161),
);

final _mirdamad = MetroStation(
  name: 'Mirdamad',
  position: LatLng(35.760127715849805, 51.43368520770052),
);

final _ghodousi = MetroStation(
  name: 'Ghodousi',
  position: LatLng(35.73168390837565, 51.44444505496505),
);
final _sohrevardi = MetroStation(
  name: 'Sohrevardi',
  position: LatLng(35.7311540404063, 51.436853575198434),
);

final _sayadShirazi = MetroStation(
  name: 'Sayad Shirazi',
  position: LatLng(35.73537356380443, 51.45854599108719),
);
final _beheshti = MetroStation(
  name: 'Beheshti',
  position: LatLng(35.731010038875134, 51.42708577388299),
);

final _kahrizak = MetroStation(
  name: 'Kahrizak',
  position: LatLng(35.5216056666344, 51.369240674773046),
);

final _ika = MetroStation(
  name: 'IK Airport',
  position: LatLng(35.40689907803021, 51.154232813746496),
);

final _line1 = MetroLine(name: 'Line 1', color: Colors.red, stations: [
  _tajrish,
  _mirdamad,
  _beheshti,
  _darvazehDowlat,
  _toopkhaneh,
  _kahrizak,
  _ika,
]);

final _line2 = MetroLine(name: 'Line 2', color: Colors.indigo, stations: [
  _aryashahr,
  _tarasht,
  _sharifUniversity,
  _shademan,
  _navab,
  _hor,
  _emamAli,
  _hasanAbad,
  _toopkhaneh,
  _mellat,
  _baharestan,
  _shemiran,
  _emamHossein,
  _madani,
  _sabalan,
  _fadak,
  _golbarg,
  _sarsabz,
  _scienceIndustryUniversity,
  _bagheri,
  _tehranPars,
  _farhangsara
]);

final _eramSabz = MetroStation(
  name: 'Eram Sabz',
  position: LatLng(35.71782508745886, 51.301667772837206),
);

final _chitgar = MetroStation(
  name: 'Chigtar',
  position: LatLng(35.717188213170736, 51.243402358378106),
);

final _golshahr = MetroStation(
  name: 'Golshahr',
  position: LatLng(35.824928112047054, 50.932998060499195),
);

final _hashtgerd = MetroStation(
  name: 'Hashtgerd',
  position: LatLng(35.961747, 50.684678),
);

final _ghaem = MetroStation(
  name: 'Ghaem',
  position: LatLng(35.79879019586637, 51.52094117060687),
);
final _mahalati = MetroStation(
  name: 'Mahalati',
  position: LatLng(35.797967290661774, 51.50817332062084),
);
final _nobonyad = MetroStation(
  name: 'No Bonyad',
  position: LatLng(35.790718958697056, 51.47865338565981),
);
final _hosseinAbad = MetroStation(
  name: 'Hossein Abad',
  position: LatLng(35.77894788853776, 51.478721520954345),
);
final _heravi = MetroStation(
  name: 'Heravi',
  position: LatLng(35.772038351385085, 51.47313752766146),
);

final _zeiodin = MetroStation(
  name: 'Zeinodin',
  position: LatLng(35.76065187124504, 51.46536889194252),
);

final _azadegan = MetroStation(
  name: 'Azadegan',
  position: LatLng(35.627295270680015, 51.335528759926504),
);

final _line3 = MetroLine(name: 'Line 3', color: Colors.blue, stations: [
  _ghaem,
  _mahalati,
  _nobonyad,
  _hosseinAbad,
  _heravi,
  _zeiodin,
  _sayadShirazi,
  _ghodousi,
  _sohrevardi,
  _beheshti,
  _theatre,
  _mahdieh,
  _azadegan,
]);

final _enghelab = MetroStation(
  name: 'Enghelab',
  position: LatLng(35.70122975656138, 51.389943847765274),
);

final _theatre = MetroStation(
  name: 'Theatre',
  position: LatLng(35.700975031749934, 51.40537467899397),
);

final _darvazehDowlat = MetroStation(
  name: 'Darvazeh Dowlat',
  position: LatLng(35.70170631117268, 51.42565980252712),
);

final _kolahdooz = MetroStation(
  name: 'Kolahdooz',
  position: LatLng(35.69873171497634, 51.50028547590922),
);

final _ekbatan = MetroStation(
  name: 'Ekbatan',
  position: LatLng(35.70560465501403, 51.30772942274484),
);

final _bimeh = MetroStation(
  name: 'Bimeh',
  position: LatLng(35.69967513438331, 51.320199419396154),
);

final _line4 =
    MetroLine(name: 'Line 4', color: Colors.orange.shade300, stations: [
  _kolahdooz,
  _shohada,
  _shemiran,
  _darvazehDowlat,
  //_ferdowsi,
  _theatre,
  _enghelab,
  _tohid,
  _shademan,
  _bimeh,
  _ekbatan,
  _eramSabz,
]);

final _line5 =
    MetroLine(name: 'Line 5', color: Colors.green.shade900, stations: [
  _aryashahr,
  _eramSabz,
  _chitgar,
  _golshahr,
  _hashtgerd,
]);

final _shohada = MetroStation(
  name: 'Shohada',
  position: LatLng(35.6904366612891, 51.44759134684435),
);

final _besat = MetroStation(
  name: 'Besat',
  position: LatLng(35.644725311376625, 51.444266434717186),
);

final _dowlatAbad = MetroStation(
  name: 'Dowlat Abad',
  position: LatLng(35.61897971493006, 51.464688221944336),
);

final _line6 =
    MetroLine(name: 'Line 6', color: Colors.pink.shade300, stations: [
  _shohada,
  _besat,
  _dowlatAbad,
]);

final _mahdieh = MetroStation(
  name: 'Mahdieh',
  position: LatLng(35.66684138182278, 51.39955168977791),
);

final _helalAhmar = MetroStation(
  name: 'Helal Ahmar',
  position: LatLng(35.66792345748616, 51.38744705070702),
);

final _beryanak = MetroStation(
  name: 'Beryanak',
  position: LatLng(35.673168433742745, 51.38083683673324),
);

final _komeyl = MetroStation(
  name: 'Komeyl',
  position: LatLng(35.68052015353838, 51.37986931629428),
);

final _roodaki = MetroStation(
  name: 'Roodaki',
  position: LatLng(35.68764013618165, 51.37909161479496),
);

final _tohid = MetroStation(
  name: 'Tohid',
  position: LatLng(35.70086534232278, 51.378560581238574),
);

final _sanat = MetroStation(
  name: 'Sanat Sq.',
  position: LatLng(35.754566356068814, 51.367483715989),
);

final _line7 = MetroLine(name: 'Line 7', color: Colors.deepPurple, stations: [
  _mahdieh,
  _helalAhmar,
  _beryanak,
  _komeyl,
  _roodaki,
  _navab,
  _tohid,
  _sanat,
]);

final _lines = [_line1, _line2, _line3, _line4, _line5, _line6, _line7];

class MetroLine {
  MetroLine({
    required this.name,
    required this.color,
    required this.stations,
  });

  final String name;
  final Color color;
  final List<MetroStation> stations;
}

class MetroStation {
  MetroStation({
    required this.name,
    required this.position,
  });

  final String name;
  final LatLng position;
}
