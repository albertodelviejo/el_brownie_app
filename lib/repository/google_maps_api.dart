import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';

class GoogleMapsApi {

  String apiKey = 'AIzaSyCQarq8zgeo0ksCrI7p1m3yG-JQSpp8bUk';

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyCQarq8zgeo0ksCrI7p1m3yG-JQSpp8bUk');

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

  
}
