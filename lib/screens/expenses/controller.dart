import 'package:stock_management/headers.dart';

class ExpensesController extends GetxController {
  final expenses = <Expense>[].obs;

  var isLoading = true.obs; // Observable boolean to track loading state

  // Method to fetch expenses
  Future<bool> fetchExpenses(String shopId) async {
    // bool to make sure no error is occured
    isLoading.value = true;

    try {
      final res = await Api.fetchExpenses(
          shopId); // Call your static fetchexpenses method
      // Clear existing lists before updating
      expenses.clear();
      expenses.assignAll(res.toList());
      // Set loading state to false after fetching
      isLoading.value = false;
      return true;
    } catch (e) {
      debugPrint('----------Error fetching expenses-----------: $e');
      // Set loading state to false if an error occurs
      isLoading.value = false;
      return false;
    }
  }

  // Method to update expenses

  // Method to add a expense
  void addExpense(Expense expense) async {
    try {
      await Api.addExpense(expense); // Call your static addexpense method
      // Add the new expense to the observable lists
      expenses.add(expense);
    } catch (e) {
      debugPrint('Error adding expense: $e');
    }
  }

  // Method to edit a expense
  // Method to update a expense
  void updateexpense(Expense updatedexpense) async {
    try {
      // Find the index of the expense to be updated
      int index = expenses.indexWhere((expense) => (expense.id ==
          updatedexpense.id)); // Assuming 'id' is the unique identifier

      if (index != -1) {
        // If the expense is found, update its properties
        expenses[index].name = updatedexpense.name;
        expenses[index].amount = updatedexpense.amount;

        for (var expenses in expenses) {
          debugPrint(
              "_______ ${expenses.id} ___ ${expenses.name} ___ ${expenses.amount} _______");
        }
        // Call the API method or update the data source with the updated expense
        await Api.updateExpense(updatedexpense);
      } else {
        // Handle the case where the expense is not found
        debugPrint('expense not found for updating');
      }
    } catch (e) {
      debugPrint('Error updating expense: $e');
    }
  }

  //Method to delete a expense
  void deleteexpense(Expense expense) async {
    try {
      debugPrint('Deleting expense: ${expense.toJson()}');
      expenses.remove(expense);
      await Api.deleteExpense(expense);
    } catch (e) {
      debugPrint('Error deleting Saleout expense: $e');
    }
  }
}
