import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class CardHome extends StatefulWidget {
  String name, place, view, valo, hace, id;
  bool reclam;
  String myindex = "3";
  bool isTapped = false;
  Icon icon = Icon(
    Icons.bookmark_border,
    color: Colors.black87,
  );

  CardHome(
      {this.name,
      this.place,
      this.view,
      this.valo,
      this.hace,
      this.reclam,
      this.myindex,
      this.id});
  @override
  _CardHomeState createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of(context);
    ScreenUtil.init(context);

    return Column(
      children: [
        Container(
          width: ScreenUtil().setWidth(900),
          height: ScreenUtil().setHeight(900),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                "https://media-cdn.tripadvisor.com/media/photo-s/09/a6/26/ad/pop-s-place.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  widget.myindex,
                  style: Mystyle.subtitleTextStylenoco
                      .copyWith(color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (!widget.isTapped) {
                    setState(() {
                      widget.icon = Icon(
                        Icons.bookmark,
                        color: Colors.black87,
                      );
                    });
                    userBloc.likePost(widget.id);
                    widget.isTapped = true;
                  } else {
                    setState(() {
                      widget.icon = Icon(
                        Icons.bookmark_border,
                        color: Colors.black87,
                      );
                    });
                    userBloc.unlikePost(widget.id);
                    widget.isTapped = false;
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    padding: EdgeInsets.all(8),
                    child: widget.icon),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: Mystyle.titleTextStyle.copyWith(
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setHeight(50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.transparent,
                      border: Border.all(color: Mystyle.thirdcolo),
                    ),
                    alignment: Alignment.center,
                    child: widget.reclam
                        ? Icon(
                            Icons.check,
                            color: Mystyle.thirdcolo,
                            size: 12,
                          )
                        : Container(),
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.reclam ? "Reclamada" : "Taska Church",
                    style: Mystyle.smallTextStyle.copyWith(
                      color: Mystyle.thirdcolo,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.place, color: Mystyle.secondrycolo),
              SizedBox(width: 5),
              Text(
                widget.place,
                style: Mystyle.placeTextStyle,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: List.generate(5, (index) {
              //var myindexaux = int.parse(widget.myindex);
              return index < 3
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
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                widget.view,
                style: Mystyle.normalTextStyle,
              ),
              SizedBox(width: 5),
              Text(
                widget.valo,
                style: Mystyle.normalTextStyle,
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.hace,
            style: Mystyle.normalTextStyle.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
