class UserTypeConstant {
  static const int SA = 0;
  static const int S = 1;
  static const int NU = 2;

  static String getUserType(int type) {
    if (type == SA) {
      return "Super Admin";
    } else if (type == S) {
      return "Staff";
    } else if (type == NU) {
      return "Normal User";
    } else {
      return "-";
    }
  }
}
