// User structure
class User {
	String id;
  String firstname;
  String lastname;
  String email;
  String password;
  String birthdate;
  String createdAt;
}

// Token structure
class Token {
  String id;
  String userId;
  String type;
  String ip;
  String userAgent;
  int read;
  int write;
  int manage;
  int admin;
  String createdAt;
  String expireAt;
}

// Gateway structure
class Gateway {
  String id;
  String homeId;
  String name;
  String model;
  String createdAt;
  String creatorId;
}

// Home structure
class Home {
  String id;
  String name;
  String address;
  String createdAt;
  String creatorId;
}

// Room structure
class Room {
  String id;
  String name;
  String homeId;
  String createdAt;
  String creatorId;
}

// Device structure
class Device {
  String id;
  String gatewayId;
  String name;
  String physicalId;
  String roomId;
  String createdAt;
  String creatorId;
}

// Permission structure
class Permission {
  String id;
  String userId;
  String type;
  String typeId;
  int read;
  int write;
  int manage;
  int admin;
  String updatedAt;
}
