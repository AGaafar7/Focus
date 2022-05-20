import 'package:flutter/material.dart';
import 'package:focus/data/database_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:focus/widgets/widget_barrel.dart';

class TodoGridTiles extends StatefulWidget {
  final backgroundColor;
  final searchOrShowOld;
  final todoData;

  const TodoGridTiles(
      {Key? key,
      required this.backgroundColor,
      this.searchOrShowOld,
      required this.todoData})
      : super(key: key);

  @override
  _TodoGridTilesState createState() => _TodoGridTilesState();
}

class _TodoGridTilesState extends State<TodoGridTiles> {
  final dataRepo = DatabaseRepository(DatabaseProvider.get);
  bool isDone = false;
  final _textController = TextEditingController();

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
        future: MyTaskFunction(
          this.context,
          _textController,
          isDone,
          widget.todoData,
        ).chooseList(widget.searchOrShowOld, widget.todoData),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return EmptyListWidget();
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final listIndex = snapshot.data?.toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _gridListItem(listIndex!, index),
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

  Widget _gridListItem(List<Map> listIndex, int index) {
    return InkWell(
      onTap: () {
        _textController.text = listIndex[index]['task'].toString();
        showEditDialog(listIndex[index]['id'], listIndex[index]['task'],
            listIndex[index]['completed']);
        setState(() {});
      },
      child: GridTile(
        child: Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
            ),
            child: Text(
              listIndex[index]['task'],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                decoration: MyTaskFunction(
                  context,
                  _textController,
                  isDone,
                  widget.todoData,
                ).checkTextCompletedDeco(
                  listIndex[index]['completed'],
                ),
              ),
            ),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridTileBar(
            backgroundColor: Theme.of(context).cardColor,
            trailing: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: MyTaskFunction(
                    context,
                    _textController,
                    isDone,
                    widget.todoData,
                  ).checkCompleted(
                    listIndex[index]['completed'],
                  ),
                  onTap: () {
                    MyTaskFunction(
                      context,
                      _textController,
                      isDone,
                      widget.todoData,
                    ).markAsDone(listIndex, index);
                    setState(() {});
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onTap: () {
                      MyTaskFunction(
                        context,
                        _textController,
                        isDone,
                        widget.todoData,
                      ).deleteTodo(
                        listIndex[index]['id'],
                      );
                      setState(() {});
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
