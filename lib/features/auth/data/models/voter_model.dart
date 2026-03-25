import '../../domain/entities/voter.dart';

class VoterModel extends Voter {
  const VoterModel({
    required super.id,
    required super.mobileNumber,
    required super.hasVoted,
    super.deviceId,
    required super.createdAt,
    super.lastLogin,
  });

  factory VoterModel.fromJson(Map<String, dynamic> json) {
    return VoterModel(
      id: json['id'] as String,
      mobileNumber: json['mobile_number'] as String,
      hasVoted: json['has_voted'] as bool? ?? false,
      deviceId: json['device_id'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile_number': mobileNumber,
      'has_voted': hasVoted,
      'device_id': deviceId,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  factory VoterModel.fromEntity(Voter voter) {
    return VoterModel(
      id: voter.id,
      mobileNumber: voter.mobileNumber,
      hasVoted: voter.hasVoted,
      deviceId: voter.deviceId,
      createdAt: voter.createdAt,
      lastLogin: voter.lastLogin,
    );
  }
}
