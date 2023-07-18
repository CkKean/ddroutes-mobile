import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context, String content) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.transparent,
    insetPadding: EdgeInsets.all(5),
    content: Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10.0)),
      width: 30.0,
      height: 150.0,
      alignment: AlignmentDirectional.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: new SizedBox(
              height: 35.0,
              width: 35.0,
              child: new CircularProgressIndicator(
                value: null,
                strokeWidth: 4.0,
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: new Center(
              child: new Text(
                "$content",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
