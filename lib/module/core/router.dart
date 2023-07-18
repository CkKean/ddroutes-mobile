import 'package:ddroutes/constant/routes.constant.dart';
import 'package:ddroutes/module/create-shipping-order/create-shipping-order.dart';
import 'package:ddroutes/module/homepage/homepage.dart';
import 'package:ddroutes/module/personal-detail/personal-detail.dart';
import 'package:ddroutes/module/shipping-order/shipping-order-invoice.dart';
import 'package:ddroutes/module/shipping-order/shipping-order-label.dart';
import 'package:ddroutes/module/shipping-order/shipping-order-list.dart';
import 'package:ddroutes/module/shipping-order/trace-shipping-order.dart';
import 'package:ddroutes/module/task-proof/task-proof-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> createRoute(settings) {
  var data = settings.arguments;

  switch (settings.name) {
    case RoutesConstant.HOMEPAGE:
      return MaterialPageRoute(builder: (context) => HomePage());

    case RoutesConstant.TASKS:
      return MaterialPageRoute(
          builder: (context) => TaskProofList(
                selectedRouteId: data,
              ));

    case RoutesConstant.MY_SHIPPING_ORDER:
      return MaterialPageRoute(builder: (context) => ShippingOrderList());

    case RoutesConstant.CREATE_SHIPPING_ORDER:
      return MaterialPageRoute(builder: (context) => CreateShippingOrder());

    case RoutesConstant.SHIPPING_ORDER_INVOICE:
      return MaterialPageRoute(
          builder: (context) => ShippingOrderInvoice(data));

    case RoutesConstant.TRACE_SHIPPING_ORDER:
      return MaterialPageRoute(builder: (context) => TraceShippingOrder(data));

    case RoutesConstant.PERSONAL_DETAILS:
      return MaterialPageRoute(builder: (context) => PersonalDetail());

    case RoutesConstant.SHIPMENT_LABEL:
      return MaterialPageRoute(builder: (context) => ShippingOrderLabel(data));
  }
  return null;
}
