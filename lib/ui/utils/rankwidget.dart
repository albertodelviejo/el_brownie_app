import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RankTile extends StatelessWidget {
  String point, name, pub, image;
  int rank;
  RankTile({
    this.rank,
    this.image,
    this.name,
    this.pub,
    this.point,
  });
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Container(
      decoration: Mystyle.rankedfirsts(rank < 4 ? true : false),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: ListTile(
        leading: Text(
          rank.toString(),
          style: Mystyle.titleTextStyle.copyWith(
            fontSize: ScreenUtil().setSp(110),
            color: Mystyle.thirdcolo,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: ScreenUtil().setHeight(130),
              height: ScreenUtil().setHeight(130),
              decoration: BoxDecoration(
                color: Mystyle.primarycolo,
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
            SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Mystyle.normalTextStyle.copyWith(
                      fontSize: ScreenUtil().setSp(50),
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  pub,
                  style: Mystyle.regularTextStyle.copyWith(
                    fontSize: ScreenUtil().setSp(30),
                    color: Colors.black87,
                  ),
                ),
              ],
            )
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              point,
              style: Mystyle.subtitleTextStyle.copyWith(
                color: rank > 3 ? Colors.black87 : Mystyle.thirdcolo,
                fontSize: ScreenUtil().setSp(50),
              ),
            ),
            Text(
              "puntos",
              style: Mystyle.subtitleTextStyle.copyWith(
                color: rank > 3 ? Colors.black87 : Mystyle.thirdcolo,
                fontSize: ScreenUtil().setSp(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
