import 'package:ddroutes/constant/dialog-status.constant.dart';
import 'package:ddroutes/constant/route-status.constant.dart';
import 'package:ddroutes/model/task-model.dart';
import 'package:ddroutes/module/task-proof/pick-up-form.dart';
import 'package:ddroutes/shared/UI/shared-custom-dialog.dart';
import 'package:ddroutes/shared/util/identify-order-type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'delivered-form.dart';
import 'not-delivered-form.dart';
import 'not-pick-up-form.dart';

class TaskProofDetail extends StatefulWidget {
  final TaskModel taskModel;
  final String routeId;
  final int panelActiveIndex;

  TaskProofDetail(
      {Key key, this.taskModel, this.routeId, this.panelActiveIndex})
      : super(key: key);

  @override
  TaskProofDetailState createState() => TaskProofDetailState();
}

class TaskProofDetailState extends State<TaskProofDetail> {
  String appBarTitle = "Task Detail";
  DateTime arrivedAt;
  TaskModel taskModel;
  int orderFormType;

  @override
  void initState() {
    super.initState();
    taskModel = widget.taskModel;
  }

  void completedTask(String orderStatus) async {
    await sharedCustomAlertDialog(
        context: context,
        dialogStatus: DialogStatusConstant.WARNING,
        title: "Warning",
        content: "The task is $orderStatus.",
        cancelText: "Close");
  }

  bool checkCompleteTask() {
    String orderStatus = IdentifyOrderType.getOrderStatus(
        routeId: widget.routeId, taskModel: taskModel);
    if (orderStatus == RouteStatusConstant.COMPLETED ||
        orderStatus == RouteStatusConstant.FAILED ||
        orderStatus == RouteStatusConstant.PICKED_UP) {
      completedTask(orderStatus);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    String name;
    String mobileNo;
    String address;
    String information;
    String status;
    String orderType;

    name = taskModel.recipientName;
    address =
        "${taskModel.recipientAddress}, ${taskModel.recipientPostcode} ${taskModel.recipientCity}, ${taskModel.recipientState}, Malaysia";
    mobileNo = taskModel.displayMobileNo;
    status = taskModel.displayOrderStatus;
    orderType = taskModel.displayMobileOrderType;

    if (IdentifyOrderType.getOrderType(taskModel, widget.routeId) == 0) {
      orderFormType = 0;
      information = "Sender Information";
    } else {
      orderFormType = 1;
      information = "Receiver Information";
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          appBarTitle,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                      margin: EdgeInsets.all(15),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildTitlePadding(context,
                                  title: "Order Information"),
                              buildDetailInfo(context,
                                  label: "Tracking Number",
                                  detail: taskModel.trackingNo),
                              buildDetailInfo(context,
                                  label: "Type", detail: orderType),
                              buildDetailInfo(context,
                                  label: "Status", detail: status),
                            ]),
                      )),
                  Card(
                      margin: EdgeInsets.all(15),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildTitlePadding(context, title: information),
                              buildDetailInfo(context,
                                  label: "Name", detail: name),
                              buildDetailInfo(context,
                                  label: "Mobile Number",
                                  detail: mobileNo.substring(0, 2) == '60'
                                      ? mobileNo
                                      : '60' + mobileNo ),
                              buildDetailInfo(context,
                                  label: "Address", detail: address),
                            ]),
                      )),
                  Card(
                      margin: EdgeInsets.all(15),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildTitlePadding(context,
                                  title: "Item Information"),
                              buildDetailInfo(context,
                                  label: "Quantity", detail: taskModel.itemQty),
                              buildDetailInfo(context,
                                  label: "Weight",
                                  detail: "${taskModel.itemWeight} kg"),
                            ]),
                      )),
                ],
              ),
            )),
      ),
      bottomNavigationBar: buildFormBottomButton(orderType),
    );
  }

  Container buildFormBottomButton(String orderType) {
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
          buildNotDeliverBottomButton(orderType),
          SizedBox(
            width: 30,
          ),
          buildDeliveredBottomButton(orderType),
        ],
      ),
    );
  }

  Expanded buildDeliveredBottomButton(String orderType) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.green, padding: EdgeInsets.all(12)),
        child: Text(orderFormType == 1 ? "Delivered" : "Picked-up",
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontSize: 16)),
        onPressed: () {
          if (!checkCompleteTask()) return;
          arrivedAt = DateTime.now().toLocal();
          showDialog(
            context: context,
            builder: (context) {
              return orderFormType == 1
                  ? DeliveredForm(
                      routeId: widget.routeId,
                      orderNo: taskModel.orderNo,
                      trackingNo: taskModel.trackingNo,
                      panelActiveIndex: widget.panelActiveIndex,
                      arrivedAt: arrivedAt,
                    )
                  : PickedUpForm(
                      routeId: widget.routeId,
                      orderNo: taskModel.orderNo,
                      trackingNo: taskModel.trackingNo,
                      panelActiveIndex: widget.panelActiveIndex,
                      arrivedAt: arrivedAt,
                    );
            },
          );
        },
      ),
    );
  }

  Expanded buildNotDeliverBottomButton(String orderType) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.all(12),
            side: BorderSide(color: Colors.red, width: 1.5)),
        child: Text(orderFormType == 1 ? "Not Delivered" : "Not Picked-up",
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.red, fontSize: 16)),
        onPressed: () {
          if (!checkCompleteTask()) return;
          arrivedAt = DateTime.now().toLocal();
          showDialog(
            context: context,
            builder: (context) {
              return orderFormType == 1
                  ? NotDeliveredForm(
                      routeId: widget.routeId,
                      orderNo: widget.taskModel.orderNo,
                      trackingNo: widget.taskModel.trackingNo,
                      panelActiveIndex: widget.panelActiveIndex,
                      arrivedAt: arrivedAt)
                  : NotPickUpForm(
                      routeId: widget.routeId,
                      orderNo: widget.taskModel.orderNo,
                      trackingNo: widget.taskModel.trackingNo,
                      panelActiveIndex: widget.panelActiveIndex,
                      arrivedAt: arrivedAt);
            },
          );
        },
      ),
    );
  }

  Padding buildTitlePadding(BuildContext context, {String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w600,
              fontSize: 26.0,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Padding buildDetailInfo(BuildContext context,
      {String label, dynamic detail}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              "$label:",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.w600),
              softWrap: true,
            ),
          ),
          Expanded(
            child: Text(
              "$detail",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }
}
