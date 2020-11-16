import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class GoogleMapsApi {
  String apiKey = 'AIzaSyCQarq8zgeo0ksCrI7p1m3yG-JQSpp8bUk';

  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyCQarq8zgeo0ksCrI7p1m3yG-JQSpp8bUk');

  Future<Null> displayPrediction(Prediction p) async {
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
    }
  }

  void getNearbyPlcaes(List<CardHome> posts) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    posts.sort((a, b) {
      var currentPosts = [a, b];
      var currentAddress = [];
      currentPosts.forEach((post) async {
        PlacesSearchResponse detailPost =
            await _places.searchByText(post.place);
        currentAddress.add(Coordinates(
            detailPost.results[0].geometry.location.lat,
            detailPost.results[0].geometry.location.lat));
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
  }
}
