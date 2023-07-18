import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:ddroutes/model/tracking-model.dart';
import 'package:ddroutes/service/tracking-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TraceShippingOrder extends StatefulWidget {
  final ShippingOrderModel shippingOrderModel;

  TraceShippingOrder(this.shippingOrderModel);

  @override
  _TraceShippingOrderState createState() => _TraceShippingOrderState();
}

class _TraceShippingOrderState extends State<TraceShippingOrder> {
  String appBarTitle = "Trace Order";
  TrackingModel orderStatus;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd h:mma");
  DateFormat dateFormatWithoutDate = DateFormat("h:mma");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TrackingModel>(
        future: trackingService
            .getShippingOrderStatus(widget.shippingOrderModel.orderNo),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            orderStatus = snapshot.data;
            return buildScaffold(context);
          }
          return _buildLoading();
        });
  }

  Scaffold _buildLoading() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(appBarTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 50),
            Text('Data Loading'),
          ],
        ),
      ),
    );
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      body: Card(
        margin: EdgeInsets.all(10.0),
        elevation: 10,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.all(15.0),
                  child: _buildRowDetail(
                      content: orderStatus.trackingNo,
                      label: "Tracking number: ")),
              Container(
                  padding: EdgeInsets.all(15.0),
                  child: _buildRowDetail(
                      content: orderStatus.orderStatus == null
                          ? orderStatus.pickupOrderStatus
                          : orderStatus.orderStatus,
                      label: "Current Status: ")),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Stepper(
                  type: StepperType.vertical,
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Row(
                      children: <Widget>[
                        Container(
                          child: null,
                        ),
                      ], // <Widget>[]
                    ); // Row
                  },
                  steps: <Step>[
                    if (orderStatus.orderCompletedAt != null)
                      buildStep(context, orderStatus.orderCompletedAt,
                          "Order Completed", StepState.complete, false),
                    if (orderStatus.orderReceivedAt != null)
                      buildStep(
                          context,
                          orderStatus.orderReceivedAt,
                          "Parcel has been successfully received.",
                          StepState.complete,
                          false),
                    if (orderStatus.orderShippedAt != null)
                      buildStep(
                          context,
                          orderStatus.orderShippedAt,
                          "Parcel out for delivery. ${orderStatus.orderEstShippedAt != null ? '\nETA: ' : ''}${orderStatus.orderEstShippedAt != null ? ((dateFormat.format(orderStatus.orderEstShippedAt)).toString() + ' - ' + (dateFormatWithoutDate.format(orderStatus.orderEstShippedAt.add(Duration(days: 0, hours: 1)))).toString()) : ''}",
                          StepState.complete,
                          false),
                    if (orderStatus.orderPickedAt != null)
                      buildStep(
                          context,
                          orderStatus.orderPickedAt,
                          "Parcel has been picked up.",
                          StepState.complete,
                          false),
                    if (orderStatus.pickupReason != null)
                      buildStep(
                          context,
                          null,
                          "Failed (${(orderStatus.pickupReason)}). Please contact us 05-2881234",
                          StepState.error,
                          false),
                    if (orderStatus.orderComingAt != null)
                      buildStep(
                          context,
                          orderStatus.orderComingAt,
                          "On The Way. ${orderStatus.orderEstComingAt != null ? '\nETA: ' : ''}${orderStatus.orderEstComingAt != null ? ((dateFormat.format(orderStatus.orderEstComingAt)).toString() + ' - ' + (dateFormatWithoutDate.format(orderStatus.orderEstComingAt.add(Duration(days: 0, hours: 1)))).toString()) : ''}",
                          StepState.complete,
                          false),
                    if (orderStatus.orderPlacedAt != null)
                      buildStep(
                          context,
                          orderStatus.orderPlacedAt,
                          "Order have been paid (${orderStatus.trackingNo}).",
                          StepState.complete,
                          false),
                    if (orderStatus.orderPlacedAt != null)
                      buildStep(
                          context,
                          orderStatus.orderPlacedAt,
                          "Order details have been submitted successfully.",
                          StepState.complete,
                          false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Step buildStep(BuildContext context, DateTime subTitle, String title,
      StepState status, bool isActive) {
    return Step(
      isActive: isActive,
      state: status,
      title: Text(
        title,
        softWrap: true,
      ),
      subtitle: Text(
        "${subTitle != null ? (dateFormat.format(subTitle)).toString() : ''}",
        softWrap: true,
        style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 16),
      ),
      content: SizedBox(
        width: 0.0,
        height: 0.0,
      ),
    );
  }

  RichText _buildRowDetail({String label, String content}) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: label,
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 17),
        children: <TextSpan>[
          TextSpan(
            text: content,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 17),
          )
        ],
      ),
    );
  }
}
