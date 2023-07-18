import 'package:ddroutes/constant/route-status.constant.dart';
import 'package:ddroutes/constant/routes.constant.dart';
import 'package:ddroutes/model/filter-shippng-order-model.dart';
import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:ddroutes/module/shipping-order/shipping-order-detail.dart';
import 'package:ddroutes/service/shipping-order-service.dart';
import 'package:ddroutes/shared/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShippingOrderList extends StatefulWidget {
  ShippingOrderList({Key key}) : super(key: key);

  @override
  ShippingOrderListState createState() => ShippingOrderListState();
}

class ShippingOrderListState extends State<ShippingOrderList>
    with SingleTickerProviderStateMixin {
  String appBarTitle = "Shipping Order";

  Future<FilterShippingOrderModel> shippingOrderData;
  List<ShippingOrderModel> oriDataList = [];
  List<ShippingOrderModel> dataList = [];

  List<ShippingOrderModel> pendingList = [];
  List<ShippingOrderModel> inProgressList = [];
  List<ShippingOrderModel> failedList = [];
  List<ShippingOrderModel> pickedUpList = [];
  List<ShippingOrderModel> completedList = [];

  List<String> actionList = ["Trace", "Shipment Label", "Invoice"];

  int dataCount;

  void selectedChoices(
      dynamic selectedChoice, ShippingOrderModel selectedShippingOrder) {
    switch (selectedChoice) {
      case "Trace":
        Navigator.pushNamed(context, RoutesConstant.TRACE_SHIPPING_ORDER,
            arguments: selectedShippingOrder);
        break;

      case "Shipment Label":
        Navigator.pushNamed(context, RoutesConstant.SHIPMENT_LABEL,
            arguments: selectedShippingOrder);
        break;

      case "Invoice":
        Navigator.pushNamed(context, RoutesConstant.SHIPPING_ORDER_INVOICE,
            arguments: selectedShippingOrder);
        break;
    }
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  TextEditingController searchController = new TextEditingController();
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 6, vsync: this);
    super.initState();
    shippingOrderData = shippingOrderService.getShippingOrderList();
  }

  Future<void> refreshData() async {
    setState(() {
      shippingOrderData = shippingOrderService.getShippingOrderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FilterShippingOrderModel>(
        future: shippingOrderData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            oriDataList = [...snapshot.data.allOrder];
            dataList = [...oriDataList];
            dataCount = dataList.length;
            completedList = [...snapshot.data.completedList];
            inProgressList = [...snapshot.data.inProgressList];
            failedList = [...snapshot.data.failedList];
            pendingList = [...snapshot.data.pendingList];
            pickedUpList = [...snapshot.data.pickedUpList];

            return _buildScaffold();
          }
          return _buildLoading();
        });
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
            Text('Fetching data... Please wait'),
          ],
        ),
      ),
    );
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // buildSearchBar(context),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: TabBar(
                labelStyle: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600),
                tabs: [
                  tab(title: "All"),
                  tab(title: "Pending"),
                  tab(title: "Picked Up"),
                  tab(title: "Failed"),
                  tab(title: "In Progress"),
                  tab(title: "Completed"),
                ],
                controller: _tabController,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueAccent),
                isScrollable: true,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildTasksList(data: dataList),
                  buildTasksList(data: pendingList),
                  buildTasksList(data: pickedUpList),
                  buildTasksList(data: failedList),
                  buildTasksList(data: inProgressList),
                  buildTasksList(data: completedList)
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Tab tab({String title}) {
    return Tab(
      child: Container(
        width: 100,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.blueAccent, width: 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }

  RefreshIndicator buildTasksList({List<ShippingOrderModel> data}) {
    return RefreshIndicator(
      onRefresh: () async {
        return await refreshData();
      },
      child: ListView.builder(
          key: UniqueKey(),
          shrinkWrap: true,
          itemBuilder: (context, index) => buildParticularTaskCard(
              index: index, context: context, data: data),
          itemCount: data.length > 0 ? data.length : 1),
    );
  }

  Card buildParticularTaskCard(
      {int index, BuildContext context, List<ShippingOrderModel> data}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: data.length > 0
          ? InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShippingOrderDetail(shippingOrderModel: data[index])),
                );
              },
              child: ListTile(
                  leading: _buildListLeading(
                      index: index, orderType: data[index].orderType),
                  title: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child:
                            _buildListTitle(order: data[index], index: index),
                      )),
                  subtitle: SizedBox(
                      width: double.infinity,
                      child: _buildListSubtitle(
                          recipientName: "${data[index].recipientName}",
                          recipientAddress:
                              "${data[index].recipientAddress}, ${data[index].recipientPostcode} ${data[index].recipientCity},${data[index].recipientState}, Malaysia",
                          index: index)),
                  isThreeLine: true,
                  trailing: _buildOrderMoreButton(context, index, data[index])),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "No Records",
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  Card buildTaskCard(int index, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(7.0),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ShippingOrderDetail(shippingOrderModel: dataList[index])),
          );
        },
        child: ListTile(
            leading: _buildListLeading(
                index: index, orderType: dataList[index].orderType),
            title: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: _buildListTitle(order: dataList[index], index: index),
                )),
            subtitle: SizedBox(
                width: double.infinity,
                child: _buildListSubtitle(
                    recipientName: "${dataList[index].recipientName}",
                    recipientAddress:
                        "${dataList[index].recipientAddress}, ${dataList[index].recipientPostcode} ${dataList[index].recipientCity},${dataList[index].recipientState}, Malaysia",
                    index: index)),
            isThreeLine: true,
            trailing: _buildOrderMoreButton(context, index, dataList[index])),
      ),
    );
  }

  RichText _buildListLeading({int index, String orderType}) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "#${index + 1} \n",
        style: TextStyle(
            color: createMaterialColor(Color(0xFF424B57)), fontSize: 20.0),
        children: <TextSpan>[
          TextSpan(
              text: orderType, style: Theme.of(context).textTheme.bodyText1)
        ],
      ),
    );
  }

  RichText _buildListTitle({int index, ShippingOrderModel order}) {
    String status;
    Color color;
    if (order.isPickedUp) {
      status = order.orderStatus;
    } else {
      status = order.pickupOrderStatus;
    }

    if (status == RouteStatusConstant.COMPLETED) {
      color = Colors.green;
    } else if (status == RouteStatusConstant.IN_PROGRESS) {
      color = Colors.blueAccent;
    } else if (status == RouteStatusConstant.FAILED) {
      color = Colors.red;
    } else if (status == RouteStatusConstant.PENDING) {
      color = Colors.orange;
    } else if (status == RouteStatusConstant.PICKED_UP) {
      color = Colors.lime;
    } else {
      color = Colors.grey;
    }

    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: "${order.trackingNo} \n",
        style: Theme.of(context).textTheme.bodyText1,
        children: <TextSpan>[
          TextSpan(
              text: "${dateFormat.format(order.createdAt)}\n",
              style: Theme.of(context).textTheme.bodyText1),
          TextSpan(
              text: status,
              style: TextStyle(color: color, fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  Text _buildListSubtitle(
      {String recipientName, String recipientAddress, int index}) {
    return Text(
      ("$recipientName \n$recipientAddress"),
      style: Theme.of(context).textTheme.bodyText2,
      textAlign: TextAlign.left,
    );
  }

  PopupMenuButton _buildOrderMoreButton(
      BuildContext context, int index, ShippingOrderModel selectedOrder) {
    return PopupMenuButton(
      elevation: 3.2,
      onSelected: (selectedChoice) =>
          selectedChoices(selectedChoice, selectedOrder),
      onCanceled: () {},
      itemBuilder: (BuildContext context) {
        return actionList.map((String choice) {
          return PopupMenuItem(
            value: choice,
            child: Text(
              choice,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          );
        }).toList();
      },
    );
  }
}
