class FriendData {
  FriendData({
    required this.uid,
    required this.displayName,
    required this.photoUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is FriendData) {
      return runtimeType == other.runtimeType && uid == other.uid;
    }
    return false;
  }

  @override
  int get hashCode => uid.hashCode;

  String uid;
  String displayName;
  String photoUrl;
}
