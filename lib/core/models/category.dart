import 'package:flutter/material.dart';

/// Category model for product classification.
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
}
