import 'package:stock_management/headers.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final ShopDetailsController shopController =
      Get.find<ShopDetailsController>();
  //List<ShopDetails>? shopDetails; // Make it nullable

  @override
  void initState() {
    super.initState();
    shopController.fetchShops();
    // setState(() {
    //   shopDetails = shopController.shops;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shops Locations'),
        backgroundColor: primaryColor, // Primary color
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(MyGet.mapdetails);
              },
              child: Stack(
                children: [
                  Container(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter:
                            LatLng(Texts.from.latitude, Texts.from.longitude),
                        maxZoom: 10,
                      ),
                      children: [
                        RichAttributionWidget(
                          animationConfig:
                              const ScaleRAWA(), // Or `FadeRAWA` as is default
                          attributions: [
                            TextSourceAttribution(
                              'OpenStreetMap contributors',
                              onTap: () => launchUrl(Uri.parse(
                                  'https://openstreetmap.org/copyright')),
                            ),

                            /// @mohamadlounnas
                            TextSourceAttribution(
                              'Kausar Fatima',
                              onTap: () => launchUrl(Uri.parse(
                                  'mailto:kausarfatima1044@gmail.com')),
                            ),
                          ],
                        ),
                        TileLayer(
                          urlTemplate:
                              'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=${Texts.apiKey}',
                          additionalOptions: {
                            'apiKey': Texts.apiKey,
                            'lang': 'en', // Set language if needed
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.red, // Change the location icon color
                          size: 40, // Increase the size of the icon
                        ),
                        onPressed: () {
                          Get.toNamed(MyGet.mapdetails);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Color.fromARGB(255, 240, 240, 240), // Background color
              child: Obx(
                () {
                  if (shopController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (shopController.shops.isEmpty) {
                    return Center(child: Text('No shops available'));
                  } else {
                    return ListView.builder(
                      itemCount: shopController.shops.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Card(
                            color: primaryColor,
                            elevation: 4, // Add elevation for card effect
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15), // Rounded corners
                            ),
                            child: ListTile(
                              title: Text(
                                shopController.shops[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, // Bold text
                                ),
                              ),
                              subtitle:
                                  Text(shopController.shops[index].location),
                              onTap: () {
                                Get.toNamed(MyGet.shopdetails, arguments: {
                                  'shopId': shopController.shops[index].id
                                });
                              },
                              trailing:
                                  Icon(Icons.arrow_forward_ios), // Arrow icon
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddShopDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddShopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _From(
          userId: shopController.userId.value,
          addShop: shopController.addShops,
        );
      },
    );
  }
}

// form for getting entries
class _From extends StatefulWidget {
  const _From({
    super.key,
    required this.userId,
    required this.addShop,
  });

  final FutureOr<void> Function(ShopDetails) addShop;
  final String userId;

  @override
  State<_From> createState() => _FromState();
}

class _FromState extends State<_From> {
  final name = TextEditingController();
  final location = TextEditingController();

  Future<void> onAdd() async {
    try {
      var shopname = name.text;
      var shoplocation = location.text;

      await widget.addShop(
        ShopDetails(
          id: UniqueKey().toString(),
          userId: widget.userId,
          name: shopname,
          location: shoplocation,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      debugPrint("ERROR OCCURRED THAT CAN BE OR CANNOT BE IGNORED $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Shop'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Shop Name'),
            ),
            TextField(
              controller: location,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: onAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
