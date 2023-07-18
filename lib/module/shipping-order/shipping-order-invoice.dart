import 'dart:typed_data';

import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ShippingOrderInvoice extends StatefulWidget {
  final ShippingOrderModel shippingOrderModel;

  ShippingOrderInvoice(this.shippingOrderModel);

  @override
  _ShippingOrderInvoiceState createState() => _ShippingOrderInvoiceState();
}

class _ShippingOrderInvoiceState extends State<ShippingOrderInvoice> {
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
        title: Text("Order Invoice"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              child: Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildPaddingText(
                                      context: context,
                                      padding: 5.0,
                                      text: "DD Express",
                                      isTitle: true),
                                  buildPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text: "No 85",
                                      isTitle: false),
                                  buildPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text: "Jalan Ipoh,Papan Baru",
                                      isTitle: false),
                                  buildPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text: "31550, Pusing",
                                      isTitle: false),
                                  buildPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text: "Perak",
                                      isTitle: false),
                                  buildPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text: "Malaysia",
                                      isTitle: false),
                                  buildPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text: "018-9182033",
                                      isTitle: false),
                                ],
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Image(
                                          width: 150,
                                          image: AssetImage(
                                              "assets/images/logo.png")),
                                    ),
                                    SizedBox(
                                      height: 110,
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
                            ],
                          ),
                          buildSizedBoxDivider(),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Text("Order",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                  ),
                                  buildDetailInfo(context,
                                      label: "Order No.",
                                      detail:
                                          widget.shippingOrderModel.orderNo),
                                  buildDetailInfo(context,
                                      label: "Tracking No.",
                                      detail:
                                          widget.shippingOrderModel.trackingNo),
                                  buildDetailInfo(context,
                                      label: "Placed At",
                                      detail: widget
                                          .shippingOrderModel.createdAt
                                          .toLocal()),
                                ],
                              ),
                            ],
                          ),
                          buildSizedBoxDivider(),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Text("Invoice To",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                  ),
                                  buildInvoiceToPaddingText(
                                      context: context,
                                      padding: 5.0,
                                      text:
                                          widget.shippingOrderModel.senderName,
                                      isTitle: true),
                                  buildInvoiceToPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text: widget
                                          .shippingOrderModel.senderAddress,
                                      isTitle: false),
                                  buildInvoiceToPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text: widget
                                          .shippingOrderModel.senderPostcode,
                                      isTitle: false),
                                  buildInvoiceToPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text:
                                          widget.shippingOrderModel.senderCity,
                                      isTitle: false),
                                  buildInvoiceToPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text:
                                          widget.shippingOrderModel.senderState,
                                      isTitle: false),
                                  buildInvoiceToPaddingText(
                                      context: context,
                                      padding: 3.0,
                                      text: "Malaysia",
                                      isTitle: false),
                                ],
                              )
                            ],
                          ),
                          buildSizedBoxDivider(),
                          Container(
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Container(
                                  child: DataTable(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                    ),
                                    dataRowHeight: 170,
                                    columns: [
                                      DataColumn(
                                          label: Text('Receiver',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Address',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Item',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                    rows: [
                                      DataRow(cells: [
                                        DataCell(Text(
                                            "${widget.shippingOrderModel.recipientName}")),
                                        DataCell(Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "${widget.shippingOrderModel.recipientAddress}"),
                                            Text(
                                                "${widget.shippingOrderModel.recipientPostcode}"),
                                            Text(
                                                "${widget.shippingOrderModel.recipientCity}"),
                                            Text(
                                                "${widget.shippingOrderModel.recipientState}"),
                                            Text("Malaysia"),
                                          ],
                                        )),
                                        DataCell(Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildTableRowInfo(context,
                                                label: "Item Quantity",
                                                detail: widget
                                                    .shippingOrderModel
                                                    .itemQty),
                                            SizedBox(height: 5),
                                            buildTableRowInfo(context,
                                                label: "Item Type",
                                                detail: widget
                                                    .shippingOrderModel
                                                    .itemType),
                                            SizedBox(height: 5),
                                            buildTableRowInfo(context,
                                                label: "Item Weight",
                                                detail:
                                                    "${widget.shippingOrderModel.itemWeight} kg"),
                                          ],
                                        )),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildDetailInfo(context,
                                      label: "Sub-total",
                                      detail:
                                          "RM ${widget.shippingOrderModel.shippingCost}"),
                                  buildDetailInfo(context,
                                      label: "Discount", detail: '-'),
                                  buildDetailInfo(context,
                                      label: "Tax", detail: "-"),
                                ],
                              ),
                            ],
                          ),
                          buildSizedBoxDivider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildDetailInfo(context,
                                  label: "TOTAL",
                                  detail:
                                      "RM ${widget.shippingOrderModel.shippingCost}"),
                            ],
                          ),
                          buildSizedBoxDivider(),
                        ]),
                  )),
            )),
      ),
    );
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
      {BuildContext context, double padding, String text, bool isTitle}) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Text(
        text,
        softWrap: true,
        style: isTitle
            ? Theme.of(context).textTheme.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                )
            : Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Padding buildInvoiceToPaddingText(
      {BuildContext context, double padding, String text, bool isTitle}) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Text(
          text,
          softWrap: true,
          style: isTitle
              ? Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.headline6,
        ),
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
          Text(
            "$label:",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
            softWrap: true,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            "$label:",
          ),
        ),
        Text(
          "$detail",
        ),
      ],
    );
  }
}
