import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'mystyle.dart';

class OrderByUi extends StatelessWidget {
  final String title;
  final String image;
  final bool selected;
  final Function onOrderByPressed;
  OrderByUi({
    @required this.title,
    @required this.image,
    this.selected,
    this.onOrderByPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onOrderByPressed,
          child: Container(
            height: ScreenUtil().setWidth(80),
            width: ScreenUtil().setWidth(80),
            child: SvgPicture.asset(
              image,
              color: selected == true ? Color(0xFF25bbee) : Colors.black87,
            ),
          ),
        ),
        Text(
          title,
          style: Mystyle.smallTextStyle.copyWith(
            color: selected == true ? Color(0xFF25bbee) : Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
