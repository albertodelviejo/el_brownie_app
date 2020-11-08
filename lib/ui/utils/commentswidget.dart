import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentsW extends StatelessWidget {
  String time, comment, name, image;
  int valoration, likes;

  CommentsW({
    this.image,
    this.name,
    this.valoration,
    this.comment,
    this.likes,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Column(children: [
      Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 8),
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          leading: Container(
            width: ScreenUtil().setHeight(130),
            height: ScreenUtil().setHeight(130),
            decoration: BoxDecoration(
              color: Mystyle.primarycolo,
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: ExactAssetImage(
                    '/assets/avatars/avatar1.png'), //NetworkImage(image),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
          title: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      name,
                      style: Mystyle.regularTextStyle.copyWith(
                        fontSize: ScreenUtil().setSp(34),
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: 5),
                    child: Row(
                      children: List.generate(5, (index) {
                        return index < valoration
                            ? Container(
                                height: ScreenUtil().setHeight(70),
                                width: ScreenUtil().setHeight(70),
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                child: Image.asset("assets/ifull.png"),
                              )
                            : Container(
                                height: ScreenUtil().setHeight(70),
                                width: ScreenUtil().setHeight(70),
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                child: Image.asset("assets/iempty.png"),
                              );
                      }),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      comment,
                      overflow: TextOverflow.clip,
                      style: Mystyle.regularTextStyle.copyWith(
                        fontSize: ScreenUtil().setSp(40),
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: ScreenUtil().setWidth(70),
                          width: ScreenUtil().setWidth(70),
                          child: SvgPicture.asset(
                            "assets/svg/like.svg",
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        likes.toString(),
                        style: Mystyle.smallTextStyle.copyWith(
                          fontSize: ScreenUtil().setSp(40),
                          color: Colors.black87,
                          // height: 1,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                time,
                style: Mystyle.smallTextStyle.copyWith(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(34),
                ),
              ),
            ],
          ),
        ),
      ),
      Divider(color: Colors.black87),
    ]);
  }
}
