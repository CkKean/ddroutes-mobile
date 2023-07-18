import 'dart:ui';

import 'package:ddroutes/constant/route-status.constant.dart';
import 'package:flutter/material.dart';

import '../../model/company-address-model.dart';
import '../../model/task-model.dart';

class MapBottomPill extends StatefulWidget {
  final List<TaskModel> taskModel;
  final CompanyAddressModel companyAddressModel;
  final bool roundTrip;
  final String routeId;
  final String totalDuration;
  final String totalDistance;

  MapBottomPill(
      {this.taskModel,
      this.companyAddressModel,
      this.roundTrip,
      this.totalDuration,
      this.totalDistance,
      this.routeId});

  @override
  _MapBottomPillState createState() => _MapBottomPillState();
}

class _MapBottomPillState extends State<MapBottomPill> {
  List<StepModified> steps = [];
  int currentStep = 0;

  @override
  void initState() {
    super.initState();

    steps.add(StepModified(
      title: Text(
        "Departure (Company)",
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      content: stepContentRow(
          "${widget.companyAddressModel.address}, ${widget.companyAddressModel.postcode} ${widget.companyAddressModel.city}, "
          "${widget.companyAddressModel.state}, Malaysia"),
      state: StepModifiedState.complete,
      isActive: true,
    ));
    for (var task in widget.taskModel) {
      String orderStatus;
      String address;
      String name;

      Color color;
      if (task.displayOrderStatus == RouteStatusConstant.FAILED) {
        color = Colors.red;
      } else if (task.displayOrderStatus == RouteStatusConstant.IN_PROGRESS) {
        color = Colors.blue;
      } else if (task.displayOrderStatus == RouteStatusConstant.COMPLETED ||
          task.displayOrderStatus == RouteStatusConstant.DELIVERED ||
          task.displayOrderStatus == RouteStatusConstant.PICKED_UP) {
        color = Colors.green;
      }

      name = task.recipientName;
      orderStatus = task.displayOrderStatus;
      address =
          "${task.recipientAddress}, ${task.recipientPostcode} ${task.recipientCity}, ${task.recipientState}, Malaysia";

      steps.add(StepModified(
        title: RichText(
          softWrap: true,
          text: TextSpan(
            text: "$name\n",
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
            children: <TextSpan>[
              TextSpan(
                text: "$orderStatus",
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        content: stepContentRow("$address"),
        state: StepModifiedState.indexed,
        isActive: true,
      ));
    }
    if (widget.roundTrip) {
      steps.add(StepModified(
        title: Text(
          "Destination (Company)",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        content: stepContentRow(
            "${widget.companyAddressModel.address}, ${widget.companyAddressModel.postcode} ${widget.companyAddressModel.city}, "
            "${widget.companyAddressModel.state}, Malaysia"),
        state: StepModifiedState.complete,
        isActive: true,
      ));
    }
  }

  Row stepContentRow(String text) {
    return Row(
      children: [
        Flexible(child: Text(text, softWrap: true, textAlign: TextAlign.left)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset.zero)
            ]),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
                child: Text(
                  "Total Duration: ${widget.totalDuration}",
                  style: TextStyle(fontSize: 16,
                      color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 25, right: 25),
                child: Text(
                  "Total Distance: ${widget.totalDistance}",
                  style: TextStyle(fontSize: 16,
                      color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ),
              buildTaskContainer(),
            ],
          ),
        ));
  }

  Container buildTaskContainer() {
    return Container(
      child: StepperModified(
        physics: ClampingScrollPhysics(),
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Row(
            children: <Widget>[
              Container(
                child: null,
              ),
              Container(
                child: null,
              ),
            ], // <Widget>[]
          ); // Row
        },
        currentStep: currentStep,
        steps: steps,
        type: StepperModifiedType.vertical,
      ),
    );
  }
}
