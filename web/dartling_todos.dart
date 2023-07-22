import 'package:todo_mvc/todo_mvc.dart';
import 'package:todo_mvc/todo_mvc_app.dart';

main() {
  var repo = new TodoRepo();
  TodoModels domain =
      repo.getDomainModels(TodoRepo.todoDomainCode) as TodoModels;
  new TodoApp(domain);
}
