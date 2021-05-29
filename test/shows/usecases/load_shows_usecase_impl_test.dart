import 'package:mockito/mockito.dart';
import 'package:tw_shows/functions/shows/domain/repositories/shows_repository.dart';
import 'package:tw_shows/functions/shows/domain/usecases/load_shows_usecase.dart';

class MocShowsRepository extends Mock implements ShowsRepository {}

void main() {
  MockShowsRepository _mockShowsRepository;
  LoadShowsUsecaseImpl _loadShowsUsecaseImpl;
}


