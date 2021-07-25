import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todox/common/constants.dart';
import 'package:todox/model/todo_model.dart';
import 'package:todox/sceen/landing/tab_base.dart';
import '../../common/sliver_item.dart';
import '../../widget/lscroll_widget.dart';
import '../../widget/todo_appbar.dart';

class TabPlanning extends TabBase {
  TabPlanning(Box<TodoModel> box, Function onTapListener, streamSelectingState,
      onTapSelectAllListener, onTapActionListener)
      : super('INCOMPLETE', Colors.orange, box, onTapListener,
            streamSelectingState, onTapSelectAllListener, onTapActionListener);

  @override
  List<int> getKeys(Box<TodoModel> boxValue) {
    return boxValue.keys
        .cast<int>()
        .where((element) => boxValue.get(element)!.isCompleted == false)
        .toList();
  }
}
