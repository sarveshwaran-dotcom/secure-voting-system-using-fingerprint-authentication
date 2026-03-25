import '../../domain/entities/vote.dart';

class VoteModel extends Vote {
  const VoteModel({
    required super.id,
    required super.partyId,
    required super.timestamp,
    required super.encryptedData,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      id: json['id'] as String,
      partyId: json['party_id'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      encryptedData: json['encrypted_data'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'party_id': partyId,
      'timestamp': timestamp.toIso8601String(),
      'encrypted_data': encryptedData,
    };
  }

  factory VoteModel.fromEntity(Vote vote) {
    return VoteModel(
      id: vote.id,
      partyId: vote.partyId,
      timestamp: vote.timestamp,
      encryptedData: vote.encryptedData,
    );
  }
}
