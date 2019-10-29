import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';

class TaskDialog extends StatefulWidget {
  final Task task;

  TaskDialog({this.task});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priorityController = TextEditingController();

  Task _currentTask = Task();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _currentTask = Task.fromMap(widget.task.toMap());
    }

    _titleController.text = _currentTask.title;
    _descriptionController.text = _currentTask.description;
    _priorityController.text = _currentTask.priority.toString().isEmpty
        ? _currentTask.priority.toString()
        : "";
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.clear();
    _descriptionController.clear();
    _priorityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Nova tarefa' : 'Editar tarefas'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTextFormField(
                controller: _titleController,
                error: "Escreva o título",
                label: 'Título',
              ),
              buildTextFormField(
                controller: _descriptionController,
                error: "Escreva a descrição",
                label: 'Descrição',
              ),
              buildTextFormFieldNumber(
                controller: _priorityController,
                error: "Insira valores entre 1 e 5",
                label: 'Prioridade',
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Salvar'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _currentTask.title = _titleController.value.text;
              _currentTask.description = _descriptionController.text;
              _currentTask.priority = int.parse(_priorityController.text);
              Navigator.of(context).pop(_currentTask);
            }
          },
        ),
      ],
    );
  }

  Widget buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      maxLines: null,
      minLines: 1,
      autofocus: true,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (String text) {
        return text.isEmpty ? error : null;
      },
    );
  }

  Widget buildTextFormFieldNumber(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      maxLines: 1,
      maxLength: 1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (String text) {
        if (text != null) {
          if ((int.parse(text)) < 1 || (int.parse(text)) > 5) {
            return error;
          } else
            return null;
        } else
          return error;
      },
    );
  }
}
