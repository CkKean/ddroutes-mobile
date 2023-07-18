import 'package:ddroutes/constant/order-type.constant.dart';
import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:ddroutes/model/task-model.dart';

class IdentifyOrderType {
  static int getOrderType(TaskModel taskModel, String routeId) {
    // 0 = Sender
    // 1 = Recipient

    if (taskModel.orderType == OrderTypeConstant.PICK_UP) {
      if (taskModel.isPickedUp) {
        if (taskModel.pickupRouteId == routeId) {
          return 0;
        } else {
          return 1;
        }
      } else {
        return 0;
      }
    } else {
      return 1;
    }
  }

  static String getOrderStatus({TaskModel taskModel, String routeId}) {
    if (taskModel.orderType == OrderTypeConstant.PICK_UP) {
      if (taskModel.isPickedUp) {
        if (taskModel.pickupRouteId == routeId) {
          return taskModel.pickupOrderStatus;
        } else {
          return taskModel.orderStatus;
        }
      } else {
        return taskModel.pickupOrderStatus;
      }
    } else  {
      return taskModel.orderStatus;
    }
  }

  static String getShippingOrderStatus({ShippingOrderModel shippingOrderModel}) {
    if (shippingOrderModel.orderType == OrderTypeConstant.PICK_UP) {
      if (shippingOrderModel.isPickedUp && shippingOrderModel.pickupProofId != null) {
          return shippingOrderModel.orderStatus;
      } else {
        return shippingOrderModel.pickupOrderStatus;
      }
    } else  {
      return shippingOrderModel.orderStatus;
    }
  }
}
