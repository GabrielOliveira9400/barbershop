import 'package:asyncstate/class/async_loader_handler.dart';
  import 'package:dw_barbershop/src/core/exceptions/service_exception.dart';
  import 'package:dw_barbershop/src/core/fp/either.dart';
  import 'package:dw_barbershop/src/core/providers/application_providers.dart';
  import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
  import 'package:dw_barbershop/src/model/user_model.dart';
  import 'package:riverpod_annotation/riverpod_annotation.dart';

  part 'login_vm.g.dart';


  @Riverpod()
  class LoginVm extends _$LoginVm {
  @override
  LoginState build() => LoginState.initial();

    Future<void> login(String email, String password) async {

      final loaderHandle = AsyncLoaderHandler()..start();

      final loginService = ref.watch(userLoginServiceProvider);

      final result = await loginService.execute(email, password);

      switch(result){
        case Success():
          //Invalidando caches para evitar login errado
          ref.invalidate(getMeProvider);
          ref.invalidate(getMyBarbershopProvider);
        final userModel = await ref.read(getMeProvider.future);
        switch(userModel) {
          case UserModelADM():
            state = state.copyWith(
              status: LoginStateStatus.admLogin
            );
            break;
          case UserModelEmployee():
            state = state.copyWith(
              status: LoginStateStatus.employeeLogin,
            );
            break;
        }
          break;
        case Failure(exception: ServiceException(:final message)):
          state = state.copyWith(
            status: LoginStateStatus.error,
            errorMessage: () => message,
          );
      }
      loaderHandle.close();
    }
}