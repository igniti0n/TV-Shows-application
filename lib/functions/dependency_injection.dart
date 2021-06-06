import '../core/dependency_injection.dart';
import 'authenticating_user/di/dependency_injection.dart';
import 'authetication_checker/di/dependency_injection.dart';
import 'comments/di/dependency_injection.dart';
import 'episodes/di/dependency_injection.dart';
import 'shows/di/dependency_injection.dart';

class DependencyInjector {
  static void initiDependencies() async {
    _initializeAllDependencies();
  }
}

void _initializeAllDependencies() {
  initiDependenciesCore();
  initiDependenciesAuthenticatingUser();
  initiDependenciesAuthenticationChecker();
  initiDependenciesShows();
  initiDependenciesEpisodes();
  initiDependenciesComments();
}
