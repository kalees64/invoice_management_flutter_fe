import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_management_flutter_fe/store/user/user_event.dart';
import 'package:invoice_management_flutter_fe/store/user/user_repository.dart';
import 'package:invoice_management_flutter_fe/store/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepo;

  UserBloc(this.userRepo) : super(UserInitialState()) {
    on<LoadUsersEvent>(_getAllUsers);
    on<LoadUserEvent>(_getUser);
    on<AddUserEvent>(_addUser);
    on<UpdateUserEvent>(_updateUser);
    on<DeleteUserEvent>(_deleteUser);
  }

  Future<void> _getAllUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoadingState());
      final users = await userRepo.getUsers();
      emit(UserLoadedState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _getUser(LoadUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      final user = await userRepo.getUser(event.id);
      emit(UserLoadedState([user]));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _addUser(AddUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      await userRepo.createUser(event.data);
      add(LoadUsersEvent());
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _updateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoadingState());
      await userRepo.updateUser(event.id, event.data);
      add(LoadUsersEvent());
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _deleteUser(
    DeleteUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoadingState());
      await userRepo.deleteUser(event.id);
      add(LoadUsersEvent());
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
