import 'package:flutter/cupertino.dart';
import 'package:stock_management/headers.dart';

class ShopDetailsBody extends StatefulWidget {
  @override
  _ShopDetailsBodyState createState() => _ShopDetailsBodyState();
}

class _ShopDetailsBodyState extends State<ShopDetailsBody> {
  final DetailsController detailsController = Get.find<DetailsController>();
  late String shopId;

  @override
  void initState() {
    super.initState();
    shopId = Get.arguments['shopId'];

    _fetchShopProductsDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchShopProductsDetails(); // Refetch data when dependencies change
  }

  Future<void> _fetchShopProductsDetails() async {
    try {
      detailsController.isLoading.value = true;
      await detailsController.fetchShopProducts(shopId);
      detailsController.isLoading.value = false;
      debugPrint("-----------SHOP DETAILS-----------");
      for (var detail in detailsController.shopproducts) {
        debugPrint(
            '-----fetch product detail response: -----${detail.purchasedProducts}-----${detail.saleOutProducts}-----${detail.expenses}------${detail.revenue}-----${detail.profit}-----${detail.loss}---------');
      }
    } catch (e) {
      debugPrint('Failed to fetch shop products details: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Details'),
        backgroundColor: primaryColor, // Primary color
      ),
      body: Obx(() {
        if (detailsController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (detailsController.shopproducts.isEmpty) {
          return Center(child: Text('No shop details available'));
        }

        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: 'Shop Details Bar Chart',
                    textStyle: TextStyle(
                      color: Colors.black, // Chart title color
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  legend: Legend(isVisible: false),
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(
                      text: 'Values',
                      textStyle: TextStyle(
                        color: Colors.black, // Y-axis title color
                      ),
                    ),
                  ),
                  series: <CartesianSeries>[
                    BarSeries<ShopProductDetails, String>(
                      dataSource: detailsController.shopproducts,
                      xValueMapper: (ShopProductDetails details, _) =>
                          "Purchased",
                      yValueMapper: (ShopProductDetails details, _) =>
                          details.purchasedProducts,
                      name: 'Purchased Products',
                      color: Color.fromARGB(255, 10, 185, 161), // Bar color
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.top,
                        borderRadius: BorderSide.strokeAlignCenter,
                      ),
                    ),
                    BarSeries<ShopProductDetails, String>(
                      dataSource: detailsController.shopproducts,
                      xValueMapper: (ShopProductDetails details, _) =>
                          "Saleout",
                      yValueMapper: (ShopProductDetails details, _) =>
                          details.saleOutProducts,
                      name: 'Saleout Products',
                      color: Colors.blue, // Bar color
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                    BarSeries<ShopProductDetails, String>(
                      dataSource: detailsController.shopproducts,
                      xValueMapper: (ShopProductDetails details, _) =>
                          "Expenses",
                      yValueMapper: (ShopProductDetails details, _) =>
                          details.expenses,
                      name: 'Expenses',
                      color: Colors.purple, // Bar color
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                    BarSeries<ShopProductDetails, String>(
                      dataSource: detailsController.shopproducts,
                      xValueMapper: (ShopProductDetails details, _) =>
                          "Revenue",
                      yValueMapper: (ShopProductDetails details, _) =>
                          details.revenue,
                      name: 'Revenue',
                      color: Colors.orange, // Bar color
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                    BarSeries<ShopProductDetails, String>(
                      dataSource: detailsController.shopproducts,
                      xValueMapper: (ShopProductDetails details, _) => "Profit",
                      yValueMapper: (ShopProductDetails details, _) =>
                          details.profit,
                      name: 'Profit',
                      color: Colors.green, // Bar color
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                    BarSeries<ShopProductDetails, String>(
                      dataSource: detailsController.shopproducts,
                      xValueMapper: (ShopProductDetails details, _) => "Loss",
                      yValueMapper: (ShopProductDetails details, _) =>
                          details.loss,
                      name: 'Loss',
                      color: Colors.red, // Bar color
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: detailsController.shopproducts.length,
                      itemBuilder: (context, index) {
                        final detail = detailsController.shopproducts[index];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Details for ${detail.id}",
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 10, 185, 161), // Primary color
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: Text("Purchased Products"),
                                      onTap: () {
                                        Get.toNamed(MyGet.purchasedProducts,
                                            arguments: {
                                              'shopId': detailsController
                                                  .shopproducts[index].id,
                                            });
                                      },
                                    ),
                                    Spacer(),
                                    Text("Rs ${detail.purchasedProducts}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: Text("Saleout Products"),
                                      onTap: () {
                                        Get.toNamed(MyGet.saleoutProducts,
                                            arguments: {
                                              'shopId': detailsController
                                                  .shopproducts[index].id,
                                            });
                                      },
                                    ),
                                    Spacer(),
                                    Text("Rs ${detail.saleOutProducts}"),
                                  ],
                                ),
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Text("Expenses"),
                                      Spacer(),
                                      Text("Rs ${detail.expenses}"),
                                    ],
                                  ),
                                  onTap: () {
                                    Get.toNamed(MyGet.expenses, arguments: {
                                      'shopId': detailsController
                                          .shopproducts[index].id,
                                    });
                                  },
                                ),
                                Row(
                                  children: [
                                    Text("Revenue"),
                                    Spacer(),
                                    Text("Rs ${detail.revenue}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Profit"),
                                    Spacer(),
                                    Text("Rs ${detail.profit}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Loss"),
                                    Spacer(),
                                    Text("Rs ${detail.loss}"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
