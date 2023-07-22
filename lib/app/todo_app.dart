part of todo_mvc_app;

class TodoApp implements ICommandReaction, IPastCommand {
  late DomainSession session;
  late Tasks tasks;

  late Todos _todos;
  Element? _main = querySelector('#main');
  InputElement? _completeAll = querySelector('#complete-all') as InputElement?;
  Element? _footer = querySelector('#footer');
  Element? _leftCount = querySelector('#left-count');
  Element? _clearCompleted = querySelector('#clear-completed');
  Element? _undo = querySelector('#undo');
  Element? _redo = querySelector('#redo');
  Element? _errors = querySelector('#errors');

  TodoApp(TodoModels domain) {
    session = domain.newSession();
    domain.startCommandReaction(this);
    session.past.startPastReaction(this);
    MvcEntries model =
        domain.getModelEntries(TodoRepo.todoMvcModelCode) as MvcEntries;
    tasks = model.getEntry('Task') as Tasks;

    _todos = new Todos(this);
    //load todos
    String? json = window.localStorage['todos'];
    if (json != null) {
      tasks.fromJson(jsonDecode(json));
      for (Task task in tasks) {
        _todos.add(task);
      }
      _updateFooter();
    }

    InputElement? newTodo = querySelector('#new-todo') as InputElement?;
    newTodo?.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value?.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title!;
          newTodo.value = '';
          new AddCommand(session, tasks, task).doIt();
          _possibleErrors();
        }
      }
    });

    _completeAll?.onClick.listen((Event e) {
      var transaction = new Transaction('complete-all', session);
      if (tasks.left.length == 0) {
        for (Task task in tasks) {
          transaction
              .add(new SetAttributeCommand(session, task, 'completed', false));
        }
      } else {
        for (Task task in tasks.left) {
          transaction
              .add(new SetAttributeCommand(session, task, 'completed', true));
        }
      }
      transaction.doIt();
    });

    _clearCompleted?.onClick.listen((MouseEvent e) {
      var transaction = new Transaction('clear-completed', session);
      for (Task task in tasks.completed) {
        transaction.add(new RemoveCommand(session, tasks.completed, task));
      }
      transaction.doIt();
    });

    _undo?.style.display = 'none';
    _undo?.onClick.listen((MouseEvent e) {
      session.past.undo();
    });

    _redo?.style.display = 'none';
    _redo?.onClick.listen((MouseEvent e) {
      session.past.redo();
    });
  }

  _save() {
    window.localStorage['todos'] = jsonEncode(tasks.toJson());
  }

  _possibleErrors() {
    _errors?.innerHtml = '<p>${tasks.exceptions..toString()}</p>';
    tasks.exceptions..clear();
  }

  _updateFooter() {
    var display = tasks.length == 0 ? 'none' : 'block';
    _completeAll?.style.display = display;
    _main?.style.display = display;
    _footer?.style.display = display;

    // update counts
    var completedLength = tasks.completed.length;
    var leftLength = tasks.left.length;
    _completeAll?.checked = (completedLength == tasks.length);
    _leftCount?.innerHtml =
        '<b>${leftLength}</b> todo${leftLength != 1 ? 's' : ''} left';
    if (completedLength == 0) {
      _clearCompleted?.style.display = 'none';
    } else {
      _clearCompleted?.style.display = 'block';
      _clearCompleted?.text = 'Clear completed (${tasks.completed.length})';
    }

    _possibleErrors();
  }

  react(ICommand action) {
    updateTodo(SetAttributeCommand action) {
      if (action.property == 'completed') {
        _todos.complete(action.entity as Task);
      } else if (action.property == 'title') {
        _todos.retitle(action.entity as Task);
      }
    }

    if (action is Transaction) {
      for (var transactionCommand in action.past.commands) {
        if (transactionCommand is SetAttributeCommand) {
          updateTodo(transactionCommand);
        } else if (transactionCommand is RemoveCommand) {
          if (transactionCommand.undone) {
            _todos.add(transactionCommand.entity as Task);
          } else {
            _todos.remove(transactionCommand.entity as Task);
          }
        }
      }
    } else if (action is AddCommand) {
      if (action.undone) {
        _todos.remove(action.entity as Task);
      } else {
        _todos.add(action.entity as Task);
      }
    } else if (action is RemoveCommand) {
      if (action.undone) {
        _todos.add(action.entity as Task);
      } else {
        _todos.remove(action.entity as Task);
      }
    } else if (action is SetAttributeCommand) {
      updateTodo(action);
    }

    _updateFooter();
    _save();
  }

  reactCannotUndo() {
    _undo?.style.display = 'none';
  }

  reactCanUndo() {
    _undo?.style.display = 'block';
  }

  reactCanRedo() {
    _redo?.style.display = 'block';
  }

  reactCannotRedo() {
    _redo?.style.display = 'none';
  }
}
