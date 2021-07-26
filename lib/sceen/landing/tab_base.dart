import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todox/common/sliver_item.dart';
import 'package:todox/model/todo_model.dart';
import 'package:todox/widget/lscroll_widget.dart';
import 'package:todox/widget/todo_appbar.dart';

abstract class TabBase extends StatelessWidget {
  final Box<TodoModel> box;
  final Function onTapListener;
  final Function onTapSelectAllListener;
  final Function onTapActionListener;
  final String title;
  final Color color;
  final Stream<List<int>> streamStateSelected;

  TabBase(
      this.title,
      this.color,
      this.box,
      this.onTapListener,
      this.streamStateSelected,
      this.onTapSelectAllListener,
      this.onTapActionListener);

  Widget buildAppBar() {
    return SliverAppBar(
        expandedHeight: 100.0,
        collapsedHeight: 60.0,
        pinned: true,
        floating: true,
        title: Text(title, style: TextStyle(color: color)),
        elevation: 10,
        backgroundColor: Colors.white,
        flexibleSpace: TodoAppBar(title, color));
  }

  Widget buildBottomAction(List<int>? listSelected) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedOpacity(
            opacity: (listSelected == null || listSelected.isEmpty) ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: InkResponse(
                onTap: () {
                  if (listSelected == null || listSelected.isEmpty) return;
                  onTapActionListener();
                },
                child: Container(
                    height: 56.0,
                    width: double.infinity,
                    child: Center(
                        child: Text('Choose Action',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0))),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.orange)))));
  }

  Widget? buildTrailingText(int key) {
    return null;
  }

  Widget? buildLeading(List<int>? listSelected, int key, TodoModel tm) {
    if (listSelected == null || listSelected.isEmpty) return null;
    bool isSelected = listSelected.indexOf(key) > -1;
    return Checkbox(
        value: isSelected,
        onChanged: (v) {
          onTapListener(key, tm);
        });
  }

  List<int> getKeys(Box<TodoModel> boxValue);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<TodoModel> boxValue, widget) {
          List<int> keys = getKeys(boxValue);
          return StreamBuilder<List<int>>(
              stream: streamStateSelected,
              builder: (_, AsyncSnapshot<List<int>> snapshot) =>
                  Stack(alignment: Alignment.topCenter, children: [
                    LScrollView(<Widget>[
                      buildAppBar(),
                      SliverItem(
                          child: ListTile(
                              tileColor: Colors.white,
                              onTap: () {
                                onTapSelectAllListener(keys);
                              },
                              leading: Checkbox(
                                  checkColor: Colors.white,
                                  onChanged: (bool? value) {
                                    onTapSelectAllListener(keys);
                                  },
                                  value: (snapshot.hasData &&
                                      (snapshot.data ?? []).length ==
                                          keys.length &&
                                      keys.length > 0)),
                              title: Text('Select All'))),
                      ...keys.map((key) {
                        TodoModel tm = boxValue.get(key)!;
                        return SliverItem(
                            child: ListTile(
                                onTap: () {
                                  onTapListener(key, tm);
                                },
                                trailing: buildTrailingText(key),
                                leading: buildLeading(
                                    snapshot.data ?? null, key, tm),
                                subtitle: Text('${tm.todoDetails}'),
                                title: Text('${tm.todoName}')));
                      }).toList(),
                      SliverPadding(padding: EdgeInsets.only(top: 60.0))
                    ]),
                    buildBottomAction(snapshot.data)
                  ]));
        });
  }
}
