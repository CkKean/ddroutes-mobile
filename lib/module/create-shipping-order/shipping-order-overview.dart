import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShippingOrderOverview extends StatefulWidget {
  final ShippingOrderModel shippingOrderModel;

  ShippingOrderOverview({Key key, this.shippingOrderModel}) : super(key: key);

  @override
  ShippingOrderOverviewState createState() => ShippingOrderOverviewState();
}

class ShippingOrderOverviewState extends State<ShippingOrderOverview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.shippingOrderModel != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildTitlePadding(context,
                                title: "Order Information"),
                            buildDetailInfo(context,
                                label: "Type",
                                detail: widget.shippingOrderModel.orderType),
                            buildDetailInfo(context,
                                label: "Vehicle Type",
                                detail: widget.shippingOrderModel.vehicleType),
                            buildDetailInfo(context,
                                label: "Shipping Cost",
                                detail:
                                    "RM ${widget.shippingOrderModel.shippingCost}"),
                            SizedBox(height: 10),
                            buildTitlePadding(context,
                                title: "Sender Information"),
                            buildDetailInfo(context,
                                label: "Name",
                                detail: widget.shippingOrderModel.senderName),
                            buildDetailInfo(context,
                                label: "Mobile No.",
                                detail: widget.shippingOrderModel.senderMobileNo
                                            .substring(0, 2) ==
                                        '60'
                                    ? widget.shippingOrderModel.senderMobileNo
                                    : '60' +
                                        widget
                                            .shippingOrderModel.senderMobileNo),
                            buildDetailInfo(context,
                                label: "Email",
                                detail: (widget.shippingOrderModel.senderEmail
                                        .isNotEmpty)
                                    ? widget.shippingOrderModel.senderEmail
                                    : "-"),
                            buildDetailInfo(
                              context,
                              label: "Full Address",
                              detail:
                                  "${widget.shippingOrderModel.senderAddress}, ${widget.shippingOrderModel.senderPostcode} ${widget.shippingOrderModel.senderCity},${widget.shippingOrderModel.senderState}, Malaysia",
                            ),
                            SizedBox(height: 10),
                            buildTitlePadding(context,
                                title: "Recipient Information"),
                            buildDetailInfo(context,
                                label: "Name",
                                detail:
                                    widget.shippingOrderModel.recipientName),
                            buildDetailInfo(context,
                                label: "Mobile No.",
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
                                detail: (widget.shippingOrderModel
                                        .recipientEmail.isNotEmpty)
                                    ? widget.shippingOrderModel.recipientEmail
                                    : "-"),
                            buildDetailInfo(
                              context,
                              label: "Full Address",
                              detail:
                                  "${widget.shippingOrderModel.recipientAddress}, ${widget.shippingOrderModel.recipientPostcode} ${widget.shippingOrderModel.recipientCity},${widget.shippingOrderModel.recipientState}, Malaysia",
                            ),
                          ]),
                    ),
                  ),
              ],
            ),
          )),
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
              fontSize: 20.0,
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
              style: Theme.of(context).textTheme.headline6,
              softWrap: true,
            ),
          ),
          Expanded(
            child: Text(
              "$detail",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}
