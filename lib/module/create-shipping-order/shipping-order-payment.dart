import 'package:ddroutes/constant/payment-method.constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShippingOrderPayment extends StatefulWidget {
  @override
  ShippingOrderPaymentState createState() => ShippingOrderPaymentState();
}

class ShippingOrderPaymentState extends State<ShippingOrderPayment> {
  static String selectedPaymentMethod = PaymentMethodConstant.CASH;

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
                for (var method in PaymentMethodConstant.paymentMethodList)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = method;
                        });
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: selectedPaymentMethod == method
                              ? Border.all(width: 2, color: Colors.blueAccent)
                              : Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        padding: EdgeInsets.all(25.0),
                        child: Text(
                          method,
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
