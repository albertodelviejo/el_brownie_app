import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';

class AdmobService {
  final String _appIdIOS = 'ca-app-pub-2936019539842342/4390432301';
  final String _appIdAndroid = 'ca-app-pub-2936019539842342/7849303344';

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
      return 'ca-app-pub-2936019539842342/4390432301';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2936019539842342/7849303344';
    }
    return null;
  }

  String getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2936019539842342/4390432301';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2936019539842342/7849303344';
    }
    return null;
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2936019539842342/4390432301';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2936019539842342/7849303344';
    }
    return null;
  }
}
