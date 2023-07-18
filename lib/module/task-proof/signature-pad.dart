import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:image_picker/image_picker.dart';

class SignaturePad extends StatefulWidget {
  @override
  SignaturePadState createState() => SignaturePadState();
}

class SignaturePadState extends State<SignaturePad> {
  static final sign = GlobalKey<SignatureState>();
  static File imageFromDevice;
  final picker = ImagePicker();
  static bool signed = false;

  @override
  void dispose() {
    super.dispose();
  }

  static clearAll() async {
    if (sign.currentState != null) {
      sign.currentState.clear();
    }
  }

  _imgFromCamera() async {
    final image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (picker != null) {
        imageFromDevice = File(image.path);
        signed = false;
        if (sign.currentState != null) sign.currentState.clear();
      }
    });
  }

  _imgFromGallery() async {
    final image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (picker != null) {
        imageFromDevice = File(image.path);
        signed = false;
        if (sign.currentState != null) sign.currentState.clear();
      }
    });
  }

  static Future<dynamic> getSignatureImageFile() async {
    if (sign.currentState != null) {
      final image = await sign.currentState.getData();
      final data = await image.toByteData(format: ui.ImageByteFormat.png);

      return data.buffer.asUint8List();
    } else {
      return null;
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child:  Wrap(
                children: <Widget>[
                   ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                   ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Signature/Photo",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    _showPicker(context);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      if (sign.currentState != null) {
                        sign.currentState.clear();
                      }
                      setState(() {
                        imageFromDevice = null;
                      });
                    },
                    child: Text(
                      "Clear",
                    )),
              ],
            )
          ],
        ),
        if (imageFromDevice == null)
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: Signature(
                  color: Colors.red,
                  key: sign,
                  strokeWidth: 5.0,
                  onSign: () {
                    setState(() {
                      signed = true;
                    });
                  },
                ),
              ),
            ),
            color: Colors.white,
          ),
        if (imageFromDevice != null)
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: Image.file(
                  imageFromDevice,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            color: Colors.black12,
          ),
      ],
    );
  }
}
