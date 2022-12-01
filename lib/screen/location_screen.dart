import 'dart:async';

import 'package:attendance_flutter/api/clock_service.dart';
import 'package:attendance_flutter/notifier/auth_notifier.dart';
import 'package:attendance_flutter/util/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../model/school.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LocationScreen();
}

class _LocationScreen extends State<LocationScreen> {
  var _isLoadingLocation = false;
  var _isLoadingSubmit = false;

  final List<Marker> _markers = [];
  LatLng? _currentLocation;
  final MapController _controller = MapController();

  String _timeString = "--:--";
  String _dateString = "--/--/----";

  @override
  void initState() {
    super.initState();
    _loadLocation();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = _formatTime(now);
      _dateString = _formatDate(now);
    });
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Presensi",
          style: GoogleFonts.inter(),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Consumer<AuthNotifier>(
                      builder: (context, notifier, child) {
                        if (notifier.user == null) {
                          return Container(
                            color: Colors.grey[100],
                            alignment: Alignment.center,
                            child: const Text("Tidak ada koneksi internet"),
                          );
                        }
                        final School? school = notifier.user!.school;
                        final schoolLocation = LatLng(
                          school?.lat ?? 0,
                          school?.lng ?? 0,
                        );
                        return FlutterMap(
                          mapController: _controller,
                          options: MapOptions(center: schoolLocation, zoom: 18),
                          nonRotatedChildren: [
                            AttributionWidget.defaultWidget(
                              source: 'OpenStreetMap contributors',
                              onSourceTapped: null,
                            ),
                          ],
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            CircleLayer(
                              circles: [
                                CircleMarker(
                                  point: schoolLocation,
                                  radius: school?.distance?.toDouble() ?? 50,
                                  color: const Color(0x5500FF00),
                                  borderColor: const Color(0xFF00FF00),
                                  borderStrokeWidth: 2,
                                  useRadiusInMeter: true,
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: _markers,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  _timeString,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff17233D)),
                ),
                const SizedBox(height: 5),
                Text(
                  _dateString,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff17233D)),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton(
              onPressed: _isLoadingLocation || _currentLocation == null
                  ? null
                  : () {
                      setState(() {
                        _isLoadingLocation = true;
                      });
                      _loadLocation();
                    },
              child: _isLoadingLocation || _currentLocation == null
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      'Update Lokasi',
                      style: GoogleFonts.inter(),
                    ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoadingSubmit || _currentLocation == null
                        ? null
                        : () {
                            setState(() {
                              _isLoadingSubmit = true;
                            });
                            if (_currentLocation == null) {
                              displayMessageDialog(
                                  context, "Lokasi tidak ditemukan.");
                            } else {
                              clockNow(
                                context.read<AuthNotifier>().accessToken ?? "",
                                clockInType,
                                _currentLocation!.latitude,
                                _currentLocation!.longitude,
                              ).then(
                                (value) {
                                  if (value.isSuccess()) {
                                    displayMessageDialog(
                                      context,
                                      value.getSuccess() ?? "",
                                      () {
                                        Navigator.popUntil(
                                          context,
                                          (route) => route.isFirst,
                                        );
                                        Provider.of<AuthNotifier>(context,
                                                listen: false)
                                            .loadClockStatus();
                                      },
                                    );
                                  } else {
                                    displayMessageDialog(
                                        context, value.getError() ?? "");
                                  }
                                  setState(
                                    () {
                                      _isLoadingSubmit = false;
                                    },
                                  );
                                },
                              );
                            }
                          },
                    child: _isLoadingSubmit || _currentLocation == null
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Masuk",
                            style: GoogleFonts.inter(),
                          ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoadingSubmit || _currentLocation == null
                        ? null
                        : () {
                            setState(() {
                              _isLoadingSubmit = true;
                            });
                            if (_currentLocation == null) {
                              displayMessageDialog(
                                  context, "Lokasi tidak ditemukan.");
                            } else {
                              clockNow(
                                context.read<AuthNotifier>().accessToken ?? "",
                                clockOutType,
                                _currentLocation!.latitude,
                                _currentLocation!.longitude,
                              ).then(
                                (value) {
                                  if (value.isSuccess()) {
                                    displayMessageDialog(
                                      context,
                                      value.getSuccess() ?? "",
                                      () {
                                        Navigator.popUntil(
                                          context,
                                          (route) => route.isFirst,
                                        );
                                        Provider.of<AuthNotifier>(context,
                                                listen: false)
                                            .loadClockStatus();
                                      },
                                    );
                                  } else {
                                    displayMessageDialog(
                                        context, value.getError() ?? "");
                                  }
                                  setState(
                                    () {
                                      _isLoadingSubmit = false;
                                    },
                                  );
                                },
                              );
                            }
                          },
                    child: _isLoadingSubmit || _currentLocation == null
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Pulang",
                            style: GoogleFonts.inter(),
                          ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _loadLocation() {
    _determinePosition().then((value) {
      setState(() {
        _isLoadingLocation = false;
        _currentLocation = LatLng(value.latitude, value.longitude);
        if (_markers.isEmpty) {
          _markers.add(Marker(
            point: _currentLocation!,
            width: 100,
            height: 100,
            builder: (context) => const Icon(Icons.person_pin_circle),
          ));
        } else {
          _markers[0] = Marker(
            point: _currentLocation!,
            width: 100,
            height: 100,
            builder: (context) => const Icon(Icons.person_pin_circle),
          );
        }
        _controller.move(_currentLocation!, 18);
      });
    }).catchError((err) {
      setState(() {
        _isLoadingLocation = false;
      });
      displayDialog(context, err.toString());
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
