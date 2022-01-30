import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/models.dart';
import 'grocery_item_screen.dart';

class GroceryListScreen extends StatelessWidget {
  final GroceryManager groceryManager;

  const GroceryListScreen({
    Key? key,
    required this.groceryManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO 26: Replace with ListView
    return Container();
  }
}
