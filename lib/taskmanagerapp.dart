import 'package:flutter/material.dart';

class Task {
  int id;
  String title;
  bool completed;

  Task({required this.id, required this.title, this.completed = false});
}

enum FilterOption { all, completed, pending }

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskManagerPage(),
    );
  }
}

class TaskManagerPage extends StatefulWidget {
  @override
  _TaskManagerPageState createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  final List<Task> _tasks = [
    Task(id: 1, title: 'Buy groceries'),
    Task(id: 2, title: 'Read a book', completed: true),
  ];

  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  FilterOption _filter = FilterOption.all;

  void _addTask(String title) {
    if (title.trim().isEmpty) {
      setState(() {
        _errorText = 'Task title cannot be empty';
      });
      return;
    }

    setState(() {
      _tasks.add(Task(id: _tasks.length + 1, title: title.trim()));
      _errorText = null;
      _controller.clear();
    });
  }

  void _toggleComplete(Task task) {
    setState(() {
      task.completed = !task.completed;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  void _setFilter(FilterOption option) {
    setState(() {
      _filter = option;
    });
  }

  List<Task> get _filteredTasks {
    switch (_filter) {
      case FilterOption.completed:
        return _tasks.where((task) => task.completed).toList();
      case FilterOption.pending:
        return _tasks.where((task) => !task.completed).toList();
      case FilterOption.all:
      default:
        return _tasks;
    }
  }

  Widget _buildTaskItem(Task task) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
          color: task.completed ? Colors.grey : Colors.black,
        ),
      ),
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => _toggleComplete(task),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _deleteTask(task),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: Text('All'),
          selected: _filter == FilterOption.all,
          onSelected: (_) => _setFilter(FilterOption.all),
        ),
        SizedBox(width: 8),
        ChoiceChip(
          label: Text('Completed'),
          selected: _filter == FilterOption.completed,
          onSelected: (_) => _setFilter(FilterOption.completed),
        ),
        SizedBox(width: 8),
        ChoiceChip(
          label: Text('Pending'),
          selected: _filter == FilterOption.pending,
          onSelected: (_) => _setFilter(FilterOption.pending),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Task Manager'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Add new task',
                          border: OutlineInputBorder(),
                          errorText: _errorText,
                        ),
                        onSubmitted: _addTask,
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _addTask(_controller.text),
                      child: Text('Add'),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildFilterChips(),
              ],
            ),
          ),
          Expanded(
            child: _filteredTasks.isEmpty
                ? Center(child: Text('No tasks here'))
                : ListView.builder(
                    itemCount: _filteredTasks.length,
                    itemBuilder: (_, index) =>
                        _buildTaskItem(_filteredTasks[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
