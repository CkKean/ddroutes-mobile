import 'package:ddroutes/constant/dialog-status.constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future sharedCustomAlertDialog(
    {BuildContext context,
    VoidCallback confirmCallback,
    VoidCallback cancelCallback,
    String title,
    String content,
    String cancelText,
    String confirmText,
    int popCount,
    String dialogStatus}) {
  String status = DialogStatusConstant.SUCCESS; // Default Status
  int count = 1; // Default Pop Count (dismiss dialog)
  Icon statusIcon;
  Color statusColor;

  if (dialogStatus != null) {
    status = dialogStatus;
  }
  if (popCount != null) {
    count = popCount;
  }

  if (status == DialogStatusConstant.SUCCESS) {
    statusColor = Colors.green;
    statusIcon = Icon(Icons.check_circle_outline, color: statusColor, size: 35);
  } else if (status == DialogStatusConstant.WARNING) {
    statusColor = Colors.orange;
    statusIcon = Icon(
      Icons.info_outline,
      size: 35,
      color: statusColor,
    );
  } else if (status == DialogStatusConstant.ERROR) {
    statusColor = Colors.red;
    statusIcon = Icon(Icons.error_outline, color: statusColor, size: 35);
  }

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        title: Row(
          children: [
            statusIcon,
            Expanded(
              flex: 1,
              child: Text(
                title,
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: statusColor),
              ),
            ),
          ],
        ),
        content: Text(
          content,
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: <Widget>[
          if (cancelText != null)
            TextButton(
                child: Text(
                  cancelText,
                  style: TextStyle(
                      color: confirmText != null ? Colors.grey : Colors.blue,
                      fontSize: 16.0),
                ),
                onPressed: cancelCallback != null
                    ? cancelCallback
                    : () {
                        int i = 0;
                        Navigator.popUntil(context, (route) {
                          return i++ == count;
                        });
                      }),
          if (confirmText != null)
            TextButton(
                child: Text(
                  confirmText,
                  style: TextStyle(color: Colors.blue, fontSize: 16.0),
                ),
                onPressed: confirmCallback),
        ],
      );
    },
  );
}
