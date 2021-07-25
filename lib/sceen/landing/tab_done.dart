import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todox/model/todo_model.dart';
import 'tab_base.dart';

class TabDone extends TabBase {
  TabDone(Box<TodoModel> box, Function onTapListener, streamSelectingState,
      onTapSelectAllListener, onTapActionListener)
      : super('COMPLETED', Colors.green, box, onTapListener,
            streamSelectingState, onTapSelectAllListener, onTapActionListener);

  @override
  List<int> getKeys(Box<TodoModel> boxValue) {
    return boxValue.keys
        .cast<int>()
        .where((element) => boxValue.get(element)!.isCompleted == true)
        .toList();
  }
}
