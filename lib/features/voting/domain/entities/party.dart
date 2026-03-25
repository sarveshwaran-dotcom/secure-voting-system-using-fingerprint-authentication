import 'package:equatable/equatable.dart';

class Party extends Equatable {
  final String id;
  final String name;
  final String leaderName;
  final String leaderImageUrl;
  final String symbolUrl;
  final String flagUrl;
  final bool isActive;
  final int order;

  const Party({
    required this.id,
    required this.name,
    required this.leaderName,
    required this.leaderImageUrl,
    required this.symbolUrl,
    required this.flagUrl,
    required this.isActive,
    required this.order,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        leaderName,
        leaderImageUrl,
        symbolUrl,
        flagUrl,
        isActive,
        order,
      ];

  Party copyWith({
    String? id,
    String? name,
    String? leaderName,
    String? leaderImageUrl,
    String? symbolUrl,
    String? flagUrl,
    bool? isActive,
    int? order,
  }) {
    return Party(
      id: id ?? this.id,
      name: name ?? this.name,
      leaderName: leaderName ?? this.leaderName,
      leaderImageUrl: leaderImageUrl ?? this.leaderImageUrl,
      symbolUrl: symbolUrl ?? this.symbolUrl,
      flagUrl: flagUrl ?? this.flagUrl,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
    );
  }
}
