import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:ddroutes/model/utility-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReceiverForm extends StatefulWidget {
  final List<UtilityModel> stateList;

  ReceiverForm(this.stateList);

  @override
  ReceiverFormState createState() => ReceiverFormState();
}

class ReceiverFormState extends State<ReceiverForm> {
  static final formKey = GlobalKey<FormState>();

  static TextEditingController recipientName = new TextEditingController();
  static TextEditingController recipientMobileNo = new TextEditingController();
  static TextEditingController recipientEmail = new TextEditingController();
  static TextEditingController recipientAddress = new TextEditingController();
  static TextEditingController recipientCity = new TextEditingController();
  static TextEditingController recipientState = new TextEditingController();
  static TextEditingController recipientPostcode = new TextEditingController();
  static TextEditingController fullRecipientAddress =
      new TextEditingController();

  static void clear() {
    recipientName.clear();
    recipientMobileNo.clear();
    recipientEmail.clear();
    recipientAddress.clear();
    recipientCity.clear();
    recipientState.clear();
    recipientPostcode.clear();
    fullRecipientAddress.clear();
  }

  static ShippingOrderModel getData() {
    ShippingOrderModel shippingOrderModel = new ShippingOrderModel(
      recipientName: recipientName.text,
      recipientMobileNo: "60"+recipientMobileNo.text,
      recipientEmail: recipientEmail.text,
      recipientAddress: recipientAddress.text,
      recipientCity: recipientCity.text,
      recipientState: recipientState.text,
      recipientPostcode: recipientPostcode.text,
      fullRecipientAddress:
          "${recipientAddress.text}, ${recipientPostcode.text} ${recipientCity.text}, ${recipientState.text}, Malaysia",
    );

    return shippingOrderModel;
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
          children: <Widget>[
            buildTextFormField(
                controller: recipientName,
                hintText: "Name (required)",
                labelText: "Name",
                errorMsg: "Recipient name is required.",
                required: true),
            SizedBox(height: 20),
            buildMobileFormField(
              hintText: "Mobile Number (required)",
              labelText: "Mobile Number",
              errorMsg: "Recipient mobile number is required.",
            ),
            SizedBox(height: 20),
            buildEmailFormField(
                controller: recipientEmail,
                labelText: "Email",
                hintText: "Email (optional)"),
            SizedBox(height: 20),
            buildAddressFormField(
                hintText: "Address (required)",
                labelText: "Address",
                errorMsg: "Recipient address is required."),
            SizedBox(height: 20),
            buildPostcodeFormField(
                controller: recipientPostcode,
                hintText: "Postcode (required)",
                labelText: "Postcode",
                errorMsg: "Recipient postcode number is required.",
                required: true),
            SizedBox(height: 20),
            buildTextFormField(
                controller: recipientCity,
                hintText: "City (required)",
                labelText: "City",
                errorMsg: "Recipient city is required.",
                required: true),
            if (widget.stateList.length > 0) SizedBox(height: 20),
            if (widget.stateList.length > 0)
              DropdownButtonFormField<String>(
                value:
                    recipientState.text.isNotEmpty ? recipientState.text : null,
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
                    return "Recipient state is required.";
                  }
                  return null;
                },
                onSaved: (value) {
                  recipientState.text = value;
                },
                onChanged: (newValue) {
                  setState(() {
                    recipientState.text = newValue;
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
        recipientAddress.text = value;
      },
      controller: recipientAddress,
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
        recipientMobileNo.text = value;
      },
      controller: recipientMobileNo,
      keyboardType: TextInputType.number,
      maxLength: 10,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 14.0),
        prefixText: "+60",
        prefixStyle: TextStyle(
          color: Colors.black,
          fontSize: 16
        ),
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
          borderSide: BorderSide(color: Colors.blueAccent,width: 2)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }
}
