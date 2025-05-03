import 'package:flutter/material.dart';

class DetailTile extends StatelessWidget {
  const DetailTile({
    super.key,
    required this.label,
    required this.value,
    this.useRow = true,
  });
  final String label;
  final dynamic value;
  final bool useRow;

  @override
  Widget build(BuildContext context) {
    if (useRow) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(child: Text('$label:')),
          Expanded(child: Text('${value?.toString()}')),
        ],
      );
    }
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.white),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(text: value?.toString()),
        ],
      ),
    );
  }
}
