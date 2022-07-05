import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focus/data/database_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:focus/widgets/emptylist.dart';

class TodoTiles extends StatefulWidget {
  final Color backgroundColor;
  final bool searchOrShowOld;
  final TodoData todoData;

  const TodoTiles(
      {Key? key,
      required this.backgroundColor,
      required this.searchOrShowOld,
      required this.todoData})
      : super(key: key);

  @override
  State<TodoTiles> createState() => _TodoTilesState();
}

class _TodoTilesState extends State<TodoTiles> {
  final dataRepo = DatabaseRepository(DatabaseProvider.get);
  bool isDone = false;
  final _textController = TextEditingController();
  List<Map> datatoShow = [];

  void showEditDialog(int id, String task, int isCompleted) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: CupertinoActionSheet(
            title: const Text("Edit Task"),
            message: CupertinoTextField(
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.bodyText1!.color),
              placeholder: "Type your task",
              controller: _textController,
            ),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('Edit'),
                onPressed: () {
                  String taskInput = _textController.value.text;

                  _editTask(id, taskInput, isCompleted);
                  Navigator.pop(context);
                  _textController.clear();
                  setState(() {});
                },
              ),
            ],
            cancelButton: CupertinoButton(
              child: const Text("Cancel"),
              onPressed: () {
                _textController.clear();
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  _editTask(int id, String task, int isCompleted) async {
    TodoData taskEdit = TodoData(id, task, isCompleted);
    await dataRepo.editTask(taskEdit);
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {});
    MyTaskFunction(context, _textController, isDone, widget.todoData)
        .getTasksList()
        .then((value) => datatoShow = value);
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Map>>(
        initialData: datatoShow,
        future: MyTaskFunction(
                this.context, _textController, isDone, widget.todoData)
            .chooseList(widget.searchOrShowOld, widget.todoData),
        builder: (context, snapshot) {
          if (snapshot.data!.isEmpty) {
            return const EmptyListWidget();
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                final listIndex = snapshot.data?.toList();

                return SizedBox(
                  height: 70,
                  child: Slidable(
                    actionPane: const SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.transparent,
                        foregroundColor:
                            Theme.of(context).primaryTextTheme.bodyText1!.color,
                        iconWidget: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onTap: () {
                          MyTaskFunction(this.context, _textController, isDone,
                                  widget.todoData)
                              .deleteTodo(
                            listIndex![index]['id'],
                          );
                          setState(() {});
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.transparent,
                        foregroundColor:
                            Theme.of(context).primaryTextTheme.bodyText1!.color,
                        iconWidget: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onTap: () {
                          MyTaskFunction(this.context, _textController, isDone,
                                  widget.todoData)
                              .deleteTodo(
                            listIndex![index]['id'],
                          );
                          setState(() {});
                        },
                      ),
                    ],
                    child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: widget.backgroundColor,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              _textController.text =
                                  listIndex![index]['task'].toString();
                              showEditDialog(
                                  listIndex[index]['id'],
                                  listIndex[index]['task'],
                                  listIndex[index]['completed']);
                              setState(() {});
                            },
                            child: ListTile(
                              leading: InkWell(
                                child: MyTaskFunction(
                                        this.context,
                                        _textController,
                                        isDone,
                                        widget.todoData)
                                    .checkCompleted(
                                  listIndex![index]['completed'],
                                ),
                                onTap: () {
                                  MyTaskFunction(this.context, _textController,
                                          isDone, widget.todoData)
                                      .markAsDone(listIndex, index);
                                  setState(() {});
                                },
                              ),
                              title: Text(
                                listIndex[index]['task'],
                                style: TextStyle(
                                  decoration: MyTaskFunction(
                                          this.context,
                                          _textController,
                                          isDone,
                                          widget.todoData)
                                      .checkTextCompletedDeco(
                                    listIndex[index]['completed'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
