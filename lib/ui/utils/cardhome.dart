import 'dart:ui';

import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/ui/screens/home/post_screen.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class CardHome extends StatefulWidget {
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

  bool reclam;
  String myindex = "3";
  bool isTapped, isMarked;
  Icon icon = Icon(
    Icons.bookmark_border,
    color: Colors.black87,
  );
  String notific_id;
  double longitude;
  double latitude;

  CardHome(
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
      this.longitude,
      this.latitude,
      this.isMarked = false,
      this.isTapped = false});

  @override
  _CardHomeState createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of(context);
    ScreenUtil.init(context);

    return GestureDetector(
      onTap: () {
        if (!widget.isTapped && !widget.reclam) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostScreen(
                        id: widget.name.hashCode.toString(),
                        cardHome: CardHome(
                          isTapped: true,
                          name: widget.name,
                          valo: widget.valo,
                          place: widget.place,
                          reclam: widget.reclam,
                          view: widget.view,
                          hace: widget.hace,
                          imageUrl: widget.imageUrl,
                          myindex: widget.myindex,
                          id: widget.id,
                          isMarked: widget.isMarked,
                          idUserPost: widget.idUserPost,
                          pagename: "post",
                        ),
                      )));
        }
      },
      child: Column(
        children: [
          Stack(children: [
            Padding(
              padding: EdgeInsets.symmetric(
                //horizontal: widget.reclam ? 16 : 16,
                vertical: widget.reclam ? 12 : 12,
              ),
              /*
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: widget.reclam ? 5 : 0.1,
                  sigmaY: widget.reclam ? 5 : 0.1,
                ),
                */
              child: Container(
                  width: ScreenUtil().setWidth(widget.reclam ? 900 : 900),
                  height: ScreenUtil().setHeight(widget.reclam ? 900 : 900),
                  child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: widget.reclam ? 3 : 0.1,
                        sigmaY: widget.reclam ? 3 : 0.1,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget.reclam ? 10 : 10),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.imageUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))),
            ),
            //),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                    /*
                    (widget.pagename == "post")
                        ? Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: GestureDetector(
                              onTap: () {
                                if (!widget.isMarked) {
                                  setState(() {
                                    widget.icon = Icon(
                                      Icons.bookmark,
                                      color: Colors.black87,
                                    );
                                  });
                                  userBloc.likePost(widget.id);
                                  userBloc
                                      .addNotification(
                                          widget.idUserPost, "favourite", 10)
                                      .then(
                                          (value) => widget.notific_id = value);
                                  userBloc.addPoints(widget.idUserPost, 10);

                                  widget.isMarked = true;
                                } else {
                                  setState(() {
                                    widget.icon = Icon(
                                      Icons.bookmark_border,
                                      color: Colors.black87,
                                    );
                                  });
                                  userBloc.unlikePost(widget.id);
                                  userBloc
                                      .deleteNotification(widget.notific_id);
                                  userBloc.deletePoints(widget.idUserPost);
                                  widget.isMarked = false;
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: !widget.isMarked
                                      ? widget.icon
                                      : Icon(
                                          Icons.bookmark,
                                          color: Colors.black87,
                                        )),
                            ),
                          ),
                          */
                  ]),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4.0, top: 12, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.pagename == "post")
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          children: List.generate(5, (index) {
                            //var myindexaux = int.parse(widget.myindex);
                            return index < int.parse(widget.myindex)
                                ? Container(
                                    height: ScreenUtil().setHeight(90),
                                    width: ScreenUtil().setHeight(90),
                                    margin: EdgeInsets.symmetric(horizontal: 3),
                                    child: Image.asset("assets/ifull.png"),
                                  )
                                : Container(
                                    height: ScreenUtil().setHeight(90),
                                    width: ScreenUtil().setHeight(90),
                                    margin: EdgeInsets.symmetric(horizontal: 3),
                                    child: Image.asset("assets/iempty.png"),
                                  );
                          }),
                        ),
                      )
                    : Container(
                        width: ScreenUtil().setWidth(500),
                        child: Text(
                          widget.name,
                          style: Mystyle.titleTextStyle.copyWith(
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
                      alignment: Alignment.centerLeft,
                      child: widget.reclam
                          ? Icon(
                              Icons.check,
                              color: Mystyle.thirdcolo,
                              size: 15,
                            )
                          : Container(),
                    ),
                    SizedBox(width: 5),
                    Text(
                      widget.reclam ? "Reclamada" : "Sin Reclamar",
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
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                Icon(Icons.place, color: Mystyle.secondrycolo),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    widget.place,
                    style: Mystyle.placeTextStyle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          (widget.pagename == "post")
              ? Container()
              : Padding(
                  padding:
                      const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 5),
                  child: Row(
                    children: List.generate(5, (index) {
                      //var myindexaux = int.parse(widget.myindex);
                      return index < int.parse(widget.myindex)
                          ? Container(
                              height: ScreenUtil().setHeight(90),
                              width: ScreenUtil().setHeight(90),
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              child: Image.asset("assets/ifull.png"),
                            )
                          : Container(
                              height: ScreenUtil().setHeight(90),
                              width: ScreenUtil().setHeight(90),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /** 
                Row(
                  children: [
                    Text(
                      widget.view,
                      style: Mystyle.smallTextStyle.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      widget.valo,
                      style: Mystyle.smallTextStyle.copyWith(
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                */
                widget.pagename == "mibrownie"
                    ? Text(
                        widget.price,
                        style: Mystyle.titleregularTextStyle.copyWith(
                          color: Colors.black87,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(height: 5),
          /** 
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
          */
        ],
      ),
    );
  }
}
