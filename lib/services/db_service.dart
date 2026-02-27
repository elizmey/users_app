// Use IO (sqflite) on mobile/desktop and a web implementation on web.
export 'db_service_io.dart' if (dart.library.html) 'db_service_web.dart';

