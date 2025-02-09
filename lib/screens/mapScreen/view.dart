// Code using tom tom map api and routing api without searching feature

// ignore_for_file: prefer_const_constructors

import 'package:stock_management/headers.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MapView());
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapController _controller = MapController();

  var points = <LatLng>[];
  @override
  void initState() {
    super.initState();
  }

  /// [distance] the distance between two coordinates [from] and [to]
  num distance = 0.0;

  /// [duration] the duration between two coordinates [from] and [to]
  num duration = 0.0;

  /// [getRoute] get the route between two coordinates [from] and [to]
  Future<void> getRoute() async {
    final url =
        'https://api.tomtom.com/routing/1/calculateRoute/${Texts.from.latitude},${Texts.from.longitude}:${Texts.to.latitude},${Texts.to.longitude}/json?key=${Texts.apiKey}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final route = data['routes'][0];
        List<dynamic> routing = data['routes'][0]['legs'][0]['points'];
        distance = route['summary']['lengthInMeters']; // in meters
        duration = route['summary']['travelTimeInSeconds']; // in seconds
        points = routing
            .map((point) => LatLng(point['latitude'], point['longitude']))
            .toList();

        setState(() {}); // Update UI with new route
      } else {
        debugPrint(
            "Error occurred during finding route: ${response.statusCode}");
        debugPrint(response.body);
      }
    } catch (e) {
      debugPrint("Error occurred during finding route: $e");
    }
  }

  // Monitor user location to trigger pop-up when arriving at the destination
  void _monitorUserLocation() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10 // Update every 10 meters
          ),
    ).listen((Position position) {
      if (position != null) {
        LatLng userLocation = LatLng(position.latitude, position.longitude);
        double distanceToDestination = Distance().as(
          LengthUnit.Meter,
          LatLng(Texts.from.latitude, Texts.from.longitude),
          userLocation,
        );
        // If user is close to the destination, show pop-up
        if (distanceToDestination < 100) {
          _showArrivalPopup();
        }
      }
    });
  }

  // Function to show pop-up when arriving at the destination
  void _showArrivalPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Arrived at Destination'),
          content: Text('You have arrived at your destination.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _changeCameraPosition(LatLng newPosition, double bearing) {
    if (_controller != null) {
      _controller.move(newPosition, 15.0); // Zoom level can be adjusted
      _controller.rotate(bearing);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            mapSection(),
            Align(
              alignment: Alignment.topRight,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: const EdgeInsets.all(20),
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Show estimated arrival time
                      Text(
                        'Estimated Arrival: ${(DateTime.now().add(Duration(minutes: duration.toInt()))).toString()}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Show distance and duration
                      Text(
                        'Distance: ${(distance / 1000).toStringAsFixed(2)} km',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Duration: ${(duration / 60 / 60).toStringAsFixed(2)} hours',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Button to refresh route
                      ElevatedButton(
                        onPressed: () {
                          getRoute();
                        },
                        child: Text('Refresh Route'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  searchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.black),
            const SizedBox(width: 10.0),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  mapSection() {
    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: LatLng(Texts.from.latitude, Texts.from.longitude),
        maxZoom: 13.0, // Adjust zoom level as needed
      ),
      children: [
        RichAttributionWidget(
          animationConfig: const ScaleRAWA(), // Or `FadeRAWA` as is default
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),

            /// @mohamadlounnas
            TextSourceAttribution(
              'Kausar Fatima',
              onTap: () =>
                  launchUrl(Uri.parse('mailto:kausarfatima1044@gmail.com')),
            ),
          ],
        ),
        TileLayer(
          urlTemplate:
              'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=${Texts.apiKey}',
          additionalOptions: {
            'apiKey': Texts.apiKey,
            'lang': 'en', // Set language if needed
          },
        ),
        // For accessing user current location
        // CurrentLocationLayer(
        //   alignPositionOnUpdate: AlignOnUpdate.always,
        //   alignDirectionOnUpdate: AlignOnUpdate.never,
        //   style: LocationMarkerStyle(
        //     marker: const DefaultLocationMarker(
        //       child: Icon(
        //         Icons.navigation,
        //         color: Colors.white,
        //       ),
        //     ),
        //     markerSize: const Size(40, 40),
        //     markerDirection: MarkerDirection.heading,
        //   ),
        // ),

        /// [PolylineLayer] draw the route between two coordinates [from] and [to]
        PolylineLayer(
          polylines: [
            Polyline(
                points: points,
                strokeWidth: 3.5,
                color: polylineColor,
                isDotted: true),
          ],
        ),

        /// [MarkerLayer] draw the marker on the map
        MarkerLayer(
          markers: [
            Marker(
                point: LatLng(Texts.from.latitude, Texts.from.longitude),
                child: InkWell(
                  onTap: () {
                    _changeCameraPosition(
                        LatLng(Texts.from.latitude, Texts.from.longitude), 5.0);
                  },
                  child: Icon(
                    Icons.location_on_sharp,
                    color: polylineColor,
                  ),
                )),
            Marker(
                point: LatLng(40.7148, -74.0055),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      Texts.to = LatLng(40.7148, -74.0055);
                      getRoute();
                    });
                  },
                  child: Icon(
                    Icons.location_on_sharp,
                    color: mapColor,
                  ),
                )),
            Marker(
              point: LatLng(40.7158, -74.0060),
              child: InkWell(
                onTap: () {
                  setState(() {
                    Texts.to = LatLng(40.7158, -74.0060);
                    getRoute();
                  });
                },
                child: Icon(
                  Icons.location_on_sharp,
                  color: mapColor,
                ),
              ),
            ),
            Marker(
              point: LatLng(40.7258, -74.0160),
              child: InkWell(
                onTap: () {
                  setState(() {
                    Texts.to = LatLng(40.7258, -74.0160);
                    getRoute();
                  });
                },
                child: Icon(
                  Icons.location_on_sharp,
                  color: mapColor,
                ),
              ),
            ),
            Marker(
              point: LatLng(40.7458, -74.0360),
              child: InkWell(
                onTap: () {
                  setState(() {
                    Texts.to = LatLng(40.7458, -74.0360);
                    getRoute();
                  });
                },
                child: Icon(
                  Icons.location_on_sharp,
                  color: mapColor,
                ),
              ),
            ),
            Marker(
              point: LatLng(40.7550, -74.0468),
              child: InkWell(
                onTap: () {
                  setState(() {
                    Texts.to = LatLng(40.7550, -74.0468);
                    getRoute();
                  });
                },
                child: Icon(
                  Icons.location_on_sharp,
                  color: mapColor,
                ),
              ),
            ),
          ],
        ),

        // copy right text
      ],
    );
  }
}
