import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_list/file_base/manager_file.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  List _toList = [];
  TextEditingController taskController = TextEditingController();

  void _addTask() {
    setState(() {
      final task = taskController.text;
      taskController.text = '';

      final Map<String, dynamic> map = Map();
      map['title'] = task;
      map['ok'] = false;

      _toList.add(map);
      saveData(_toList);
    });
  }

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toList.sort((a, b) {
        if (a['ok'] && !b['ok'])
          return 1;
        else if (!a['ok'] && b['ok'])
          return -1;
        else
          return 0;
      });

      saveData(_toList);
    });
  }

  @override
  void initState() {
    super.initState();

    readData().then((json) {
      setState(() => _toList = jsonDecode(json));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tarefas'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 1, 8, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Nova tarefa',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text('Add'),
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                  itemCount: _toList.length,
                  itemBuilder: buildItem,
                ),
              ),
              onRefresh: _refresh,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    final task = _toList[index]['title'];
    final check = _toList[index]['ok'];

    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(task),
        value: check,
        secondary: CircleAvatar(
          child: Icon(check == true ? Icons.check : Icons.error),
        ),
        onChanged: (value) {
          setState(() {
            _toList[index]['ok'] = value;
            saveData(_toList);
          });
        },
      ),
      onDismissed: (direction) {
        final lastTask = _toList[index];

        _toList.removeAt(index);
        saveData(_toList);

        final snackbar = SnackBar(
          content: Text('Tarefa "${lastTask["title"]}" removido'),
          action: SnackBarAction(
            label: 'desfazer',
            onPressed: () {
              setState(() {
                _toList.insert(index, lastTask);
              });
            },
          ),
          duration: Duration(seconds: 2),
        );

        Scaffold.of(context).showSnackBar(snackbar);
      },
    );
  }
}
