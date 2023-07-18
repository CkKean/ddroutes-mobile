import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShippingOrderForm extends StatefulWidget {
  final List<String> vehicleTypeList;

  ShippingOrderForm(this.vehicleTypeList);

  @override
  ShippingOrderFormState createState() => ShippingOrderFormState();
}

class ShippingOrderFormState extends State<ShippingOrderForm> {
  static final formKey = GlobalKey<FormState>();

  static TextEditingController itemQty = new TextEditingController();
  static TextEditingController itemType = new TextEditingController();
  static TextEditingController itemWeight = new TextEditingController();
  static TextEditingController vehicleType = new TextEditingController();

  static void clear() {
    itemQty.clear();
    itemType.clear();
    itemWeight.clear();
    vehicleType.clear();
  }

  static ShippingOrderModel getData() {
    ShippingOrderModel shippingOrderModel = new ShippingOrderModel(
        itemQty: int.parse(itemQty.text),
        itemType: itemType.text,
        itemWeight: double.parse(itemWeight.text),
        vehicleType: vehicleType.text);

    return shippingOrderModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildNumberFormField(
                controller: itemQty,
                hintText: "Item quantity (required)",
                labelText: "Item quantity",
                errorMsg: "Item quantity is required.",
                required: true,
                decimal: false),
            SizedBox(height: 20),
            buildTextFormField(
                controller: itemType,
                hintText: "Item type (required)",
                labelText: "Item type",
                errorMsg: "Item type is required.",
                required: true),
            SizedBox(height: 20),
            buildNumberFormField(
                controller: itemWeight,
                hintText: "Item weight (required)",
                labelText: "Item weight",
                errorMsg: "Item weight is required.",
                required: true,
                decimal: true),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: vehicleType.text.isNotEmpty ? vehicleType.text : null,
              isExpanded: true,
              decoration: buildInputDecoration(
                  "Vehicle Type (required)", "Vehicle Type"),
              items: widget.vehicleTypeList.map((value) {
                return DropdownMenuItem<String>(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                    ),
                    value: value);
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vehicle type is required.";
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  vehicleType.text = newValue;
                });
              },
              onChanged: (newValue) {
                setState(() {
                  vehicleType.text = newValue;
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
        setState(() {
          controller.text = value;
        });
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

  TextFormField buildNumberFormField(
      {TextEditingController controller,
      String hintText,
      String labelText,
      String errorMsg,
      bool required,
      bool decimal}) {
    return TextFormField(
      maxLines: 1,
      inputFormatters: decimal
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ]
          : [FilteringTextInputFormatter.digitsOnly],
      keyboardType: decimal
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      controller: controller,
      onSaved: (value) {
        setState(() {
          controller.text = value;
        });
      },
      decoration: buildInputDecoration(hintText, labelText),
      validator: (value) {
        Pattern pattern = r'\d';
        RegExp regex = new RegExp(pattern);
        if (required) {
          if (value.trim().isEmpty) {
            return errorMsg;
          } else if (!regex.hasMatch(value)) {
            return "Only digit is allow.";
          }
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }
}
