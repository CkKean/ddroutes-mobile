import 'package:ddroutes/constant/dialog-status.constant.dart';
import 'package:ddroutes/constant/order-type.constant.dart';
import 'package:ddroutes/constant/utility.constant.dart';
import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/model/price-plan-model.dart';
import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:ddroutes/model/utility-model.dart';
import 'package:ddroutes/module/create-shipping-order/receiver-form.dart';
import 'package:ddroutes/module/create-shipping-order/sender-form.dart';
import 'package:ddroutes/module/create-shipping-order/shipping-order-overview.dart';
import 'package:ddroutes/module/create-shipping-order/shipping-order-payment.dart';
import 'package:ddroutes/service/price-plan-service.dart';
import 'package:ddroutes/service/shipping-order-service.dart';
import 'package:ddroutes/shared/UI/shared-custom-dialog.dart';
import 'package:ddroutes/shared/UI/shared-loader-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Shipping-order-form.dart';
import 'delivery-rate-table.dart';

class CreateShippingOrder extends StatefulWidget {
  CreateShippingOrder({Key key}) : super(key: key);

  @override
  CreateShippingOrderState createState() => CreateShippingOrderState();
}

class CreateShippingOrderState extends State<CreateShippingOrder> {
  String appBarTitle = "Create Shipping Order";
  int currentStep = 0;

  List<UtilityModel> stateList = [];
  List<PricePlanModel> pricePlanList = [];
  List<String> vehicleTypeList = [];
  ShippingOrderModel overviewData;

  @override
  void initState() {
    super.initState();
    getStateList();
  }

  void changeStep(int step) async {
    if (step == 4) {
      await getOverviewData();
    }
    setState(() {
      currentStep = step;
    });
  }

  void getStateList() async {
    dynamic stateData = UtilityConstant.stateList;
    dynamic pricePlanData = await pricePlanService.getPricePlan();
    dynamic vehicleType = await shippingOrderService.getVehicleList();
    setState(() {
      stateList = stateData;
      pricePlanList = pricePlanData;
      vehicleTypeList = vehicleType;
    });
  }

  void _backButton() {
    _requestPopMessage(context);
  }

