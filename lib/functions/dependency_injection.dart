import 'package:tw_shows/core/dependency_injection.dart';
import 'package:tw_shows/functions/authenticating_user/di/dependency_injection.dart';
import 'package:tw_shows/functions/authetication_checker/di/dependency_injection.dart';
import 'package:tw_shows/functions/comments/di/dependency_injection.dart';
import 'package:tw_shows/functions/episodes/di/dependency_injection.dart';
import 'package:tw_shows/functions/shows/di/dependency_injection.dart';

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
