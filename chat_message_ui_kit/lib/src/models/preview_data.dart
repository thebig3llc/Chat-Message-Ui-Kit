import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preview_data.g.dart';

/// Represents metadata extracted from a web URL for displaying rich link previews.
/// This data is typically obtained by parsing Open Graph tags, Twitter Card metadata,
/// or other structured data from web pages when a user shares a link in chat.
///
/// Link previews enhance the chat experience by showing:
/// - Website titles and descriptions
/// - Preview images or thumbnails
/// - Formatted cards instead of plain URLs
///
/// The data is fetched asynchronously when URLs are detected in messages and can be
/// cached to avoid repeated network requests for the same links.
@JsonSerializable()
@immutable
abstract class PreviewData extends Equatable {
  /// Private constructor for creating PreviewData instances.
  /// Used internally by factory constructors to ensure proper initialization.
  const PreviewData._({this.description, this.image, this.link, this.title});

  /// Description text extracted from the web page metadata.
  /// Typically sourced from Open Graph 'og:description' meta tag or Twitter Card description.
  /// Provides a brief summary of the linked content to help users understand what
  /// they'll see before clicking the link. Can be null if no description is available.
  final String? description;

  /// Image metadata associated with the link preview.
  /// Contains the preview image URL along with dimensions for proper layout.
  /// Sourced from og:image, Twitter Card images, or other preview image meta tags.
  final PreviewDataImage? image;

  /// The original URL that this preview data represents.
  /// This is the cleaned/canonical version of the URL that was detected in the message.
  /// Used for navigation when users tap on the preview card.
  final String? link;

  /// Title of the web page or content being previewed.
  /// Typically extracted from og:title meta tag, Twitter Card title, or HTML <title>.
  /// Displayed prominently in the preview card to give users context about the content.
  final String? title;

  /// Factory constructor that creates PreviewData from JSON map.
  /// Used for deserializing cached preview data or data received from APIs.
  /// Utilizes json_serializable generated code for reliable deserialization.
  factory PreviewData.fromJson(Map<String, dynamic> json) {
    return _$PreviewDataFromJson(json);
  }

  /// Converts this PreviewData instance to a JSON-serializable map.
  /// Used for caching preview data locally or sending to APIs.
  /// Utilizes json_serializable generated code for consistent serialization.
  Map<String, dynamic> toJson() {
    return _$PreviewDataToJson(this);
  }

  /// Main factory constructor for creating PreviewData instances.
  /// All parameters are optional since web pages may not have complete metadata.
  /// This flexibility allows the system to create previews even with partial data.
  const factory PreviewData({
    String? description,
    PreviewDataImage? image,
    String? link,
    String? title,
  }) = _PreviewData;

  /// Defines properties used for equality comparison between PreviewData instances.
  /// Two preview data objects are equal if all metadata fields match.
  /// Used for caching, deduplication, and UI update optimizations.
  @override
  List<Object?> get props => [description, image, link, title];

  /// Creates a new PreviewData instance with updated properties.
  /// Only the provided parameters are changed; others retain their original values.
  /// Useful for updating preview data when additional metadata becomes available.
  PreviewData copyWith({
    String? description,
    PreviewDataImage? image,
    String? link,
    String? title,
  });
}

/// Private implementation class that provides concrete copyWith functionality.
/// Uses the _Unset pattern to distinguish between null values and omitted parameters,
/// allowing precise control over which properties to update.
class _PreviewData extends PreviewData {
  /// Constructor that delegates to the parent PreviewData private constructor.
  /// Maintains the same parameter structure while enabling copyWith implementation.
  const _PreviewData({super.description, super.image, super.link, super.title})
    : super._();

  /// Implementation of copyWith using the _Unset pattern for precise updates.
  /// Parameters marked as _Unset retain their original values, while others are updated.
  /// This allows setting fields to null explicitly vs leaving them unchanged.
  @override
  PreviewData copyWith({
    dynamic description = _Unset,
    dynamic image = _Unset,
    dynamic link = _Unset,
    dynamic title = _Unset,
  }) => _PreviewData(
    description:
        description == _Unset ? this.description : description as String?,
    image: image == _Unset ? this.image : image as PreviewDataImage?,
    link: link == _Unset ? this.link : link as String?,
    title: title == _Unset ? this.title : title as String?,
  );
}

/// Sentinel class used to differentiate between explicit null values and omitted
/// parameters in copyWith methods. Enables precise control over property updates.
class _Unset {}

/// Represents an image associated with a link preview, including dimensions.
/// Stores both the image URL and its width/height to enable proper layout
/// calculation before the image loads, preventing UI jumps and improving UX.
///
/// The dimensions are essential for:
/// - Calculating aspect ratios for responsive layouts
/// - Reserving proper space before image loads
/// - Determining optimal display sizes for different screen densities
/// - Preventing content layout shifts during image loading
///
/// Based on flutter_link_previewer implementation patterns.
/// See https://github.com/flyerhq/flutter_link_previewer.
@JsonSerializable()
@immutable
class PreviewDataImage extends Equatable {
  /// Creates a PreviewDataImage with URL and dimensions.
  /// All parameters are required to ensure complete image metadata.
  /// The dimensions should match the actual image size for accurate layout.
  const PreviewDataImage({
    required this.height,
    required this.url,
    required this.width,
  });

  /// Height of the image in pixels.
  /// Used for calculating aspect ratios and reserving layout space.
  /// Should match the actual image dimensions for accurate rendering.
  final double height;

  /// URL pointing to the remote image resource.
  /// This is typically extracted from og:image, Twitter Card image,
  /// or other preview image meta tags from the web page.
  final String url;

  /// Width of the image in pixels.
  /// Used for calculating aspect ratios and determining display sizes.
  /// Should match the actual image dimensions for proper scaling.
  final double width;

  /// Factory constructor that creates PreviewDataImage from JSON map.
  /// Used for deserializing cached image data or data from preview APIs.
  /// Utilizes json_serializable generated code for reliable deserialization.
  factory PreviewDataImage.fromJson(Map<String, dynamic> json) {
    return _$PreviewDataImageFromJson(json);
  }

  /// Converts this PreviewDataImage to a JSON-serializable map.
  /// Used for caching image metadata or sending to preview services.
  /// Utilizes json_serializable generated code for consistent serialization.
  Map<String, dynamic> toJson() {
    return _$PreviewDataImageToJson(this);
  }

  /// Defines properties used for equality comparison between PreviewDataImage instances.
  /// Two images are equal if they have the same URL and dimensions.
  /// Used for caching, deduplication, and preventing unnecessary re-renders.
  @override
  List<Object> get props => [height, url, width];
}
