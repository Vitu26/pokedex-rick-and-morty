
import 'services/rick_and_morty_service_test.dart' as service_test;
import 'view_models/characters_cubit_test.dart' as characters_cubit_test;
import 'view_models/character_detail_cubit_test.dart'
    as character_detail_cubit_test;
import 'widgets/error_widget_test.dart' as error_widget_test;

void main() {

  // Service Tests
  service_test.main();

  // ViewModel Tests
  characters_cubit_test.main();
  character_detail_cubit_test.main();

  // Widget Tests
  error_widget_test.main();
}

