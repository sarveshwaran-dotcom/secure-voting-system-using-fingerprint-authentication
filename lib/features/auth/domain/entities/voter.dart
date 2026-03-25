import 'package:equatable/equatable.dart';

class Voter extends Equatable {
  final String id;
  final String mobileNumber;
  final bool hasVoted;
  final String? deviceId;
  final DateTime createdAt;
  final DateTime? lastLogin;

  const Voter({
    required this.id,
    required this.mobileNumber,
    required this.hasVoted,
    this.deviceId,
    required this.createdAt,
    this.lastLogin,
  });

  @override
  List<Object?> get props => [
        id,
        mobileNumber,
        hasVoted,
        deviceId,
        createdAt,
        lastLogin,
      ];

  Voter copyWith({
    String? id,
    String? mobileNumber,
    bool? hasVoted,
    String? deviceId,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return Voter(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      hasVoted: hasVoted ?? this.hasVoted,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
