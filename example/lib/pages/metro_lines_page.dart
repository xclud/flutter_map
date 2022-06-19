import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MetroLinesPage extends StatefulWidget {
  const MetroLinesPage({Key? key}) : super(key: key);

  @override
  MetroLinesPageState createState() => MetroLinesPageState();
}

class MetroLinesPageState extends State<MetroLinesPage> {
  final controller = MapController(
    location: LatLng(35.68, 51.41),
    zoom: 11,
  );

  final stations = <MetroStation>[];

  @override
  void initState() {
    var all = _lines.expand((element) => element.stations).toSet();
    stations.addAll(all);
    super.initState();
  }

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
        title: const Text('Tehran Metro'),
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
                  ...stations
                      .map(
                        (e) =>
                            _buildStationMarker(e, Colors.black, transformer),
                      )
                      .toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildStationMarker(
    MetroStation station,
    Color color,
    MapTransformer transformer, {
    IconData icon = Icons.home,
  }) {
    var pos = transformer.fromLatLngToXYCoords(station.position);

    return Positioned(
      left: pos.dx - 12,
      top: pos.dy - 12,
      width: 24,
      height: 24,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('Station: ${station.name}'),
            ),
          );
        },
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

        var dash = line.stations[i].underConstruction ||
            line.stations[i + 1].underConstruction;

        if (dash) {
          var dir = (p2 - p1);

          var dist = dir.distance;
          var dirn = dir / dist;

          var count = (dist / 16).ceil();
          var step = dist / count;

          for (int i = 0; i < count; i++) {
            var c = p1 + dirn * (step * i.toDouble());
            canvas.drawCircle(c, 3, paint);
          }
        } else {
          canvas.drawLine(p1, p2, paint);
        }
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
final _eastTerminal = MetroStation(
  name: 'East Terminal',
  position: LatLng(35.722140812136395, 51.59488314170198),
);

final _pardis8 = MetroStation(
  name: 'Pardis 8',
  position: LatLng(35.71944722507747, 51.76299576172402),
  underConstruction: true,
);

final _pardis3 = MetroStation(
  name: 'Pardis 3',
  position: LatLng(35.743169432210856, 51.83866319852903),
  underConstruction: true,
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
final _mirzaShirazi = MetroStation(
  name: 'Mirza Shirazi',
  position: LatLng(35.7281496587392, 51.41725741970027),
);
final _jahad = MetroStation(
  name: 'Jahad',
  position: LatLng(35.720576180728536, 51.40823450435068),
);
final _valiasr = MetroStation(
  name: 'Valiasr Sq.',
  position: LatLng(35.712031856801616, 51.407856246768034),
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
  _haftTir,
  _darvazehDowlat,
  _toopkhaneh,
  _mohamadieh,
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
  _farhangsara,
  _eastTerminal,
  _pardis8,
  _pardis3,
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
  underConstruction: true,
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
  _mirzaShirazi,
  _jahad,
  _valiasr,
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
final _suleqan = MetroStation(
  name: 'Suleqan',
  position: LatLng(35.780236, 51.264058),
  underConstruction: true,
);
final _abshenasan = MetroStation(
  name: 'Ab Shenasan',
  position: LatLng(35.76258472722211, 51.28957651612672),
  underConstruction: true,
);

final _shahran = MetroStation(
  name: 'Shahran',
  position: LatLng(35.752417, 51.288610),
);
final _shahrZiba = MetroStation(
  name: 'Shahr Ziba',
  position: LatLng(35.74570658113588, 51.29470367520848),
);
final _kashani = MetroStation(
  name: 'Kashani',
  position: LatLng(35.74105432499717, 51.30252291344615),
);
final _sattari = MetroStation(
  name: 'Sattari',
  position: LatLng(35.73689729029617, 51.319949826510474),
);

final _ashrafi = MetroStation(
  name: 'Ashrafi',
  position: LatLng(35.73646907308664, 51.33018449519758),
);
final _yadegar = MetroStation(
  name: 'Yadegar',
  position: LatLng(35.735010085689325, 51.346161782586876),
);
final _marzdaran = MetroStation(
  name: 'Marzdaran',
  position: LatLng(35.73458463070642, 51.35946179268246),
);
final _azmayesh = MetroStation(
  name: 'Azmayesh',
  position: LatLng(35.73157074370065, 51.37143732702147),
);

final _tarbiatModaresUniversity = MetroStation(
  name: 'Tarbiat Modares University',
  position: LatLng(35.72424349366254, 51.38126984903476),
);

final _kargar = MetroStation(
  name: 'Kargar',
  position: LatLng(35.71471307905838, 51.38952461610402),
);

final _lalehPark = MetroStation(
  name: 'Laleh Park',
  position: LatLng(35.71333682376672, 51.395465331203326),
  underConstruction: true,
);
final _nejatollahi = MetroStation(
  name: 'Nejatollahi',
  position: LatLng(35.715388315039576, 51.41461470239434),
);

final _haftTir = MetroStation(
  name: 'Haft Tir',
  position: LatLng(35.71524379966379, 51.426299231471965),
);

final _baharShiraz = MetroStation(
  name: 'Bahar Shiraz',
  position: LatLng(35.71530115570266, 51.43897237567691),
);

final _sarbaz = MetroStation(
  name: 'Sarbaz',
  position: LatLng(35.71081625291094, 51.44421054165743),
  underConstruction: true,
);

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
  _suleqan,
  _abshenasan,
  _shahran,
  _shahrZiba,
  _kashani,
  _sattari,
  _ashrafi,
  _yadegar,
  _marzdaran,
  _azmayesh,
  _tarbiatModaresUniversity,
  _kargar,
  _lalehPark,
  _valiasr,
  _nejatollahi,
  _haftTir,
  _baharShiraz,
  _sarbaz,
  _emamHossein,
  _shohada,
  _besat,
  _dowlatAbad,
]);
final _mohamadieh = MetroStation(
  name: 'Mohamadieh',
  position: LatLng(35.66814530509415, 51.41598286133743),
);

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
  _mohamadieh,
  _mahdieh,
  _helalAhmar,
  _beryanak,
  _komeyl,
  _roodaki,
  _navab,
  _tohid,
  _tarbiatModaresUniversity,
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
    this.underConstruction = false,
  });

  final String name;
  final LatLng position;
  final bool underConstruction;
}
