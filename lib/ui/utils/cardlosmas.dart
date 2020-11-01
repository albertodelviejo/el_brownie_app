import 'dart:ui';

import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardLosmas extends StatelessWidget {
  String name, place;
  int myindex = 3;
  CardLosmas({
    this.name,
    this.place,
    this.myindex,
  });
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: ScreenUtil().setWidth(600),
                height: ScreenUtil().setHeight(450),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://media-cdn.tripadvisor.com/media/photo-s/09/a6/26/ad/pop-s-place.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "3.5",
                        style: Mystyle.normalTextStyle
                            .copyWith(color: Colors.white),
                      ),
                    ),
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
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: Mystyle.subtitleTextStyle.copyWith(
                    color: Colors.black87,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.place,
                color: Mystyle.secondrycolo,
              ),
              SizedBox(width: 2),
              Flexible(
                child: Text(
                  place,
                  style: Mystyle.placeTextStyle.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return index < myindex
                    ? Container(
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setHeight(50),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Image.asset("assets/ifull.png"),
                      )
                    : Container(
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setHeight(50),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Image.asset("assets/iempty.png"),
                      );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
