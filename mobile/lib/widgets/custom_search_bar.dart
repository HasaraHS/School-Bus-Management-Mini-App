import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String selectedValue;
  final List<String> items;
  final Function(String?)? onChanged;

  const CustomSearchBar({
    Key? key,
    required this.selectedValue,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 20, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(item),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          icon: const SizedBox.shrink(), 
        ),
      ),
    );
  }
}