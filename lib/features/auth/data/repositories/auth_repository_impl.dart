import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  AuthUser? getCurrentUser() => remoteDataSource.getCurrentUser();

  @override
  Future<Result<AuthUser>> login(String email, String password) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('تحقق من اتصال الإنترنت.'));
    }
    try {
      final user = await remoteDataSource.login(email, password);
      return Result.success(user);
    } catch (e) {
      return Result.failure(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<void> logout() => remoteDataSource.logout();
}
