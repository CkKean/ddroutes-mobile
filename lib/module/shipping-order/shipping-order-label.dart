import 'dart:typed_data';

import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ShippingOrderLabel extends StatefulWidget {
  final ShippingOrderModel shippingOrderModel;

  ShippingOrderLabel(this.shippingOrderModel);

  @override
  _ShippingOrderLabelState createState() => _ShippingOrderLabelState();
}

class _ShippingOrderLabelState extends State<ShippingOrderLabel> {
  Uint8List bytes = Uint8List(0);

  @override
  void initState() {
    super.initState();
    _generateBarCode();
  }

  Future _generateBarCode() async {
    Uint8List result =
        await scanner.generateBarCode(widget.shippingOrderModel.orderNo);
    this.setState(() => this.bytes = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Shipment Label"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              child: Column(
                children: [
                  buildCard(context, "Centre Copy"),
                  buildCard(context, "Receiver Copy"),
                ],
              ),
            )),
      ),
    );
  }

  Card buildCard(BuildContext context, String copy) {
    return Card(
        margin: EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1)),
                    height: 450,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      color: Colors.black, width: 1))),
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(copy),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 50,
                                            child: Image(
                                                image: AssetImage(
                                                    "assets/images/logo.png")),
                                          ),
                                          Text(
                                              widget.shippingOrderModel
                                                  .trackingNo,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 60,
                                        width: 110,
                                        child: bytes.isEmpty
                                            ? Center(
                                                child: Text('Empty code ... ',
                                                    style: TextStyle(
                                                        color: Colors.black38)),
                                              )
                                            : Image.memory(bytes),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Colors.black,
                                                          width: 1))),
                                              width: 200,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  buildPaddingTextTitle(
                                                      context: context,
                                                      padding: 10.0,
                                                      text: "From (Shipper)"),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 5.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .senderName,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .senderAddress,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .senderPostcode,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .senderCity,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .senderState,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: "Malaysia",
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  buildPaddingTextTitle(
                                                      context: context,
                                                      padding: 10.0,
                                                      text: "To (Receiver)"),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 5.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .recipientName,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .recipientAddress,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .recipientPostcode,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .recipientCity,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: widget
                                                        .shippingOrderModel
                                                        .recipientState,
                                                  ),
                                                  buildPaddingText(
                                                    context: context,
                                                    padding: 3.0,
                                                    text: "Malaysia",
                                                  ),
                                                ],
                                              )),
                                          Container(
                                              width: 350,
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  buildTableRowInfo(context,
                                                      label: "Order Number",
                                                      detail: widget
                                                          .shippingOrderModel
                                                          .orderNo),
                                                  buildTableRowInfo(context,
                                                      label: "Weight",
                                                      detail:
                                                          "${widget.shippingOrderModel.itemWeight} kg"),
                                                  buildTableRowInfo(context,
                                                      label: "Shipping Cost",
                                                      detail:
                                                          "RM ${widget.shippingOrderModel.shippingCost}"),
                                                  buildTableRowInfo(context,
                                                      label: "Order Date",
                                                      detail:
                                                          "${widget.shippingOrderModel.createdAt.toLocal()}"),
                                                ],
                                              )),
                                        ],
                                      )),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  SizedBox buildSizedBoxDivider() {
    return SizedBox(
      height: 20,
      child: Divider(
        height: 10,
        color: Colors.blueAccent,
      ),
    );
  }

  Padding buildPaddingText(
      {BuildContext context, double padding, String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 14),
      ),
    );
  }

  Padding buildPaddingTextTitle(
      {BuildContext context, double padding, String text, bool isTitle}) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Padding buildDetailInfo(BuildContext context,
      {String label, dynamic detail}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: Theme.of(context).textTheme.headline6,
              softWrap: true,
            ),
          ),
          Text(
            "$detail",
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }

  Row buildTableRowInfo(BuildContext context, {String label, dynamic detail}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          height: 35,
          child: Text(
            "$label:",
          ),
        ),
        SizedBox(
          height: 35,
          child: Text(
            "$detail",
          ),
        ),
      ],
    );
  }
}
