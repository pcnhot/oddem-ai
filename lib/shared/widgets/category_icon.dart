import 'package:flutter/material.dart';

/// Resolves a category's `iconName` string to a Material [IconData], keeping
/// the data model free of UI dependencies.
IconData categoryIcon(String name) {
  switch (name) {
    case 'weekend':
      return Icons.weekend_outlined;
    case 'bed':
      return Icons.bed_outlined;
    case 'dining':
      return Icons.dining_outlined;
    case 'table_restaurant':
      return Icons.table_restaurant_outlined;
    case 'chair':
      return Icons.chair_outlined;
    case 'shelves':
      return Icons.shelves;
    case 'light':
      return Icons.light_outlined;
    case 'auto_awesome':
      return Icons.auto_awesome_outlined;
    default:
      return Icons.category_outlined;
  }
}
