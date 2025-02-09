// ignore_for_file: prefer_const_constructors

import './headers.dart';
//import 'package:navigation_ecommerce/headers.dart';

class MyGet {
  static const bool isFirstTime = true;
  static const bool isLogedIn =
      false; // if you set as true.. it will direct move to home screen instead of login

  // ADD ALL UNIQUE NAMES FOR ALL PAGES OF YOUR APP
  static const String onboarding = '/oboarding';
  static const String login = '/login';
  static const String singup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String otpCode = '/otpCode';
  static const String home = '/home';
  static const String shopdetails = '/shopdetails';
  static const String mapdetails = '/mapdetails';
  static const String purchasedProducts = '/purchasedproducts';
  static const String saleoutProducts = '/saleoutproducts';
  static const String expenses = '/expenses';

  static const String inital_ = onboarding;

  static List<GetPage> pages() => [
        // ADD PAGES oF your app only one time
        // GetPage(
        //   name: // Use this value to Open Screen using Get.toNamed/Get.offAllNamed etc
        //   page: () => // YOU WIDGET WHEN THIS PAGE IS OPEN ,
        //   binding: Page1Binding(), // used to initialize controller . that can be used in screen using Get.fin<ControllerName>();
        // ),

        GetPage(
          name: onboarding,
          page: () => const onboardingBody(),
          binding: onBoardingBinding(),
        ),
        GetPage(
          name: login,
          page: () => const LoginBody(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: singup,
          page: () => const SignUpBody(),
          binding: SignupBinding(),
        ),
        GetPage(
          name: forgotPassword,
          page: () => const ForgotPassBody(),
          binding: ForgotPassBinding(),
        ),
        GetPage(
          name: otpCode,
          page: () => const OTPBody(),
          binding: OTPBinding(),
        ),
        GetPage(
          name: home,
          page: () => HomeBody(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: shopdetails,
          page: () => ShopDetailsBody(),
          binding: ShopProductDetailsBinding(),
        ),
        GetPage(
          name: mapdetails,
          page: () => MapView(),
          //binding: HomeBinding(),
        ),
        GetPage(
          name: purchasedProducts,
          page: () => ProductPage(),
          binding: PurchaseProductBinding(),
        ),
        GetPage(
          name: saleoutProducts,
          page: () => SaleOutProductPage(),
          binding: SaleOutProductBinding(),
        ),
        GetPage(
          name: expenses,
          page: () => ExpensePage(),
          binding: ExpensesBinding(),
        ),
      ];
}
