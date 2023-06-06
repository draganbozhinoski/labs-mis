import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lab3/model/exam.dart';

import 'package:latlong2/latlong.dart';

import '../services/notification_service.dart';

class MapWidget extends StatefulWidget {
  final List<Exam> exams;
  const MapWidget({Key? key,required this.exams}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final cron = Cron();
  static int increment = 0;
  // static int mapTest = 0;
  late final LocalNotificationService service;
  List<Marker> markers = [];
  @override
  void initState() {
    startCron();
    service = LocalNotificationService();
    service.intialize();

    for(var exam in widget.exams) {
      markers.add(Marker(width:30,height:30,point: LatLng(exam.latitude,exam.longitude), builder: (ctx) => const Icon(
        Icons.location_on,
        color: Colors.blueAccent,
        size: 40,
      )));
      // mapTest++;
      // print(markers);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
      ),
      body: Container(
        child: FlutterMap(
          options: MapOptions(center: LatLng(42.006821, 20.973867), zoom: 13.0),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(markers: markers),
          ],
        ),
      ),
    );
  }

  Future<Position> getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  void startCron() async {
    cron.schedule(Schedule.parse("0 * * * *"), () => checkLocation());
  }

  checkLocation() async {
    Position position = await getLocation();
    if ((position.latitude - 42).abs() <= 5 &&
        (position.longitude - 20.9).abs() <= 5) {
      await service.showNotification(
          id: increment++,
          title: 'Exams',
          body: 'There are new exams in your area, check out the calendar and map!');
    }
  }
}