  Future _requestPopMessage(BuildContext context) {
    return sharedCustomAlertDialog(
        title: "Discard your changes?",
        content: "If you go back now, your changes will be discarded.",
        context: context,
        confirmText: "Confirm",
        confirmCallback: () {
          resetForm();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        dialogStatus: DialogStatusConstant.WARNING,
        cancelText: "Cancel");
  }

  void resetForm() {
    SenderFormState.clear();
    ReceiverFormState.clear();
    ShippingOrderFormState.clear();
  }

  void submitForm(BuildContext context) async {
    String paymentMethod = ShippingOrderPaymentState.selectedPaymentMethod;
    if (paymentMethod.isNotEmpty &&
        paymentMethod != null &&
        SenderFormState.formKey.currentState.validate() &&
        ReceiverFormState.formKey.currentState.validate() &&
        ShippingOrderFormState.formKey.currentState.validate()) {
      overviewData.paymentMethod = paymentMethod;

      showLoaderDialog(context, "Submitting Shipping Order...");

      IResponse result = await shippingOrderService.createShippingOrder(
          shippingOrderModel: overviewData);

      afterSubmitDialog(context, result);
    } else {
      String errorMessage;
      if (!SenderFormState.formKey.currentState.validate()) {
        errorMessage = "Sender information incomplete.";
      } else if (!ReceiverFormState.formKey.currentState.validate()) {
        errorMessage = "Recipient information incomplete.";
      } else if (!ShippingOrderFormState.formKey.currentState.validate()) {
        errorMessage = "Order information incomplete.";
      } else {
        errorMessage = "Payment method incomplete.";
      }

      sharedCustomAlertDialog(
          context: context,
          content: errorMessage,
          title: "Info Incomplete",
          dialogStatus: DialogStatusConstant.WARNING,
          cancelText: "OK");
    }
  }

  Future<dynamic> afterSubmitDialog(BuildContext context, IResponse result) {
    if (result.success) {
      return sharedCustomAlertDialog(
        context: context,
        content: result.data,
        title: "Success",
        dialogStatus: DialogStatusConstant.SUCCESS,
        confirmText: "OK",
        confirmCallback: () {
          resetForm();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      );
    } else {
      return sharedCustomAlertDialog(
          context: context,
          content: result.message,
          title: "Failed",
          dialogStatus: DialogStatusConstant.ERROR,
          cancelText: "OK",
          popCount: 2);
    }
  }

  Future<void> getOverviewData() async {
    ShippingOrderModel senderData = SenderFormState.getData();
    ShippingOrderModel receiverData = ReceiverFormState.getData();
    ShippingOrderModel itemData = ShippingOrderFormState.getData();

    ShippingOrderModel data = new ShippingOrderModel(
      orderType: OrderTypeConstant.PICK_UP,
      senderName: senderData.senderName,
      senderMobileNo: senderData.senderMobileNo,
      senderEmail: senderData.senderEmail,
      senderAddress: senderData.senderAddress,
      senderCity: senderData.senderCity,
      senderState: senderData.senderState,
      senderPostcode: senderData.senderPostcode,
      fullSenderAddress: senderData.fullSenderAddress,
      recipientName: receiverData.recipientName,
      recipientMobileNo: receiverData.recipientMobileNo,
      recipientEmail: receiverData.recipientEmail,
      recipientAddress: receiverData.recipientAddress,
      recipientCity: receiverData.recipientCity,
      recipientState: receiverData.recipientState,
      recipientPostcode: receiverData.recipientPostcode,
      fullRecipientAddress: receiverData.fullRecipientAddress,
      itemWeight: itemData.itemWeight,
      itemQty: itemData.itemQty,
      itemType: itemData.itemType,
      vehicleType: itemData.vehicleType,
    );

    dynamic shippingCost =
        await shippingOrderService.getShippingCost(shippingOrderModel: data);
    overviewData = data;
    overviewData.shippingCost = shippingCost.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (stateList.length > 0 && pricePlanList.length > 0) {
      List<Step> steps = [
        Step(
          title: Text("Delivery Rate Table (Swipe left to see more)"),
          content: DeliveryRateTable(pricePlanList),
          state: currentStep == 0 ? StepState.editing : StepState.indexed,
          isActive: true,
        ),
        Step(
          title: Text("Sender Information"),
          content: SenderForm(stateList),
          state: currentStep == 1 ? StepState.editing : StepState.indexed,
          isActive: true,
        ),
        Step(
          title: Text("Recipient Information"),
          content: ReceiverForm(stateList),
          state: currentStep == 2 ? StepState.editing : StepState.indexed,
          isActive: true,
        ),
        Step(
          title: Text("Order Information"),
          content: ShippingOrderForm(vehicleTypeList),
          state: currentStep == 3 ? StepState.editing : StepState.indexed,
          isActive: true,
        ),
        Step(
          title: Text("Overview"),
          content: ShippingOrderOverview(shippingOrderModel: overviewData),
          state: currentStep == 4 ? StepState.editing : StepState.indexed,
          isActive: true,
        ),
        Step(
          title: Text("Payment"),
          content: ShippingOrderPayment(),
          state: currentStep == 5 ? StepState.editing : StepState.indexed,
          isActive: true,
        ),
      ];
      return WillPopScope(
        onWillPop: () {
          _backButton();
          return new Future(() => false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => _backButton(),
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              appBarTitle,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),
          body: buildStepper(steps),
        ),
      );
    } else {
      return _buildLoading();
    }
  }

  Scaffold _buildLoading() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 50),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }

  Container buildStepper(List<Step> steps) {
    return Container(
      child: Stepper(
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                currentStep == 0
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ElevatedButton(
                          onPressed: onStepCancel,
                          child: Text('Back'),
                        ),
                      ),
                currentStep == 5
                    ? ElevatedButton(
                        onPressed: () {
                          submitForm(context);
                        },
                        child: Text('Submit'),
                      )
                    : ElevatedButton(
                        onPressed: onStepContinue,
                        child: Text('Next'),
                      ),
              ],
            ),
          );
        },
        currentStep: this.currentStep,
        steps: steps,
        type: StepperType.vertical,
        onStepTapped: (step) async {
          if (currentStep == 1) {
            if (SenderFormState.formKey.currentState.validate()) {
              changeStep(step);
            }
          } else if (currentStep == 2) {
            if (ReceiverFormState.formKey.currentState.validate()) {
              changeStep(step);
            }
          } else if (currentStep == 3) {
            if (ShippingOrderFormState.formKey.currentState.validate()) {
              changeStep(step);
            }
          } else {
            changeStep(step);
          }
        },
        onStepContinue: () async {
          if (currentStep < steps.length) {
            if (currentStep == 0) {
              changeStep(currentStep + 1);
            } else if (currentStep == 1) {
              if (SenderFormState.formKey.currentState.validate()) {
                changeStep(currentStep + 1);
              }
            } else if (currentStep == 2) {
              if (ReceiverFormState.formKey.currentState.validate())
                changeStep(currentStep + 1);
            } else if (currentStep == 3) {
              if (ShippingOrderFormState.formKey.currentState.validate()) {
                changeStep(currentStep + 1);
              }
            } else if (currentStep == 4) {
              changeStep(currentStep + 1);
            }
          }
        },
        onStepCancel: () {
          setState(() {
            if (currentStep > 0) {
              currentStep = currentStep - 1;
            } else {
              currentStep = 0;
            }
          });
        },
      ),
    );
  }
}
