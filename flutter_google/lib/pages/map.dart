import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';




class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final database = Firestore.instance;

  GoogleMapController mapController;
  LatLng latlong = null;
  CameraPosition _cameraPosition;
  String sNear = "";
  bool _ATMselected = false;
  bool _Docselected = false;
  bool _Hopselected = false;
  bool _Polselected = false;
  bool _Gasselected = false;
  bool _Libselected = false;
  double curLat = 0.0;
  double curLong = 0.0;

  GoogleMapController myController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> nearGoogleMarkers = <MarkerId, Marker>{};



  void initMarker(specify, specifyId) async{
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify['Location'].latitude, specify['Location'].longitude),
      infoWindow: InfoWindow(title: specify['Name'], snippet: specify['Number'] )
    );
    setState(() {
      markers[markerId] = marker;
    });

  }

  getMarkerData() async{

    Firestore.instance.collection('Dallas Foodbanks').getDocuments().then((myData){
      if(myData.documents.isNotEmpty){
        for(int i = 0; i < myData.documents.length; i++){
          
          initMarker(myData.documents[i].data, myData.documents[i].documentID);

        }
      }
    });

  }
  @override
  void initState(){
    getMarkerData();
    nearGoogleMarkers = markers;
    super.initState();

    _cameraPosition = CameraPosition(target: LatLng(32.8025,-96.8351), zoom: 13);
    getCurLoc();

  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //print(await searchNear("library"));
  }

  @override
  Widget build(BuildContext context) {

    
   /* return Scaffold(
      body: GoogleMap(
        markers: Set<Marker>.of(markers.values) ,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(32.7446312,-96.8215745),
        zoom: 12,
      ),
      onMapCreated: (GoogleMapController controller){
        controller = controller;
      }


    ),
    );*/
    return Scaffold(

      body: Container(
        child: Column(
          children: [
            SearchMapPlaceWidget(
              hasClearButton: true,
              placeType: PlaceType.address,
              placeholder: "Search for locations!",
              apiKey: 'AIzaSyDwsCu2HdnFUnIs2sJOylZuAQf1UD8Uus8',
              onSelected: (Place place) async{
                Geolocation geolocation = await place.geolocation;
                LatLng newProp = geolocation.coordinates;
                curLat = newProp.latitude;
                curLong = newProp.longitude;

                mapController.animateCamera(
                    CameraUpdate.newLatLng(
                        geolocation.coordinates
                    )
                );
                mapController.animateCamera(
                    CameraUpdate.newLatLngBounds(geolocation.bounds, 0)
                );
              },
            ),
            SizedBox(
              height: 400,
              child: GoogleMap(
                markers: Set<Marker>.of(nearGoogleMarkers.values),
                mapType: MapType.normal,
                initialCameraPosition: _cameraPosition,
                onMapCreated: (GoogleMapController googleMapController){
                  setState(() {
                    mapController =  googleMapController;
                    mapController.animateCamera(
                        CameraUpdate.newCameraPosition(_cameraPosition)
                    );
                  });
                },
                myLocationEnabled: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                children: <Widget>[
                  FilterChip(
                    label: Text("Gas Station", style: TextStyle(fontSize: 25, fontFamily: 'Times')),
                    selected: _Gasselected,
                    onSelected: (bool selected) async {
                      setState(() {
                        _Gasselected = !_Gasselected;
                        getNear("Gas Station",_Gasselected);
                      });
                    },
                    selectedColor: Colors.purple,
                  ),
                  FilterChip(
                    label: Text("Doctor", style: TextStyle(fontSize: 25)),
                    selected: _Docselected,
                    onSelected: (bool selected) async {
                      setState(() {
                        _Docselected = !_Docselected;
                        getNear("Doctor", _Docselected);
                      });
                    },
                    selectedColor: Colors.green,
                  ),
                  FilterChip(
                    label: Text("Hospital", style: TextStyle(fontSize: 25)),
                    selected: _Hopselected,
                    onSelected: (bool selected) async {
                      setState(() {
                        _Hopselected = !_Hopselected;
                        getNear("Hospital",_Hopselected);
                      });
                    },
                    selectedColor: Colors.pink,
                  ),
                  FilterChip(
                    label: Text("Police", style: TextStyle(fontSize: 25)),
                    selected: _Polselected,
                    onSelected: (bool selected) async {
                      setState(() {
                        _Polselected = !_Polselected;
                        getNear("Police",_Polselected);
                      });
                    },
                    selectedColor: Colors.purpleAccent,
                  ),
                  FilterChip(
                    label: Text("ATM", style: TextStyle(fontSize: 25)),
                    selected: _ATMselected,
                    onSelected: (bool selected) async {
                      setState(() {
                        _ATMselected = !_ATMselected;
                        if(_ATMselected){
                          getNear("ATM", _ATMselected);
                        }
                        else{

                        }

                      });
                    },
                    selectedColor: Colors.cyan,
                  ),
                  FilterChip(
                    label: Text("Library", style: TextStyle(fontSize: 25)),
                    selected: _Libselected,
                    onSelected: (bool selected) async {
                      setState(() {
                        _Libselected = !_Libselected;
                        getNear("Library",_Libselected);
                      });
                    },
                    selectedColor: Colors.indigoAccent,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      // body: GoogleMap(
      //   onMapCreated: _onMapCreated,
      //   markers: _markers,
      //   initialCameraPosition: CameraPosition(
      //   target: LatLng(32.8025,-96.8351),
      //   zoom:13,
      // ),
      // ),
    );

  }

  void getNear(String search, bool isSelect) async{
    nearGoogleMarkers = markers;
    sNear = search;
    //Marker atm = await searchNear("ATM");
    //Marker doc = await searchNear("Doctor");
    //Marker hosp = await searchNear("Hospital");
    //Marker pol = await searchNear("Police");
    //Marker gas = await searchNear("Gas Station");
    //Marker lib = await searchNear("Library");

    if(search.compareTo("ATM")==0){
      if(isSelect==true){
        Marker atm = await searchNear("ATM");
        setState(() {
          var nearId = atm.markerId;
          nearGoogleMarkers[nearId] = atm;
        });
      }
    }
    else if(isSelect == true && search.compareTo("Doctor")==0){
      if(isSelect==true){
        Marker doc = await searchNear("Doctor");
        setState(() {
          var nearId = doc.markerId;
          nearGoogleMarkers[nearId] = doc;
        });
      }
    }
    else if(isSelect == true && search.compareTo("Hospital")==0){
      if(isSelect==true){
        Marker hosp = await searchNear("Hospital");
        setState(() {
          var nearId = hosp.markerId;
          nearGoogleMarkers[nearId] = hosp;
        });
      }
    }
    else if(isSelect == true && search.compareTo("Police")==0){
      if(isSelect==true){
        Marker pol = await searchNear("Police");
        setState(() {
          var nearId = pol.markerId;
          nearGoogleMarkers[nearId] = pol;
        });
      }
    }
    else if(isSelect == true && search.compareTo("Gas Station")==0) {
      if(isSelect==true){
        Marker gas = await searchNear("Gas Station");
        setState(() {
          var nearId = gas.markerId;
          nearGoogleMarkers[nearId] = gas;
        });
      }
    }
    else if(isSelect == true && search.compareTo("Library")==0){
      if(isSelect==true){
        Marker lib = await searchNear("Library");
        setState(() {
          var nearId = lib.markerId;
          nearGoogleMarkers[nearId] = lib;
        });
      }
    }
  }

  Future<Marker> searchNear(String search_location) async{
    // if(isMarker==false){
    // }
//    else{
    var sender = new Dio();
    var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double lat = curLat;
    double long = curLong;
    var parameters = {
      'key': 'AIzaSyDwsCu2HdnFUnIs2sJOylZuAQf1UD8Uus8',
      'location': '$lat, $long',
      'rankby': 'distance',
      'keyword': search_location
    };

    //implementing a marker on the map
    var response = await sender.get(url, queryParameters: parameters);
    List<String> searches_lat = response.data['results']
        .map<String>((result) => result['geometry']['location']['lat'].toString())
        .toList();
    List<String> searches_long = response.data['results']
        .map<String>((result) => result['geometry']['location']['lng'].toString())
        .toList();
    List<String> searces_name = response.data['results']
        .map<String>((result) => result['name'].toString())
        .toList();
    List<String> search_id = response.data['results']
        .map<String>((result) => result['place_id'].toString())
        .toList();



    double nearLat = double.parse(searches_lat.first);
    double nearLong = double.parse(searches_long.first);
    String nearName = searces_name.first;
    var nearId = MarkerId(search_id.first);
    Marker marker;
    if(search_location.compareTo("ATM")==0){
      marker = Marker(
          markerId: nearId,
          draggable: false,
          position: LatLng(nearLat, nearLong),
          infoWindow: InfoWindow(title: nearName, snippet: search_location),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)
      );
    }
    else if(search_location.compareTo("Doctor")==0){
      marker = Marker(
          markerId: nearId,
          draggable: false,
          position: LatLng(nearLat, nearLong),
          infoWindow: InfoWindow(title: nearName, snippet: search_location),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
      );
    }
    else if(search_location.compareTo("Hospital")==0){
      marker = Marker(
          markerId: nearId,
          draggable: false,
          position: LatLng(nearLat, nearLong),
          infoWindow: InfoWindow(title: nearName, snippet: search_location),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose)
      );
    }
    else if(search_location.compareTo("Police")==0){
      marker = Marker(
          markerId: nearId,
          draggable: false,
          position: LatLng(nearLat, nearLong),
          infoWindow: InfoWindow(title: nearName, snippet: search_location),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)
      );
    }
    else if(search_location.compareTo("Gas Station")==0){
      marker = Marker(
          markerId: nearId,
          draggable: false,
          position: LatLng(nearLat, nearLong),
          infoWindow: InfoWindow(title: nearName, snippet: search_location),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)
      );
    }
    else if(search_location.compareTo("Library")==0){
      marker = Marker(
          markerId: nearId,
          draggable: false,
          position: LatLng(nearLat, nearLong),
          infoWindow: InfoWindow(title: nearName, snippet: search_location),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
      );
    }

    print(nearGoogleMarkers);
    //}
    return marker;
  }

  Future getCurLoc() async{
    getLocation();
  }

  void getLocation() async{
    //code for requesting permission here
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    curLat = pos.latitude;
    curLong = pos.longitude;
    setState(() {
      latlong = new LatLng(pos.latitude, pos.longitude);
      _cameraPosition=CameraPosition(target:latlong,zoom: 13.0 );
      if(mapController != null){
        mapController.animateCamera(
            CameraUpdate.newCameraPosition(_cameraPosition)
        );
      }
    });
  }




}

