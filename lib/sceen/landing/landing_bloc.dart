import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todox/common/constants.dart';
import 'package:todox/model/todo_model.dart';

class LandingBloc {
  late PageController _pageViewController;
  late Box<TodoModel> todoBox;

  late StreamController<List<int>> _streamSelectingStateController;

  Stream<List<int>> get streamSelectingState =>
      _streamSelectingStateController.stream;
  late List<int> selectedKeys;

  late StreamController<List<int>> _streamSelectingStateControllerPlan;

  Stream<List<int>> get streamSelectingStatePlan =>
      _streamSelectingStateControllerPlan.stream;
  late List<int> selectedKeysPlan;

  late StreamController<List<int>> _streamSelectingStateControllerDone;

  Stream<List<int>> get streamSelectingStateDone =>
      _streamSelectingStateControllerDone.stream;
  late List<int> selectedKeysDone;

  PageController get pageViewController => _pageViewController;

  LandingBloc() {
    selectedKeys = [];
    selectedKeysPlan = [];
    selectedKeysDone = [];
    _streamSelectingStateController = BehaviorSubject.seeded(selectedKeys);
    _streamSelectingStateControllerPlan =
        BehaviorSubject.seeded(selectedKeysPlan);
    _streamSelectingStateControllerDone =
        BehaviorSubject.seeded(selectedKeysDone);
    _pageViewController = new PageController(initialPage: 0, keepPage: true);
    todoBox = Hive.box<TodoModel>(Constants.TODO_BOX_NAME);
  }

  init() {}

  dispose() {
    _streamSelectingStateController.close();
    _streamSelectingStateControllerPlan.close();
    _streamSelectingStateControllerDone.close();
    _pageViewController.dispose();
    todoBox.close();
  }

  void bottomNavigationChange(int currentIndex, int newIndex) {
    if ((currentIndex - newIndex).abs() == 1) {
      pageViewController.animateToPage(newIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      pageViewController.jumpToPage(newIndex);
    }
  }

  Future<void> insertTodoToBox(TodoModel todo) async {
    await todoBox.add(todo);
  }

  void updateTodoToBox(int key, TodoModel todo) {
    todoBox.put(
        key,
        TodoModel(
            todoName: todo.todoName,
            todoDetails: todo.todoDetails,
            isCompleted: !todo.isCompleted));
  }

  void selectTodoLine(int key, Screen screen) {
    final listSelected = getListSelectedByScreen(screen);

    int indexOfKey = listSelected.indexOf(key);

    if (indexOfKey > -1)
      listSelected.remove(key);
    else
      listSelected.add(key);
    notifySelectedStreamByScreen(screen);
  }

  void selectAllLine(List<int> keys, Screen screen) {
    final listSelected = getListSelectedByScreen(screen);

    if (listSelected.length == keys.length) {
      listSelected.clear();
      //unselect all
      notifySelectedStreamByScreen(screen);
      return;
    }

    keys.forEach((key) {
      int indexOfKey = listSelected.indexOf(key);
      if (indexOfKey == -1) listSelected.add(key);
    });
    notifySelectedStreamByScreen(screen);
  }

  Future<void> markAllCompleted(Screen screen) async {
    Map<int, TodoModel> mapKeyTodoModel = {};
    final list = getListSelectedByScreen(screen);
    list.forEach((key) {
      var oldToDoModel = todoBox.get(key)!;
      TodoModel newToDoModel = TodoModel(
          todoName: oldToDoModel.todoName,
          todoDetails: oldToDoModel.todoDetails,
          isCompleted: true);
      mapKeyTodoModel[key] = newToDoModel;
    });
    await todoBox.putAll(mapKeyTodoModel);
    list.clear();
    notifySelectedStreamByScreen(screen);
  }

  Future<void> markAllIncomplete(Screen screen) async {
    Map<int, TodoModel> mapKeyTodoModel = {};
    final list = getListSelectedByScreen(screen);

    list.forEach((key) {
      var oldToDoModel = todoBox.get(key)!;
      TodoModel newToDoModel = TodoModel(
          todoName: oldToDoModel.todoName,
          todoDetails: oldToDoModel.todoDetails,
          isCompleted: false);
      mapKeyTodoModel[key] = newToDoModel;
    });
    list.clear();
    notifySelectedStreamByScreen(screen);
    await todoBox.putAll(mapKeyTodoModel);
  }

  Future<void> removeSelected(Screen screen) async {
    final list = getListSelectedByScreen(screen);
    list.forEach((key) {
      todoBox.delete(key);
    });

    list.clear();
    notifySelectedStreamByScreen(screen);
  }

  void notifySelectedStreamByScreen(Screen screen) {
    late final StreamController stream;
    late final listSelected;
    switch (screen) {
      case Screen.PLAN:
        listSelected = selectedKeysPlan;
        stream = _streamSelectingStateControllerPlan;
        break;
      case Screen.DONE:
        listSelected = selectedKeysDone;
        stream = _streamSelectingStateControllerDone;
        break;
      case Screen.OVERVIEW:
      default:
        listSelected = selectedKeys;
        stream = _streamSelectingStateController;
        break;
    }
    stream.sink.add(listSelected);
  }

  List<int> getListSelectedByScreen(Screen screen) {
    switch (screen) {
      case Screen.PLAN:
        return selectedKeysPlan;
      case Screen.DONE:
        return selectedKeysDone;
      case Screen.OVERVIEW:
      default:
        return selectedKeys;
    }
  }
}

enum Screen { OVERVIEW, PLAN, DONE }
