import 'dart:developer';

import 'package:el_brownie_app/bloc/bloc_user.dart';
import 'package:el_brownie_app/model/post.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class CitaCard extends StatelessWidget {
  Post post;

  CitaCard({Key key, this.post});

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of(context);
    var concept = post.name;
    //var day = DateFormat.d().format(post.date);
    //var month = DateFormat.MMM().format(cita.date);
    //var day_name = DateFormat.E().format(cita.date);
    //var hour = DateFormat.Hm().format(cita.date);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          //userBloc.likePost(post);
        },
        child: Container(
          height: 120,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(post.valoration.toString()),
                      Text(post.price.toString()),
                      Expanded(child: Text(post.address)),
                    ],
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Restaurante:" + concept),
                          Text("Precio: " + post.price.toString()),
                          Container(
                              height: 1,
                              width: double.maxFinite,
                              color: Colors.grey[300]),
                          Text("Puntuacion: " + post.valoration),
                          Text("Categoría: " + post.category)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
