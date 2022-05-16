import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:focus/data/database_barrel.dart';
import 'package:focus/widgets/widget_barrel.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final dataRepo = DatabaseRepository(DatabaseProvider.get);
  final _textController = TextEditingController();
  bool rebuildState = false;
  bool showSearch = false;
  bool firstClick = true;
  bool showSearchList = false;
  String searchInquiry = '';
  bool gridView = false;

  _addTodo(String task) async {
    var getData = await dataRepo.readData();
    int? newId;
    if (newId == null) {
      newId = 0;
    } else {
      newId = getData.last['id'] + 1;
    }
    var addTodo = TodoData(newId!, task, 0);
    await dataRepo.insert(addTodo);
    setState(() {
      rebuildState = true;
    });
  }

  Widget _removeOriginalList(bool showSearchList) {
    if (showSearchList == false) {
      return _rebuildWidget(rebuildState);
    } else if (showSearchList == true) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
    return const CircularProgressIndicator();
  }

  Widget _removeGridList(bool showSearchList) {
    if (showSearchList == false) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 13.0, left: 13.0),
          child: TodoGridTiles(
            searchOrShowOld: true,
            backgroundColor: Theme.of(context).cardColor,
            todoData: TodoData(0, searchInquiry, 0),
          ),
        ),
      );
    } else if (showSearchList == true) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
    return const CircularProgressIndicator();
  }

  _gridViewLayout(bool gridViewChooser) {
    if (gridViewChooser == false) {
      return _removeOriginalList(showSearchList);
    } else if (gridView == true) {
      return _removeGridList(showSearchList);
    }
  }

  Widget _searchWidget(bool showSearch) {
    if (showSearch == true) {
      setState(() {
        showSearch = false;
        showSearchList = true;
      });
      return Center(
        child: SizedBox(
          height: 40,
          width: 340,
          child: CupertinoSearchTextField(
            style: TextStyle(
                color: Theme.of(context).primaryTextTheme.bodyText1!.color),
            onChanged: (value) => {},
            onSubmitted: (value) => setState(
              () {
                searchInquiry = value;
              },
            ),
          ),
        ),
      );
    } else if (showSearch == false) {
      return const SizedBox(width: 0, height: 0);
    }
    return const CircularProgressIndicator();
  }

  Widget _showSearchResult() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 13.0,
              right: 30,
              left: 24,
            ),
            child: Text(
              'Search Result:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: _searchResultLayout(gridView),
          ),
        ],
      ),
    );
  }

  _searchResultLayout(bool gridViewChooser) {
    if (gridViewChooser == true) {
      return TodoGridTiles(
        searchOrShowOld: false,
        backgroundColor: Theme.of(context).cardColor,
        todoData: TodoData(0, searchInquiry, 0),
      );
    } else if (gridViewChooser == false) {
      return TodoTiles(
        searchOrShowOld: false,
        backgroundColor: Theme.of(context).cardColor,
        todoData: TodoData(0, searchInquiry, 0),
      );
    }
  }

  Widget _rebuildWidget(bool rebuild) {
    if (rebuild == true) {
      setState(() {
        rebuildState = false;
      });
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 13.0, left: 13.0),
          child: TodoTiles(
            todoData: TodoData(0, '', 0),
            searchOrShowOld: true,
            backgroundColor: Theme.of(context).cardColor,
          ),
        ),
      );
    } else if (rebuild == false) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 13.0, left: 13.0),
          child: TodoTiles(
            todoData: TodoData(0, '', 0),
            searchOrShowOld: true,
            backgroundColor: Theme.of(context).cardColor,
          ),
        ),
      );
    }
    return const CircularProgressIndicator();
  }

  _showListSearch(bool showSearch) {
    if (showSearch == true) {
      return _showSearchResult();
    } else {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
  }

  _gridIcon(bool gridViewIcon) {
    if (gridViewIcon == true) {
      return Icons.list_outlined;
    } else if (gridViewIcon == false) {
      return Icons.grid_view_rounded;
    }
  }

  void showInputDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: CupertinoActionSheet(
            title: const Text("Create Task"),
            message: CupertinoTextField(
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.bodyText1!.color),
              placeholder: "Type your task",
              controller: _textController,
            ),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('Add'),
                onPressed: () {
                  String task = _textController.value.text;
                  _addTodo(task);
                  Navigator.pop(context);
                  _textController.clear();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text(
          "Tasks List",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle!.color,
            fontSize: 24,
          ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              showInputDialog();
            },
            child: Icon(
              Icons.add_circle_rounded,
              size: 32,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => setState(() {
                if (firstClick == true) {
                  setState(() {
                    firstClick = false;
                    showSearch = true;
                    showSearchList = true;
                  });
                } else if (firstClick == false) {
                  setState(() {
                    showSearch = false;
                    showSearchList = false;
                    firstClick = true;
                  });
                }
              }),
              child: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              child: Icon(
                _gridIcon(gridView),
                size: 29,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () => setState(
                () {
                  if (gridView == false) {
                    setState(() {
                      gridView = true;
                    });
                  } else if (gridView == true) {
                    setState(() {
                      gridView = false;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _searchWidget(showSearch),
            _gridViewLayout(gridView),
            _showListSearch(showSearchList),
          ],
        ),
      ),
    );
  }
}
