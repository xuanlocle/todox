import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todox/model/todo_model.dart';
import 'package:todox/sceen/landing/tab_base.dart';

class TabOverview extends TabBase {
  TabOverview(Box<TodoModel> box, Function onTapListener, streamSelectingState, onTapSelectAllListener,
      onTapActionListener)
      : super('TODO LIST', Colors.blue, box, onTapListener, streamSelectingState, onTapSelectAllListener, onTapActionListener);

  @override
  Widget? buildTrailingText(int key) {
    if (box.get(key) == null) {
      return null;
    } else {
      if (box.get(key)!.isCompleted) {
        return Text('Completed', style: TextStyle(color: Colors.green));
      }
      return Text('Incomplete', style: TextStyle(color: Colors.orange));
    }
  }

  @override
  List<int> getKeys(Box boxValue) {
    return boxValue.keys.cast<int>().toList();
  }
}
