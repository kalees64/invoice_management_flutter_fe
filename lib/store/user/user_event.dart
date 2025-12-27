import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UserEvent {}

class LoadUserEvent extends UserEvent {
  final String id;

  LoadUserEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddUserEvent extends UserEvent {
  final Map<String, dynamic> data;

  AddUserEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateUserEvent extends UserEvent {
  final String id;
  final Map<String, dynamic> data;

  UpdateUserEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteUserEvent extends UserEvent {
  final String id;

  DeleteUserEvent(this.id);

  @override
  List<Object?> get props => [id];
}
