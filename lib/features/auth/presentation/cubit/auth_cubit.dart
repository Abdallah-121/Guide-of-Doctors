import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  void checkAuthStatus() {
    final user = getCurrentUserUseCase();
    if (user == null) {
      emit(Unauthenticated());
    } else {
      emit(Authenticated(user.email));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await loginUseCase(email.trim(), password);
    if (result.isSuccess) {
      emit(Authenticated(result.data!.email));
    } else {
      emit(AuthError(result.failure!.message));
      emit(Unauthenticated());
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    emit(Unauthenticated());
  }
}
