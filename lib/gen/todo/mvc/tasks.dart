part of todo_mvc;

// lib/gen/todo/mvc/tasks.dart

abstract class TaskGen extends Entity<Task> {

  TaskGen(Concept concept) : super.of(concept);

  String get title => getAttribute("title");
  set title(String a) => setAttribute("title", a);

  bool get completed => getAttribute("completed");
  set completed(bool a) => setAttribute("completed", a);

  Task newEntity() => new Task(concept);
  Tasks newEntities() => new Tasks(concept);

}

abstract class TasksGen extends Entities<Task> {

  TasksGen(Concept concept) : super.of(concept);

  Tasks newEntities() => new Tasks(concept);
  Task newEntity() => new Task(concept);

}