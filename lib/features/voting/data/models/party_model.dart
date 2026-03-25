import '../../domain/entities/party.dart';

class PartyModel extends Party {
  const PartyModel({
    required super.id,
    required super.name,
    required super.leaderName,
    required super.leaderImageUrl,
    required super.symbolUrl,
    required super.flagUrl,
    required super.isActive,
    required super.order,
  });

  factory PartyModel.fromJson(Map<String, dynamic> json) {
    return PartyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      leaderName: json['leader_name'] as String,
      leaderImageUrl: json['leader_image_url'] as String,
      symbolUrl: json['symbol_url'] as String,
      flagUrl: json['flag_url'] as String,
      isActive: json['is_active'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'leader_name': leaderName,
      'leader_image_url': leaderImageUrl,
      'symbol_url': symbolUrl,
      'flag_url': flagUrl,
      'is_active': isActive,
      'order': order,
    };
  }

  factory PartyModel.fromEntity(Party party) {
    return PartyModel(
      id: party.id,
      name: party.name,
      leaderName: party.leaderName,
      leaderImageUrl: party.leaderImageUrl,
      symbolUrl: party.symbolUrl,
      flagUrl: party.flagUrl,
      isActive: party.isActive,
      order: party.order,
    );
  }
}
