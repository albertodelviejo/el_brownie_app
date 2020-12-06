import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:el_brownie_app/repository/admob_api.dart';
import 'package:el_brownie_app/ui/screens/home/post_screen.dart';
import 'package:el_brownie_app/ui/utils/cardhome.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardLosmas extends StatelessWidget {
  String name,
      place,
      view,
      category,
      valo,
      hace,
      id,
      pagename,
      price,
      imageUrl,
      idUserPost;
  String myindex = "3";
  bool reclam;
  bool isTapped, isMarked;
  Icon icon = Icon(
    Icons.bookmark_border,
    color: Colors.black87,
  );
  String notific_id;
  final admobService = AdmobService();
  bool isAdd;

  CardLosmas(
      {this.name,
      this.place,
      this.view,
      this.valo,
      this.category = '',
      this.hace,
      this.reclam,
      this.myindex,
      this.id,
      this.imageUrl,
      this.pagename,
      this.price,
      this.idUserPost,
      this.isMarked = false,
      this.isTapped = false,
      this.isAdd = false});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return (isAdd)
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.only(top: 5, right: 5, left: 5),
            child: AdmobBanner(
              adUnitId: admobService.getBannerAdId(),
              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            ),
          )
        : GestureDetector(
            onTap: () {
              if (!isTapped) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostScreen(
                              id: name.hashCode.toString(),
                              cardHome: CardHome(
                                isTapped: true,
                                name: name,
                                valo: valo,
                                place: place,
                                reclam: reclam,
                                view: view,
                                hace: hace,
                                imageUrl: imageUrl,
                                myindex: myindex,
                                id: id,
                                isMarked: isMarked,
                                idUserPost: idUserPost,
                                pagename: "post",
                              ),
                            )));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.only(top: 5, right: 5, left: 5),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(600),
                        height: ScreenUtil().setHeight(530),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              imageUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding: EdgeInsets.all(7),
                              child: Text(
                                myindex,
                                style: Mystyle.normalTextStyle
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            /*
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.bookmark_border,
                                color: Colors.black,
                              ),
                            ),
                            */
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 0, left: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(425),
                          child: Text(
                            name,
                            style: Mystyle.titleTextStyle.copyWith(
                              color: Colors.black87,
                              fontSize: 20,
                              height: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.place,
                          color: Mystyle.secondrycolo,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            place,
                            maxLines: 1,
                            style:
                                Mystyle.placeTextStyle.copyWith(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        return index < int.parse(myindex)
                            ? Container(
                                height: ScreenUtil().setHeight(60),
                                width: ScreenUtil().setHeight(60),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: Image.asset("assets/ifull.png"),
                              )
                            : Container(
                                height: ScreenUtil().setHeight(60),
                                width: ScreenUtil().setHeight(60),
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                child: Image.asset("assets/iempty.png"),
                              );
                      }),
                    ),
                  ),
                ],
              ),
            ));
  }
}
