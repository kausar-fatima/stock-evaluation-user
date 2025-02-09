import 'package:stock_management/headers.dart';

void main() {
  runApp(const StockManagementApp());
}

class StockManagementApp extends StatelessWidget {
  const StockManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    //If the design is based on the size of the 360*690(dp)
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return SafeArea(
      child: GetMaterialApp(
        initialRoute: MyGet.inital_,
        getPages: MyGet.pages(),
      ),
    );
  }
}
