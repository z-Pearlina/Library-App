import 'package:pearlibrary/services/shared_prefs_service.dart';

// Domain Layer: Use Case for getting the logged-in user's name
class GetLoggedInUserNameUseCase {
  // Depending on strictness, this could depend on a SessionRepository interface
  // instead of directly on the service implementation.
  final SharedPrefsService _prefsService;

  GetLoggedInUserNameUseCase(this._prefsService);

  Future<String?> execute() async {
    // Retrieve the user name from the session service
    return await _prefsService.getLoggedInUserName();
  }
}

