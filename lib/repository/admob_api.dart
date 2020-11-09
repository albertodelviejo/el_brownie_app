import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';

class AdmobService {
  final String _appIdIOS = 'ca-app-pub-3940256099942544~1458002511';
  final String _appIdAndroid = 'ca-app-pub-3940256099942544~3347511713';

  //get the app id configured at Admob
  String getAppId() {
    if (Platform.isIOS) {
      return _appIdIOS;
    } else if (Platform.isAndroid) {
      return _appIdAndroid;
    }
    return null;
  }

  //Banner Ad
  AdmobBanner buildBannerAd(String bannerId) {
    return AdmobBanner(
      adUnitId: bannerId,
      adSize: AdmobBannerSize.FULL_BANNER,
    );
  }

  //######### Set your Ads here #########
  String getBannerAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  String getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    return null;
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }
}
