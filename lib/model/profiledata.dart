class ProfileData {
  static int post = 0;
  static int follower = 0;
  static int following = 0;
  static String username = "username";
  static String bio = "";
  static String name = "";
  set setpostCount(int count) {
    post = count;
  }

  set setfollowers(int follow) {
    follower = follow;
  }

  set setfollowing(int foling) {
    following = foling;
  }

  set setusername(String text) {
    username = text;
  }

  set setBio(String text) {
    bio = text;
  }

  set setName(String text) {
    name = text;
  }
}
