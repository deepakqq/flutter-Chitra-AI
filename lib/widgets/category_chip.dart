import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? scheme.primary.withOpacity(0.15) : scheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outline.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? scheme.primary : null,
          ),
        ),
      ),
    );
  }
}
