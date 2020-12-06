import 'dart:io';

import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class GoogleMapsApi {
  String apiKey = 'AIzaSyB3FgPyKl9zhgPS5fBRlYE1b-SSFkOvcns';

  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyB3FgPyKl9zhgPS5fBRlYE1b-SSFkOvcns');

  Future<String> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      //Choose what ever you want from prediction
      print(address);
      print(address[0].addressLine);
      print(p.description);
      print(lat);
      print(lng);

      return address[0].addressLine;
    }
  }

  Future<List<CardHome>> getNearbyPlaces(List<CardHome> posts) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    posts.sort((a, b) {
      var currentPosts = [a, b];
      var currentAddress = [];
      currentPosts.forEach((post) {
        currentAddress.add(Coordinates(post.longitude, post.latitude));
      });
      double distanceA = Geolocator.distanceBetween(
          position.latitude,
          currentAddress[0].latitude,
          position.longitude,
          currentAddress[0].longitude);
      double distanceB = Geolocator.distanceBetween(
          position.latitude,
          currentAddress[1].latitude,
          position.longitude,
          currentAddress[1].longitude);
      return distanceA.round().compareTo(distanceB.round());
    });
    return posts;
  }

  Future<PlacesSearchResponse> getLatitudeAndLongitude(String location) async {
    return await _places.searchByText(location);
  }
}
