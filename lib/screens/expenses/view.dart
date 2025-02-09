import 'package:stock_management/headers.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final ExpensesController expenseController = Get.put(ExpensesController());
  final isError = false.obs;
  late String shopId;

  @override
  void initState() {
    super.initState();
    shopId = Get.arguments['shopId']; // Initialize shopId from arguments
    _init();
  }

  _init() async {
    isError.value = false;
    final isSuccess = await expenseController.fetchExpenses(shopId);
    if (!isSuccess) {
      isError.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: Obx(() {
        if (expenseController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (isError.value) {
          return Center(
            child: ElevatedButton(
              onPressed: _init,
              child: const Text("Retry"),
            ),
          );
        } else if (expenseController.expenses.isEmpty) {
          return const Center(
            child: Text('No expenses found.'),
          );
        } else {
          return ListView.builder(
            itemCount: expenseController.expenses.length,
            itemBuilder: (context, index) {
              final expense = expenseController.expenses[index];
              return ListTile(
                title: Text('Name: ${expense.name}'),
                subtitle:
                    Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showEditExpenseDialog(context, expense),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => expenseController.deleteexpense(expense),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _AddExpenseForm(
          addExpense: expenseController.addExpense,
          fetchExpenses: () => expenseController.fetchExpenses(shopId),
          shopId: shopId,
        );
      },
    );
  }

  void _showEditExpenseDialog(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _EditExpenseForm(
          editExpense: expenseController.updateexpense,
          fetchExpenses: () => expenseController.fetchExpenses(shopId),
          shopId: shopId,
          expense: expense,
        );
      },
    );
  }
}

class _AddExpenseForm extends StatefulWidget {
  final FutureOr<void> Function(Expense) addExpense;
  final Future<void> Function() fetchExpenses;
  final String shopId;

  const _AddExpenseForm({
    Key? key,
    required this.addExpense,
    required this.fetchExpenses,
    required this.shopId,
  }) : super(key: key);

  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<_AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final nameTEC = TextEditingController();
  final amountTEC = TextEditingController();

  Future<void> onAdd() async {
    if (_formKey.currentState!.validate()) {
      try {
        double amount = double.tryParse(amountTEC.text) ?? 0.0;

        await widget.addExpense(
          Expense(
            id: UniqueKey().toString(),
            shopId: widget.shopId,
            name: nameTEC.text,
            amount: amount,
          ),
        );
        await widget.fetchExpenses();
        Navigator.of(context).pop();
      } catch (e) {
        debugPrint("Error occurred: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameTEC,
                decoration: const InputDecoration(labelText: 'Expense Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an expense name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: amountTEC,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _EditExpenseForm extends StatefulWidget {
  final FutureOr<void> Function(Expense) editExpense;
  final Future<void> Function() fetchExpenses;
  final String shopId;
  final Expense expense;

  const _EditExpenseForm({
    Key? key,
    required this.editExpense,
    required this.fetchExpenses,
    required this.shopId,
    required this.expense,
  }) : super(key: key);

  @override
  _EditExpenseFormState createState() => _EditExpenseFormState();
}

class _EditExpenseFormState extends State<_EditExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameTEC;
  late TextEditingController amountTEC;

  @override
  void initState() {
    super.initState();
    nameTEC = TextEditingController(text: widget.expense.name);
    amountTEC = TextEditingController(text: widget.expense.amount.toString());
  }

  Future<void> onEdit() async {
    if (_formKey.currentState!.validate()) {
      try {
        double amount = double.tryParse(amountTEC.text) ?? 0.0;

        await widget.editExpense(
          Expense(
            id: widget.expense.id,
            shopId: widget.shopId,
            name: nameTEC.text,
            amount: amount,
          ),
        );
        await widget.fetchExpenses();
        Navigator.of(context).pop();
      } catch (e) {
        debugPrint("Error occurred: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Expense'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameTEC,
                decoration: const InputDecoration(labelText: 'Expense Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an expense name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: amountTEC,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onEdit,
          child: const Text('Edit'),
        ),
      ],
    );
  }
}
