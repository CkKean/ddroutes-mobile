import 'package:ddroutes/model/price-plan-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveryRateTable extends StatelessWidget {
  final List<PricePlanModel> pricePlan;

  DeliveryRateTable(this.pricePlan);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 30.0,
        columns: [
          DataColumn(
              label: Text('Type',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Weight',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Distance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Subsequent',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ],
        rows: [
          for (var price in pricePlan)
            DataRow(cells: [
              DataCell(Text(price.vehicleType)),
              DataCell(Text(
                  "${price.defaultWeightPrefix} ${price.defaultWeight.toString()} ${price.defaultWeightUnit}")),
              DataCell(Text(
                  "${price.defaultDistancePrefix} ${price.defaultDistance.toString()} ${price.defaultDistanceUnit}")),
              DataCell(Text("RM ${price.defaultPricing}")),
              DataCell(buildSubsequentText(price)),
            ]),
        ],
      ),
    );
  }

  Text buildSubsequentText(PricePlanModel price) {
    return Text(
        "${(price.subDistance != null ? 'Subsq. ${price.subDistance} ${price.subDistanceUnit} + RM ${price.subDistancePricing}' : '-')}\n"
        "${(price.subWeight != null ? 'Subsq. ${price.subWeight} ${price.subWeightUnit} + RM ${price.subWeightPricing}' : '-')}");
  }
}
