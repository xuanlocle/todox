import 'package:hive_flutter/hive_flutter.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final todoName;
  @HiveField(1)
  final todoDetails;
  @HiveField(2)
  final bool isCompleted;


  // factory TodoModel.fromJson(Map<String, dynamic> json) => _$TodoModelFromJson(json);

  TodoModel({this.todoName, this.todoDetails, this.isCompleted = false});

  // Map<String, dynamic> toJson() => _$TodoModelToJson(this);
}
