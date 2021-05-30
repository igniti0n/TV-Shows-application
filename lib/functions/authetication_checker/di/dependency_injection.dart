import 'package:get_it/get_it.dart';
import '../view/auth_form_bloc/auth_form_bloc.dart';

void initiDependenciesAuthenticationChecker() {
  final _get = GetIt.instance;

//!blocs
  _get.registerFactory(() => AuthFormBloc(_get()));
}
