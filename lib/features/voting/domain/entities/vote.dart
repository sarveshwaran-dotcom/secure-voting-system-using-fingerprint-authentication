import 'package:equatable/equatable.dart';

class Vote extends Equatable {
  final String id;
  final String partyId;
  final DateTime timestamp;
  final String encryptedData;

  const Vote({
    required this.id,
    required this.partyId,
    required this.timestamp,
    required this.encryptedData,
  });

  @override
  List<Object?> get props => [
        id,
        partyId,
        timestamp,
        encryptedData,
      ];

  Vote copyWith({
    String? id,
    String? partyId,
    DateTime? timestamp,
    String? encryptedData,
  }) {
    return Vote(
      id: id ?? this.id,
      partyId: partyId ?? this.partyId,
      timestamp: timestamp ?? this.timestamp,
      encryptedData: encryptedData ?? this.encryptedData,
    );
  }
}
