class ErrorParser {
  static String parse(dynamic errorBody) {
    if (errorBody == null) return 'Unknown error';

    try {
      // If backend used the "errors" format (deep nested)
      if (errorBody['errors'] != null) {
        final errors = errorBody['errors'];

        // Loop through each field and return the first error message
        for (var field in errors.keys) {
          final fieldErrors = errors[field];

          if (fieldErrors is Map &&
              fieldErrors['_errors'] != null &&
              fieldErrors['_errors'].isNotEmpty) {
            return fieldErrors['_errors'][0];
          }
        }
      }

      // If backend returns: { "error": "Invalid credentials" }
      if (errorBody['error'] != null) return errorBody['error'];

      // If backend returns: { "message": "Some error message" }
      if (errorBody['message'] != null) return errorBody['message'];
    } catch (_) {
      // Ignore and fallback below
    }

    return 'Something went wrong. Try again.';
  }
}
