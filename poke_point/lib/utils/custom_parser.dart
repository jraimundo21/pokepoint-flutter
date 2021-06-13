class CustomParser {
  static String encodeToQueryString(Map toEncode) {
    String result = '';
    toEncode.forEach((key, value) {
      result += (result == '' ? '' : '&') + '$key=$value';
    });
    return result;
  }

  static Map decodeFromQueryString(String encodedValues) {
    List<String> pairs = encodedValues.split('&');
    Map result = {};
    pairs.forEach((element) {
      List<String> pair = element.split('=');
      result[pair[0]] = pair[1];
    });
    return result;
  }
}
