import 'package:flutter/material.dart';
import '../../model/todo_model.dart';
import 'tab_done.dart';
import 'tab_overview.dart';
import 'tab_planning.dart';

import 'landing_bloc.dart';

class LandingScreen extends StatefulWidget {
  static final route = '/';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LandingBloc _businessLogic = LandingBloc();
  int currentIndex = 0;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _businessLogic.init();
  }

  @override
  void dispose() {
    _businessLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: buildBottom(),
        body: buildBody(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (b) => Dialog(
                      child: Container(
                          padding: EdgeInsets.all(16),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: <
                                  Widget>[
                            Center(
                              child: Text(
                                'Add new',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextField(
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(hintText: "Title"),
                                controller: titleController),
                            SizedBox(height: 8),
                            TextField(
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(hintText: "Detail"),
                                controller: detailController),
                            SizedBox(height: 8),
                            InkResponse(
                                child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 32.0),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                        child: Text("Add Todo",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white))),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)))),
                                onTap: () {
                                  final String title = titleController.text;
                                  final String detail = detailController.text;

                                  TodoModel todo = TodoModel(
                                      todoName: title,
                                      todoDetails: detail,
                                      isCompleted: false);

                                  _businessLogic
                                      .insertTodoToBox(todo)
                                      .then((value) {
                                    titleController.clear();
                                    detailController.clear();
                                    Navigator.pop(context);
                                  });
                                })
                          ]))));
            },
            child: Icon(Icons.add)));
  }

  buildBody() => PageView(
          scrollDirection: Axis.horizontal,
          controller: _businessLogic.pageViewController,
          onPageChanged: (newPosition) {
            setState(() {
              currentIndex = newPosition;
            });
          },
          children: [
            TabOverview(
                _businessLogic.todoBox,
                (key, currentTodoModel) {
                  _businessLogic.selectTodoLine(key, Screen.OVERVIEW);
                },
                _businessLogic.streamSelectingState,
                (keys) {
                  _businessLogic.selectAllLine(keys, Screen.OVERVIEW);
                },
                () {
                  showDialogOverviewAction(Screen.OVERVIEW);
                }),
            TabPlanning(
                _businessLogic.todoBox,
                (key, currentTodoModel) {
                  _businessLogic.selectTodoLine(key, Screen.PLAN);
                },
                _businessLogic.streamSelectingStatePlan,
                (keys) {
                  _businessLogic.selectAllLine(keys, Screen.PLAN);
                },
                () {
                  showDialogOverviewAction(Screen.PLAN);
                }),
            TabDone(
                _businessLogic.todoBox,
                (key, currentTodoModel) {
                  _businessLogic.selectTodoLine(key, Screen.DONE);
                },
                _businessLogic.streamSelectingStateDone,
                (keys) {
                  _businessLogic.selectAllLine(keys, Screen.DONE);
                },
                () {
                  showDialogOverviewAction(Screen.DONE);
                })
          ]);

  buildBottom() => BottomNavigationBar(
          onTap: (newPosition) =>
              _businessLogic.bottomNavigationChange(currentIndex, newPosition),
          currentIndex: currentIndex,
          elevation: 10.0,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'All'),
            BottomNavigationBarItem(
                icon: Icon(Icons.golf_course), label: 'Incomplete'),
            BottomNavigationBarItem(
                icon: Icon(Icons.next_plan), label: 'Completed')
          ]);

  void showDialogOverviewAction(Screen screen) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
            child: Container(
                padding: EdgeInsets.all(16),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Center(
                      child: Text('ACTION',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  ListTile(
                      title: Text('Mark as completed'),
                      onTap: () {
                        _businessLogic
                            .markAllCompleted(screen)
                            .then((value) => Navigator.pop(context));
                      }),
                  ListTile(
                      title: Text('Mark as incomplete'),
                      onTap: () {
                        _businessLogic
                            .markAllIncomplete(screen)
                            .then((value) => Navigator.pop(context));
                      }),
                  ListTile(
                      title: Text('Remove selected'),
                      onTap: () {
                        _businessLogic
                            .removeSelected(screen)
                            .then((value) => Navigator.pop(context));
                      }),
                  InkResponse(
                      child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 32.0),
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                              child: Text("CANCEL",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.grey)))),
                      onTap: () {
                        Navigator.pop(context);
                      })
                ]))));
  }
}
