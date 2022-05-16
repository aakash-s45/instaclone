class DBContent {
  static Map<String, dynamic> initialData = {
    'profile': "",
    'uname': "",
    'name': "",
    'bio': "",
    'post': [],
    'reels': [],
    'followers': [],
    'followings': [],
    'tagged': [],
    'closef': [],
  };

  final String profileimg;
  final String username;
  final String name;
  final String bio;
  final List<Map<String, dynamic>> posts;
  final List<String> reels;
  final List<String> followers;
  final List<String> followings;
  final List<String> tagged;
  final List<String> closef;

  DBContent({
    required this.profileimg,
    required this.name,
    required this.username,
    required this.bio,
    required this.posts,
    required this.reels,
    required this.closef,
    required this.followers,
    required this.followings,
    required this.tagged,
  });

  factory DBContent.fromMap(Map<String, dynamic> map) => DBContent(
      profileimg: map['profile'],
      name: map['name'],
      username: map['uname'],
      bio: map['bio'],
      posts: map['posts'],
      reels: map['reels'],
      closef: ['closef'],
      followers: map['followers'],
      followings: map['followings'],
      tagged: map['tagged']);

  Map<String, dynamic> toMap() => {
        'profile': profileimg,
        'uname': username,
        'name': name,
        'bio': bio,
        'posts': posts,
        'reels': reels,
        'followers': followers,
        'followings': followings,
        'tagged': tagged,
        'closef': closef,
      };
}
