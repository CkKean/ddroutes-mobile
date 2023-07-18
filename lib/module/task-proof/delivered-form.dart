import 'dart:async';
import 'dart:io';

import 'package:ddroutes/constant/dialog-status.constant.dart';
import 'package:ddroutes/constant/routes.constant.dart';
import 'package:ddroutes/constant/task-proof-status.constant.dart';
import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/model/task-proof-model.dart';
import 'package:ddroutes/module/task-proof/signature-pad.dart';
import 'package:ddroutes/service/task-proof-service.dart';
import 'package:ddroutes/shared/UI/shared-custom-dialog.dart';
import 'package:ddroutes/shared/UI/shared-loader-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveredForm extends StatefulWidget {
  final String orderNo;
  final String trackingNo;
  final String routeId;
  final DateTime arrivedAt;
  final int panelActiveIndex;

  DeliveredForm(
      {this.orderNo,
      this.trackingNo,
      this.arrivedAt,
      this.routeId,
      this.panelActiveIndex});

  @override
  _DeliveredFormState createState() => _DeliveredFormState();
}

class _DeliveredFormState extends State<DeliveredForm> {
  final _formKey = GlobalKey<FormState>();

  static TextEditingController recipientName = TextEditingController();
  static TextEditingController recipientIcNo = TextEditingController();

  GlobalKey<SignaturePadState> textGlobalKey =
      new GlobalKey<SignaturePadState>();

  void clearForm() {
    _formKey.currentState.reset();
    recipientName.clear();
    recipientIcNo.clear();
    SignaturePadState.clearAll();
    setState(() {
      SignaturePadState.signed = false;
      SignaturePadState.imageFromDevice = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future afterSubmitDialog(BuildContext context, IResponse result) {
    if (result.success) {
      return sharedCustomAlertDialog(
        context: context,
        content: result.data,
        title: "Success",
        dialogStatus: DialogStatusConstant.SUCCESS,
        confirmText: "OK",
        confirmCallback: () {
          clearForm();
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushNamed(context, RoutesConstant.TASKS,
              arguments: widget.panelActiveIndex);
        },
      );
    } else {
      return sharedCustomAlertDialog(
          context: context,
          content: result.message,
          title: "Failed",
          dialogStatus: DialogStatusConstant.ERROR,
          cancelText: "OK",
          popCount: 2);
    }
  }

  void submitForm() async {
    dynamic imageSignFile = await SignaturePadState.getSignatureImageFile();
    File imageFromDevice = SignaturePadState.imageFromDevice;
    if (_formKey.currentState.validate()) {
      if (!SignaturePadState.signed && imageFromDevice == null) {
        sharedCustomAlertDialog(
          context: context,
          content: "Signature is required.",
          title: "Warning",
          dialogStatus: DialogStatusConstant.WARNING,
          cancelText: "OK",
        );
        return;
      }
      TaskProofModel taskProof = new TaskProofModel(
          arrivedAt: widget.arrivedAt,
          routeId: widget.routeId,
          recipientIcNo: recipientIcNo.text,
          recipientName: recipientName.text,
          orderNo: widget.orderNo,
          status: TaskProofStatus.DELIVERED,
          trackingNo: widget.trackingNo);

      showLoaderDialog(context, "Submitting POD...");
      IResponse result = await taskProofService.createTaskProofWithImage(
        url: "create/proof",
        imageFile: imageFromDevice,
        file: imageSignFile,
        data: taskProof,
      );

      afterSubmitDialog(context, result);
    }
  }

  Future onBack(BuildContext context) {
    return sharedCustomAlertDialog(
        title: "Discard your changes?",
        content: "If you go back now, your changes will be discarded.",
        context: context,
        confirmText: "Confirm",
        confirmCallback: () {
          clearForm();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        dialogStatus: DialogStatusConstant.WARNING,
        cancelText: "Cancel");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onBack(context);
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Proof of Delivery (POD)"),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      buildLabelRow(context, label: "Name"),
                      buildTextFormField(
                          controller: recipientName,
                          hintText: "Name (required)",
                          labelText: "Name",
                          errorMessage: "Name is required."),
                      SizedBox(height: 20),
                      buildLabelRow(context, label: "Identity Card Number"),
                      buildTextFormField(
                          controller: recipientIcNo,
                          hintText: "IC No. (required)",
                          labelText: "Identity Card Number",
                          errorMessage: "IC No. is required."),
                      SizedBox(height: 20),
                      SignaturePad(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 8.0),
                        child: Text(
                          "Status: ${TaskProofStatus.DELIVERED}",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: buildFormBottomButton(),
      ),
    );
  }

  Padding buildLabelRow(BuildContext context, {String label, Icon icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w600),
          ),
          if (icon != null)
            IconButton(
              icon: icon,
              onPressed: () {
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  TextFormField buildTextFormField(
      {TextEditingController controller,
      String labelText,
      String hintText,
      String errorMessage}) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      decoration: buildInputDecoration(hintText, labelText, true),
      onSaved: (value) {
        controller.text = value;
      },
      validator: (value) {
        if (value.isEmpty || value == '') {
          return errorMessage;
        }
        return null;
      },
    );
  }

  InputDecoration buildInputDecoration(
      String hintText, String labelText, bool required) {
    return InputDecoration(
      errorStyle: TextStyle(fontSize: 13.0),
      suffixText: required ? '*' : '',
      suffixStyle: TextStyle(
        color: Colors.red,
      ),
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  Container buildFormBottomButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      height: 80,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 2.0,
          spreadRadius: 0.0,
          offset: Offset(2.0, 2.0), // shadow direction: bottom right
        )
      ]),
      child: Row(
        children: <Widget>[
          buildClearBottomButton(),
          SizedBox(
            width: 10,
          ),
          buildCancelBottomButton(),
          SizedBox(
            width: 10,
          ),
          buildSubmitBottomButton(),
        ],
      ),
    );
  }

  Expanded buildCancelBottomButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.redAccent,
            padding: EdgeInsets.all(12),
            side: BorderSide(color: Colors.red, width: 1.5)),
        child: Text("Cancel",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.red, fontSize: 16)),
        onPressed: () {
          clearForm();
          Navigator.pop(context);
        },
      ),
    );
  }

  Expanded buildSubmitBottomButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.green, padding: EdgeInsets.all(12)),
        child: Text("Submit",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white, fontSize: 16)),
        onPressed: submitForm,
      ),
    );
  }

  Expanded buildClearBottomButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.grey.shade600,
            primary: Colors.white,
            padding: EdgeInsets.all(12),
            side: BorderSide(color: Colors.grey, width: 1.5)),
        child: Text("Clear",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.grey, fontSize: 16)),
        onPressed: clearForm,
      ),
    );
  }
}
