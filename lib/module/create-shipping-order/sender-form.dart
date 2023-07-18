import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:ddroutes/model/user-model.dart';
import 'package:ddroutes/model/utility-model.dart';
import 'package:ddroutes/service/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SenderForm extends StatefulWidget {
  final List<UtilityModel> stateList;

  SenderForm(this.stateList);

  @override
  SenderFormState createState() => SenderFormState();
}

class SenderFormState extends State<SenderForm> {
  static final formKey = GlobalKey<FormState>();

  static bool sameAsRegisteredInfo = false;

  static TextEditingController senderName = new TextEditingController();
  static TextEditingController senderMobileNo = new TextEditingController();
  static TextEditingController senderEmail = new TextEditingController();
  static TextEditingController senderAddress = new TextEditingController();
  static TextEditingController senderCity = new TextEditingController();
  static TextEditingController senderState = new TextEditingController();
  static TextEditingController senderPostcode = new TextEditingController();
  static TextEditingController fullSenderAddress = new TextEditingController();

  static void clear() {
    senderName.clear();
    senderMobileNo.clear();
    senderEmail.clear();
    senderAddress.clear();
    senderCity.clear();
    senderState.clear();
    senderPostcode.clear();
    fullSenderAddress.clear();
    sameAsRegisteredInfo = false;
  }

  static ShippingOrderModel getData() {
    ShippingOrderModel shippingOrderModel = new ShippingOrderModel(
        senderName: senderName.text,
        senderMobileNo: "60" + senderMobileNo.text,
        senderEmail: senderEmail.text,
        senderAddress: senderAddress.text,
        senderCity: senderCity.text,
        senderState: senderState.text,
        senderPostcode: senderPostcode.text,
        fullSenderAddress:
            "${senderAddress.text}, ${senderPostcode.text} ${senderCity.text}, ${senderState.text}, Malaysia",
        sameAsRegisteredInfo: sameAsRegisteredInfo);

    return shippingOrderModel;
  }

  void setSameAsResidentAddress() async {
    UserModel userModel = await userService.getUserInfo();
    setState(() {
      sameAsRegisteredInfo = !sameAsRegisteredInfo;
      if (sameAsRegisteredInfo) {
        senderName.text = userModel.fullName;
        senderMobileNo.text = userModel.mobileNo.substring(0, 2) == '60'
            ? userModel.mobileNo.substring(2, userModel.mobileNo.length)
            : userModel.mobileNo;
        senderEmail.text = userModel.email;
        senderAddress.text = userModel.address;
        senderCity.text = userModel.city;
        senderState.text = userModel.state;
        senderPostcode.text = userModel.postcode;
      } else {
        clear();
      }
    });
  }

  String validateDigitTextField(String value, String errorMsg) {
    Pattern pattern = r'\d';
    RegExp regex = new RegExp(pattern);
    if (value.trim().isEmpty) {
      return errorMsg;
    } else if (!regex.hasMatch(value)) {
      return "Only digit is allow.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Checkbox(
                  value: sameAsRegisteredInfo,
                  onChanged: (bool value) {
                    setSameAsResidentAddress();
                  },
                ),
                Text(
                  "Same As Registered Information",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            buildTextFormField(
                controller: senderName,
                hintText: "Name (required)",
                labelText: "Name",
                errorMsg: "Sender name is required.",
                required: true),
            SizedBox(height: 20),
            buildMobileFormField(
                hintText: "Mobile Number (required)",
                labelText: "Mobile Number",
                errorMsg: "Sender mobile number is required."),
            SizedBox(height: 20),
            buildEmailFormField(
                controller: senderEmail,
                labelText: "Email",
                hintText: "Email (optional)"),
            SizedBox(height: 20),
            buildAddressFormField(
                hintText: "Address (required)",
                labelText: "Address",
                errorMsg: "Sender address is required."),
            SizedBox(height: 20),
            buildPostcodeFormField(
                controller: senderPostcode,
                hintText: "Postcode (required)",
                labelText: "Postcode ",
                errorMsg: "Sender postcode is required.",
                required: true),
            SizedBox(height: 20),
            buildTextFormField(
                controller: senderCity,
                hintText: "City (required)",
                labelText: "City",
                errorMsg: "Sender city is required.",
                required: true),
            if (widget.stateList.length > 0) SizedBox(height: 20),
            if (widget.stateList.length > 0)
              DropdownButtonFormField<String>(
                value: senderState.text.isNotEmpty ? senderState.text : null,
                isExpanded: true,
                decoration: buildInputDecoration("State (required)", "State"),
                items: widget.stateList.map((value) {
                  return DropdownMenuItem<String>(
                      child: Text(
                        value.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      value: value.name);
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Sender state is required.";
                  }
                  return null;
                },
                onSaved: (value) {
                  senderState.text = value;
                },
                onChanged: (newValue) {
                  setState(() {
                    senderState.text = newValue;
                  });
                },
              ),
          ],
        ),
      ),
    ));
  }

  TextFormField buildTextFormField(
      {TextEditingController controller,
      String hintText,
      String labelText,
      String errorMsg,
      bool required}) {
    return TextFormField(
      maxLines: 1,
      controller: controller,
      onSaved: (value) {
        controller.text = value;
      },
      decoration: buildInputDecoration(hintText, labelText),
      validator: (value) {
        if (required) {
          if (value.trim().isEmpty) {
            return errorMsg;
          }
        }
        return null;
      },
    );
  }

  TextFormField buildAddressFormField(
      {String hintText, String labelText, String errorMsg}) {
    return TextFormField(
      maxLines: 3,
      onSaved: (value) {
        senderAddress.text = value;
      },
      controller: senderAddress,
      decoration: buildInputDecoration(hintText, labelText),
      validator: (value) {
        if (value.trim().isEmpty) {
          return errorMsg;
        }
        return null;
      },
    );
  }

  TextFormField buildMobileFormField(
      {String hintText, String labelText, String errorMsg}) {
    return TextFormField(
      onSaved: (value) {
        senderMobileNo.text = value;
      },
      controller: senderMobileNo,
      keyboardType: TextInputType.number,
      maxLength: 10,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 14.0),
        prefixText: "+60",
        prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
        suffixText: '*',
        suffixStyle: TextStyle(
          color: Colors.red,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      validator: (value) {
        return validateDigitTextField(value, errorMsg);
      },
    );
  }

  TextFormField buildPostcodeFormField(
      {TextEditingController controller,
      String hintText,
      String labelText,
      String errorMsg,
      bool required}) {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSaved: (value) {
        controller.text = value;
      },
      controller: controller,
      maxLength: 5,
      decoration: buildInputDecoration(hintText, labelText),
      validator: (value) {
        return validateDigitTextField(value, errorMsg);
      },
    );
  }

  TextFormField buildEmailFormField({
    TextEditingController controller,
    String hintText,
    String labelText,
  }) {
    return TextFormField(
      maxLines: 1,
      onSaved: (value) {
        controller.text = value;
      },
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: buildInputDecoration(hintText, labelText),
      validator: (value) {
        if (value != null && value != '') {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value)) return 'Invalid Email format';
        }
        return null;
      },
    );
  }

  InputDecoration buildInputDecoration(String hintText, String labelText) {
    return InputDecoration(
      errorStyle: TextStyle(fontSize: 13.0),
      suffixText: '*',
      suffixStyle: TextStyle(
        color: Colors.red,
      ),
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }
}
