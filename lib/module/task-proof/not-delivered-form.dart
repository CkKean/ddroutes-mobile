import 'package:ddroutes/constant/dialog-status.constant.dart';
import 'package:ddroutes/constant/not-delivered-reason.constant.dart';
import 'package:ddroutes/constant/routes.constant.dart';
import 'package:ddroutes/constant/task-proof-status.constant.dart';
import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/model/task-proof-model.dart';
import 'package:ddroutes/service/task-proof-service.dart';
import 'package:ddroutes/shared/UI/shared-custom-dialog.dart';
import 'package:ddroutes/shared/UI/shared-loader-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotDeliveredForm extends StatefulWidget {
  final String orderNo;
  final String trackingNo;
  final String routeId;
  final DateTime arrivedAt;
  final int panelActiveIndex;

  NotDeliveredForm(
      {this.orderNo,
      this.trackingNo,
      this.arrivedAt,
      this.routeId,
      this.panelActiveIndex});

  @override
  _NotDeliveredFormState createState() => _NotDeliveredFormState();
}

class _NotDeliveredFormState extends State<NotDeliveredForm> {
  final _formKey = GlobalKey<FormState>();

  static TextEditingController reasonSelectController =
      new TextEditingController();
  static TextEditingController reasonController = new TextEditingController();

  void clearForm() {
    _formKey.currentState.reset();
    reasonSelectController.clear();
    reasonController.clear();
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

  void submitForm(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      String finalReason = reasonController.text;
      TaskProofModel taskProof = new TaskProofModel(
          routeId: widget.routeId,
          arrivedAt: widget.arrivedAt,
          orderNo: widget.orderNo,
          reason: finalReason,
          status: TaskProofStatus.NOT_DELIVERED,
          trackingNo: widget.trackingNo);

      showLoaderDialog(context, "Submitting POD...");
      IResponse result =
          await taskProofService.createTaskProof(taskProof: taskProof);
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
            height: 450.0,
            width: 400.0,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      buildLabelRow(context, label: "Reason Options"),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration:
                            buildInputDecoration("Reason options", false),
                        items: NotDeliveredReasonConstant.deliveryReasonList
                            .map((value) {
                          return DropdownMenuItem<String>(
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                              value: value);
                        }).toList(),
                        value: reasonSelectController.text.isNotEmpty
                            ? reasonSelectController.text
                            : null,
                        onChanged: (newValue) {
                          setState(() {
                            reasonSelectController.text = newValue;
                            reasonController.text = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Row(children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              child: Divider(
                                color: Theme.of(context).primaryColor,
                                height: 36,
                              )),
                        ),
                        Text("OR"),
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(left: 20.0),
                              child: Divider(
                                color: Theme.of(context).primaryColor,
                                height: 36,
                              )),
                        ),
                      ]),
                      SizedBox(height: 10),
                      buildLabelRow(context, label: "Reason"),
                      TextFormField(
                        controller: reasonController,
                        maxLines: 2,
                        decoration:
                            buildInputDecoration("Reason (required)", true),
                        onSaved: (value) {
                          reasonController.text = value;
                        },
                        validator: (value) {
                          if (value.isEmpty || value == '') {
                            return "Reason cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isEmpty || value == '') {
                            return "Reason cannot be empty";
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 8.0),
                        child: Text(
                          "Status: ${TaskProofStatus.NOT_DELIVERED}",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent.shade400),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: buildFormBottomButton(context),
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

  InputDecoration buildInputDecoration(String hintText, bool required) {
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

  Container buildFormBottomButton(BuildContext context) {
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
          buildSubmitBottomButton(context),
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

  Expanded buildSubmitBottomButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.green, padding: EdgeInsets.all(12)),
        child: Text("Submit",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white, fontSize: 16)),
        onPressed: () {
          submitForm(context);
        },
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
