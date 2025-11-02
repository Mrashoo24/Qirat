import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String image;
  final String? mobileImage; // Add mobile-optimized image

  const Category({
    required this.id,
    required this.name,
    required this.image,
    this.mobileImage,
  });

  @override
  List<Object?> get props => [id, name, image, mobileImage];
}
