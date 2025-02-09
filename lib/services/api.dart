import 'package:http/http.dart' as http;
import 'package:stock_management/headers.dart';

class Api {
  static const baseUrl = "http://192.168.0.103:3000/api";

  // Function to handle user login
  static void login(String email, String password) async {
    var url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      var data = json.decode(response.body);
      print("++++++++++++++++${response.body}+++++++++++++++");
      if (response.statusCode == 200) {
        // Login successful, navigate to home page
        print("++++++++++++++++Login Successful+++++++++++++++");
        final userId = data['userId'];

        // Save userId to SharedPreferences
        debugPrint("|||||||||||before saving:  ${userId}||||||||||||");
        await saveUserId(userId);
        debugPrint(
            "|||||||||||after saving:  ${await getUserId()}||||||||||||");
        Get.offAllNamed(MyGet.home);
      } else {
        // Login failed, show error message
        Get.snackbar(
          "Error",
          data['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: errorColor,
          colorText: secondaryColor,
        );
      }
    } catch (error) {
      debugPrint("Error logging in: $error");
    }
  }

  static Future<String> addUser(Map<String, String> uData, String email) async {
    debugPrint(uData.toString());

    // Stringify the data into JSON format
    var body = jsonEncode({
      'email': uData['email'],
      'password': uData['password'],
    });

    var url = Uri.parse("$baseUrl/register");

    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Specify content type as JSON
        },
        body: body,
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        debugPrint("Successfully user added: ${data.toString()}");
        Api.generateOTP(email);
        Get.toNamed(MyGet.otpCode);
        return 'User added';
      } else if (res.statusCode == 400) {
        var error = jsonDecode(res.body.toString());
        debugPrint("Failed to add user: ${error['message']}");
        Get.snackbar(
          "Error",
          "${error['message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: secondaryColor,
        );
        return error['message']; // Return error message from server
      } else {
        debugPrint("Failed to add user: ${res.statusCode}");
        return 'Failed to add user';
      }
    } catch (e) {
      debugPrint("Error adding user: $e");
      return 'Error adding user';
    }
  }

  static generateOTP(String email) async {
    var url = Uri.parse("$baseUrl/generate_otp");

    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Specify content type as JSON
        },
        body: jsonEncode({'email': email}),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        debugPrint("OTP generated successfully: ${data['otp']}");
      } else {
        debugPrint("Failed to generate OTP: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error generating OTP: $e");
    }
  }

  static void forgotPassword(String email, String newPassword) async {
    var url = Uri.parse("$baseUrl/forgot_password");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'newPassword': newPassword}),
      );

      // Parse the response
      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "updated",
          "Password changed successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: secondaryColor,
        );
        // Password changed successfully, navigate to login screen
        Get.toNamed(MyGet.login);
      } else {
        // Handle error, show appropriate message
        Get.snackbar(
          "Error",
          data['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: errorColor,
          colorText: secondaryColor,
        );
      }
    } catch (error) {
      debugPrint("Error changing password: $error");
      // Handle error
    }
  }

  static verifyOTP(String enteredOTP, String userEmail) async {
    try {
      // Debug statements for checking the input values
      debugPrint(".......UserEmail:  $userEmail");
      debugPrint(".......UserOTP:  $enteredOTP");

      var response = await http.post(
        Uri.parse('$baseUrl/verify_otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': userEmail, 'otp': enteredOTP}),
      );

      // Check the status code and response body
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Verify the presence of the message field
        if (data['message'] != null) {
          // OTP verified successfully
          Get.toNamed(MyGet.login);
        } else {
          // Handle unexpected response structure
          Get.snackbar(
            "Error",
            "Unexpected response format",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: errorColor,
            colorText: secondaryColor,
          );
        }
      } else {
        // Handle server error response
        var data = json.decode(response.body);
        debugPrint(data);
        // Ensure the message field exists in the error response
        String errorMessage = data['message'] ?? 'Unknown error occurred';
        Get.snackbar(
          "Error",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: errorColor,
          colorText: secondaryColor,
        );
      }
    } catch (error) {
      debugPrint("Error verifying OTP: $error");
      // Handle error
      Get.snackbar(
        "Error",
        "An error occurred while verifying OTP",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: errorColor,
        colorText: secondaryColor,
      );
    }
  }

  static Future<List<ShopDetails>> getShopDetails(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/$userId/get_shopDetails'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        final List<ShopDetails> shopDetailsList =
            data.map((json) => ShopDetails.fromJson(json)).toList();

        // Extract shop IDs and store them in SharedPreferences
        final List<String> shopIds =
            shopDetailsList.map((shop) => shop.id).toList();
        await saveShopIds(shopIds);
        return shopDetailsList;
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to parse shop details');
      }
    } else {
      print(
          'Failed to load shop details. Status code: ${response.statusCode}, Response body: ${response.body}');
      throw Exception('Failed to load shop details');
    }
  }

  static Future<void> addShopProductDetails(
      ShopProductDetails detail, String id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update_shopProductsDetails/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(detail.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add Shop product detail');
      } else {
        debugPrint('Shop product detail added successfully');
      }
    } catch (e) {
      debugPrint('Error adding Shop product detail: $e');
    }
  }

  static Future<ShopProductDetails> getShopProductDetails(String shopId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/user/$shopId/get_shopProductDetails'));

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        final ShopProductDetails shopDetails =
            ShopProductDetails.fromJson(data);
        debugPrint(
            "..........Fetched products details:  ${shopDetails.purchasedProducts} ..... ${shopDetails.saleOutProducts} ..... ${shopDetails.expenses} ..... ${shopDetails.revenue} ..... ${shopDetails.profit} ..... ${shopDetails.loss} ...............");
        return shopDetails;
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to parse shop products details');
      }
    } else {
      print(
          'Failed to load shop product details. Status code: ${response.statusCode}, Response body: ${response.body}');
      throw Exception('Failed to load shop products details');
    }
  }

  static Future<ShopDetails> addShopDetails(ShopDetails shopDetails) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_shopDetails'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(shopDetails.toJson()),
    );
    if (response.statusCode == 200) {
      return ShopDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add shop details');
    }
  }

  // Method to add a shop to a user
  static Future<void> addShopToUser(String userId, String shopId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/$userId/addShop'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'shopId': shopId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add shop to user');
    }
  }

  static Future<List<Product>> fetchProducts(String shopId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/get_products/$shopId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      debugPrint('Error fetching purchased products from server: $e');
      return [];
    }
  }

  static Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }

  static Future<void> updateProduct(Product product) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/update_purchasedproducts/${product.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product.toJson()),
      );

      debugPrint(
          "**********${response.body} AND ${response.statusCode}**********");

      if (response.statusCode != 200) {
        throw Exception('Failed to update Purchased product');
      } else {
        debugPrint('Success updating Purchased product');
      }
    } catch (e) {
      debugPrint('Error updating Purchased product: $e');
    }
  }

  static Future<void> deleteProduct(Product product) async {
    try {
      final url = '$baseUrl/delete_purchasedproducts/${product.id}';
      debugPrint('Deleting product at URL: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      debugPrint(
          "**********${response.body} AND ${response.statusCode}**********");
      if (response.statusCode != 200) {
        throw Exception('Failed to delete Purchased product');
      } else {
        debugPrint('Success deleting Purchased product');
      }
    } catch (e) {
      debugPrint('Error deleting Purchased product: $e');
    }
  }

  static Future<List<Expense>> fetchExpenses(String shopId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/get_expenses/$shopId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Expense.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch expenses');
      }
    } catch (e) {
      debugPrint('Error fetching expenses from server: $e');
      return [];
    }
  }

  static Future<void> addExpense(Expense expense) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_expenses'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(expense.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add expense');
      }
    } catch (e) {
      debugPrint('Error adding expense: $e');
    }
  }

  static Future<void> updateExpense(Expense expense) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/update_expenses/${expense.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(expense.toJson()),
      );

      debugPrint(
          "**********${response.body} AND ${response.statusCode}**********");

      if (response.statusCode != 200) {
        throw Exception('Failed to update Expense');
      } else {
        debugPrint('Success updating Expense');
      }
    } catch (e) {
      debugPrint('Error updating Expense: $e');
    }
  }

  static Future<void> deleteExpense(Expense expense) async {
    try {
      final url = '$baseUrl/delete_expenses/${expense.id}';
      debugPrint('Deleting expense at URL: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      debugPrint(
          "**********${response.body} AND ${response.statusCode}**********");
      if (response.statusCode != 200) {
        throw Exception('Failed to delete Expense');
      } else {
        debugPrint('Success deleting Expense');
      }
    } catch (e) {
      debugPrint('Error deleting Expense: $e');
    }
  }

  static Future<List<SaleOutProduct>> fetchSaleOutProducts(
      String shopId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/get_saleoutproducts/$shopId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => SaleOutProduct.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch Sale out products');
      }
    } catch (e) {
      debugPrint('Error fetching Sale out products: $e');
      return [];
    }
  }

  static Future<void> addSaleOutProduct(
      SaleOutProduct product, String id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_saleoutproducts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add Sale out product');
      }
    } catch (e) {
      debugPrint('Error adding Sale out product: $e');
    }
  }

  static Future<void> updateSaleOutProduct(SaleOutProduct product) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/update_saleoutproducts/${product.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product.toJson()),
      );

      debugPrint(
          "**********${response.body} AND ${response.statusCode}**********");

      if (response.statusCode != 200) {
        throw Exception('Failed to update Sale out product');
      } else {
        debugPrint('Success updating Sale out product');
      }
    } catch (e) {
      debugPrint('Error updating Sale out product: $e');
    }
  }

  static Future<void> deleteSaleOutProduct(SaleOutProduct product) async {
    try {
      final url = '$baseUrl/delete_saleoutproducts/${product.id}';
      debugPrint('Deleting product at URL: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      debugPrint(
          "**********${response.body} AND ${response.statusCode}**********");
      if (response.statusCode != 200) {
        throw Exception('Failed to delete Sale out product');
      } else {
        debugPrint('Success deleting Sale out product');
      }
    } catch (e) {
      debugPrint('Error deleting Sale out product: $e');
    }
  }
}
