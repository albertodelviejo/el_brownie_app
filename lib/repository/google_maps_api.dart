import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyCQarq8zgeo0ksCrI7p1m3yG-JQSpp8bUk";

class GoogleMapsApi {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  Future<Location> getSearchLocation(text) async {
    await _places.searchByText(text).then((PlacesSearchResponse response) {
      return response.results.first.geometry.location;
    });
  }
}
