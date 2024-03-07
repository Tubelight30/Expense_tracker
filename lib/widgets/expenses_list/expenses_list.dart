import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense) onRemoveExpense;
  const ExpensesList({
    Key? key,
    required this.expenses,
    required this.onRemoveExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Dismissible(
            background: Container(
              color: Theme.of(context).colorScheme.error,
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              ),
            ),
            key: ValueKey(expenses[index]),
            onDismissed: (direction) {
              onRemoveExpense(expenses[index]);
            },
            child: ExpenseItem(expense: expenses[index]));
      },
      itemCount: expenses.length,
    );
  }
}
