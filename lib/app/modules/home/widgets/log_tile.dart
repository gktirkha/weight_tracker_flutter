import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../controllers/home_controller.dart';
import '../detail_tile.dart';
import '../models/weight_track_model/weight_track_model.dart';

class LogTile extends GetView<HomeController> {
  const LogTile({super.key, required this.item, this.showActions = true});

  final WeightEntry item;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height(),
              Text(item.date.format(), style: TextStyle(fontSize: 16)),
              8.height(),
              DetailTile(
                useRow: false,
                label: 'Weight',
                value: item.weight?.toPrecision(2) ?? 'N/A',
              ),
              DetailTile(
                useRow: false,
                label: 'Note',
                value: item.notes ?? 'N/A',
              ),
              8.height(),
            ],
          ),
        ),
        if (showActions)
          IconButton(
            onPressed: () {
              controller.onDeleteItem(item);
            },
            icon: Icon(Icons.delete),
          ),
        if (showActions) 32.width(),
        if (showActions)
          IconButton(
            onPressed: () {
              controller.onEditItem(item);
            },
            icon: Icon(Icons.edit),
          ),
      ],
    );
  }
}
