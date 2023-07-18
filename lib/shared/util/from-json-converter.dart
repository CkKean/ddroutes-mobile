class FromJsonConverter {
  static DateTime convertStringToDateTime(String s) {
    if (s != null && s.isNotEmpty) {
      return DateTime.parse(s).toLocal();
    }
    return null;
  }

  static double convertStringToDouble(String s) {
    if (s != null && s.isNotEmpty) {
      return double.parse(s);
    }
    return null;
  }

  static bool convertIntToBool(int i) {
    if (i != null) {
      return i == 1 ? true : false;
    }
    return null;
  }
}
