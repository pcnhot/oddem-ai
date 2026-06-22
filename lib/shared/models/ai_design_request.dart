import 'package:equatable/equatable.dart';

import 'room_dimensions.dart';

/// Input the user provides to the AI designer.
///
/// Recommendation is driven by room type, budget, style and dimensions.
class AiDesignRequest extends Equatable {
  const AiDesignRequest({
    required this.roomType,
    required this.style,
    required this.budget,
    this.dimensions,
    this.roomPhotoPath,
    this.strictMode = false,
    this.strictKeepNote,
    this.strictReplaceItem,
  });

  final String roomType;
  final String style;

  /// Total budget in SAR.
  final double budget;

  /// Optional manual dimensions.
  final RoomDimensions? dimensions;

  /// Optional uploaded room photo (local path for the MVP).
  final String? roomPhotoPath;

  /// StrictMode: change only one item in the room while keeping everything
  /// else unchanged.
  final bool strictMode;

  /// Free-text note describing what must stay unchanged.
  final String? strictKeepNote;

  /// The single item the user wants to replace (e.g. "الكنبة").
  final String? strictReplaceItem;

  AiDesignRequest copyWith({
    String? roomType,
    String? style,
    double? budget,
    RoomDimensions? dimensions,
    String? roomPhotoPath,
    bool? strictMode,
    String? strictKeepNote,
    String? strictReplaceItem,
  }) =>
      AiDesignRequest(
        roomType: roomType ?? this.roomType,
        style: style ?? this.style,
        budget: budget ?? this.budget,
        dimensions: dimensions ?? this.dimensions,
        roomPhotoPath: roomPhotoPath ?? this.roomPhotoPath,
        strictMode: strictMode ?? this.strictMode,
        strictKeepNote: strictKeepNote ?? this.strictKeepNote,
        strictReplaceItem: strictReplaceItem ?? this.strictReplaceItem,
      );

  @override
  List<Object?> get props => [
        roomType,
        style,
        budget,
        dimensions,
        roomPhotoPath,
        strictMode,
        strictKeepNote,
        strictReplaceItem,
      ];
}
