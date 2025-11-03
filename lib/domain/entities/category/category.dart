import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String image;
  final String? mobileImage; // Add mobile-optimized image
  final String? body;
  final String? location;

  const Category({
    required this.id,
    required this.name,
    required this.image,
    required this.body,
    required this.location,
    this.mobileImage,
  });

  @override
  List<Object?> get props => [id, name, image, mobileImage, body, location];
}
