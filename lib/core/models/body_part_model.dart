import 'package:hive/hive.dart';

part 'body_part_model.g.dart';

@HiveType(typeId: 9)
class BodyPartCoordinates extends HiveObject {
  @HiveField(0)
  double top;

  @HiveField(1)
  double left;

  @HiveField(2)
  double width;

  @HiveField(3)
  double height;

  BodyPartCoordinates({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });

  BodyPartCoordinates copyWith({
    double? top,
    double? left,
    double? width,
    double? height,
  }) {
    return BodyPartCoordinates(
      top: top ?? this.top,
      left: left ?? this.left,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toJson() {
    return {'top': top, 'left': left, 'width': width, 'height': height};
  }

  factory BodyPartCoordinates.fromJson(Map<String, dynamic> json) {
    return BodyPartCoordinates(
      top: json['top'] ?? 0.0,
      left: json['left'] ?? 0.0,
      width: json['width'] ?? 0.0,
      height: json['height'] ?? 0.0,
    );
  }
}

@HiveType(typeId: 10)
class BodyPartModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String bodyPartName;

  @HiveField(2)
  String muscleCategory;

  @HiveField(3)
  String view; // "front" or "back"

  @HiveField(4)
  BodyPartCoordinates coordinates;

  BodyPartModel({
    required this.id,
    required this.bodyPartName,
    required this.muscleCategory,
    required this.view,
    required this.coordinates,
  });

  BodyPartModel copyWith({
    String? id,
    String? bodyPartName,
    String? muscleCategory,
    String? view,
    BodyPartCoordinates? coordinates,
  }) {
    return BodyPartModel(
      id: id ?? this.id,
      bodyPartName: bodyPartName ?? this.bodyPartName,
      muscleCategory: muscleCategory ?? this.muscleCategory,
      view: view ?? this.view,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bodyPartName': bodyPartName,
      'muscleCategory': muscleCategory,
      'view': view,
      'coordinates': coordinates.toJson(),
    };
  }

  factory BodyPartModel.fromJson(Map<String, dynamic> json) {
    return BodyPartModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      bodyPartName: json['bodyPartName'] ?? '',
      muscleCategory: json['muscleCategory'] ?? '',
      view: json['view'] ?? 'front',
      coordinates: BodyPartCoordinates.fromJson(json['coordinates']),
    );
  }
}
