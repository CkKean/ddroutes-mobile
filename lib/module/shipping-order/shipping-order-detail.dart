import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:ddroutes/shared/util/identify-order-type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShippingOrderDetail extends StatefulWidget {
  final ShippingOrderModel shippingOrderModel;

  ShippingOrderDetail({Key key, this.shippingOrderModel}) : super(key: key);

  @override
  ShippingOrderDetailState createState() => ShippingOrderDetailState();
}

class ShippingOrderDetailState extends State<ShippingOrderDetail> {
  String appBarTitle = "Shipping Order Detail";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String orderStatus = IdentifyOrderType.getShippingOrderStatus(
        shippingOrderModel: widget.shippingOrderModel);

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
                                  label: "Order Number",
                                  detail: widget.shippingOrderModel.orderNo),
                              buildDetailInfo(context,
                                  label: "Tracking Number",
                                  detail: widget.shippingOrderModel.trackingNo),
                              buildDetailInfo(context,
                                  label: "Type",
                                  detail: widget.shippingOrderModel.orderType),
                              buildDetailInfo(context,
                                  label: "Status", detail: orderStatus),
                              buildDetailInfo(context,
                                  label: "Vehicle Type",
                                  detail:
                                      widget.shippingOrderModel.vehicleType),
                              buildDetailInfo(context,
                                  label: "Payment Method",
                                  detail:
                                      widget.shippingOrderModel.paymentMethod),
                              buildDetailInfo(context,
                                  label: "Shipping Cost",
                                  detail:
                                      "RM ${widget.shippingOrderModel.shippingCost}"),
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
                                  title: "Sender Information"),
                              buildDetailInfo(context,
                                  label: "Name",
                                  detail: widget.shippingOrderModel.senderName),
                              buildDetailInfo(context,
                                  label: "Mobile Number",
                                  detail: widget
                                              .shippingOrderModel.senderMobileNo
                                              .substring(0, 2) ==
                                          '60'
                                      ? widget.shippingOrderModel.senderMobileNo
                                      : '60' +
                                          widget.shippingOrderModel
                                              .senderMobileNo),
                              buildDetailInfo(context,
                                  label: "Email",
                                  detail:
                                      widget.shippingOrderModel.senderEmail),
                              buildDetailInfo(context,
                                  label: "Address",
                                  detail:
                                      "${widget.shippingOrderModel.senderAddress}, ${widget.shippingOrderModel.senderPostcode} ${widget.shippingOrderModel.senderCity}, ${widget.shippingOrderModel.senderState}, Malaysia"),
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
                                  title: "Receiver Information"),
                              buildDetailInfo(context,
                                  label: "Name",
                                  detail:
                                      widget.shippingOrderModel.recipientName),
                              buildDetailInfo(context,
                                  label: "Mobile Number",
                                  detail: widget.shippingOrderModel
                                              .recipientMobileNo
                                              .substring(0, 2) ==
                                          '60'
                                      ? widget
                                          .shippingOrderModel.recipientMobileNo
                                      : '60' +
                                          widget.shippingOrderModel
                                              .recipientMobileNo),
                              buildDetailInfo(context,
                                  label: "Email",
                                  detail:
                                      widget.shippingOrderModel.recipientEmail),
                              buildDetailInfo(context,
                                  label: "Address",
                                  detail:
                                      "${widget.shippingOrderModel.recipientAddress}, ${widget.shippingOrderModel.recipientPostcode} ${widget.shippingOrderModel.recipientCity}, ${widget.shippingOrderModel.recipientState}, Malaysia"),
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
                                  label: "Quantity",
                                  detail: widget.shippingOrderModel.itemQty),
                              buildDetailInfo(context,
                                  label: "Weight",
                                  detail:
                                      "${widget.shippingOrderModel.itemWeight} kg"),
                              buildDetailInfo(context,
                                  label: "Type",
                                  detail:
                                      "${widget.shippingOrderModel.itemType}"),
                            ]),
                      )),
                ],
              ),
            )),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w600),
            softWrap: true,
          ),
          Text(
            detail != null ? "$detail" : "-",
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
