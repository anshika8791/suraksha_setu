import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {

    /// LOGIN
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      final response =
      await repository.login(event.email, event.password);

      if (response["success"]) {
        final data = response["data"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        await prefs.setString("name", data["user"]["name"]);
        await prefs.setString("email", data["user"]["email"]);

        emit(AuthSuccess("Login successful"));
      } else {
        emit(AuthFailure(
            response["message"] ?? "User doesn't exist. Please signup"));
      }
    });

    /// SIGNUP
    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());

      final response = await repository.signup(
        event.name,
        event.email,
        event.password,
      );

      if (response["success"]) {
        emit(AuthSuccess("Signup successful"));
      } else {
        emit(AuthFailure(response["message"] ?? "Signup failed"));
      }
    });
  }
}