import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MaterialApp(
    home: UserLocation(),
    debugShowCheckedModeBanner: false,
  ));
}
class UserLocation extends StatefulWidget {
  const UserLocation({Key? key}) : super(key: key);

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  String location="null ,Press Button";
  String address='Search';
  Future<Position> getGeoLocationPos()async{
    bool serviceEnabled;
    LocationPermission locationPermission;
    serviceEnabled=await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      await Geolocator.openLocationSettings();
      return Future.error("Location services are disabled");
    }
    locationPermission=await Geolocator.checkPermission();
    if(locationPermission==LocationPermission.denied){
      locationPermission=await Geolocator.requestPermission();
      if(locationPermission==LocationPermission.denied){
        return Future.error('Location permission are denied');
      }
    }
    if(locationPermission==LocationPermission.deniedForever){
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  Future<void> getAddFromLatLong(Position position)async{
   List<Placemark> placemark=await placemarkFromCoordinates(position.latitude, position.longitude);
   print(placemark);
   Placemark place=placemark[0];
   address='${place.street},${place.subLocality},${place.locality},${place.postalCode},${place.country}';
   setState(() {
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('User Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Coordinates Points',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Text(location,style: const TextStyle(color: Colors.blue,fontSize: 20)),
            const SizedBox(height: 30),
            const Text('ADDRESS',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20),
            Text(address,style: const TextStyle(color: Colors.blue,fontSize: 20)),
            const SizedBox(height: 30),
            OutlinedButton(onPressed: ()async{
              Position position=await getGeoLocationPos();
              location='Lat : ${position.latitude} , Long : ${position.longitude}';
              getAddFromLatLong(position);
            }, child: const Text('Get Location'),
            style: OutlinedButton.styleFrom(
              backgroundColor:Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              padding: const EdgeInsets.all(15),
              primary: Colors.white
            )),
          ],
        ),
      ),
    );
  }
}

