import 'package:admob_flutter/admob_flutter.dart';
import 'package:el_brownie_app/repository/admob_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardAdd extends StatelessWidget {
  final admobService = AdmobService();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.only(top: 5, right: 5, left: 5),
      child: AdmobBanner(
        adUnitId: admobService.getBannerAdId(),
        adSize: AdmobBannerSize.ADAPTIVE_BANNER(
            width: ScreenUtil().setWidth(600).toInt()),
      ),
    );
  }
}
