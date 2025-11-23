// Minimal logger helper - replace with Winston-like services or Sentry in prod
import 'dart:developer' as developer;


class Log {
static void i(String message) => developer.log(message, name: 'INFO');
static void e(String message, [Object? err]) => developer.log(message, name: 'ERROR', error: err);
}