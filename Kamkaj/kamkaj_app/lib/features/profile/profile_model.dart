class UserProfile {
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? role;
  final String? profileImage;
  
  // Worker Specific
  final String? skillCategory;
  final String? experience;
  final String? bio;

  UserProfile({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.role,
    this.profileImage,
    this.skillCategory,
    this.experience,
    this.bio,
  });

  // Convert to Map for saving
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'profileImage': profileImage,
      'skillCategory': skillCategory,
      'experience': experience,
      'bio': bio,
    };
  }

  // Create from Map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      role: map['role'],
      profileImage: map['profileImage'],
      skillCategory: map['skillCategory'],
      experience: map['experience'],
      bio: map['bio'],
    );
  }
}
