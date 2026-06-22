import 'package:equatable/equatable.dart';

/// Manually entered room dimensions (in meters) for the AI designer / planner.
class RoomDimensions extends Equatable {
  const RoomDimensions({
    required this.lengthM,
    required this.widthM,
    required this.heightM,
  });

  final double lengthM;
  final double widthM;
  final double heightM;

  double get floorAreaM2 => lengthM * widthM;

  factory RoomDimensions.fromJson(Map<String, dynamic> json) => RoomDimensions(
        lengthM: (json['lengthM'] as num).toDouble(),
        widthM: (json['widthM'] as num).toDouble(),
        heightM: (json['heightM'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lengthM': lengthM,
        'widthM': widthM,
        'heightM': heightM,
      };

  @override
  List<Object?> get props => [lengthM, widthM, heightM];
}
