/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/app_icon.png
  AssetGenImage get appIcon => const AssetGenImage('assets/icons/app_icon.png');

  /// File path: assets/icons/app_icon_foreground.png
  AssetGenImage get appIconForeground =>
      const AssetGenImage('assets/icons/app_icon_foreground.png');

  /// File path: assets/icons/earth_plane.svg
  String get earthPlane => 'assets/icons/earth_plane.svg';

  String get hourglass_bottom => 'assets/icons/hourglass_bottom.svg';
  String get hourglassTop => 'assets/icons/hourglass_top.svg';

  String get homePlusLoading => 'assets/icons/HomePlus_Loading.svg';

  /// File path: assets/icons/social_apple.svg
  String get socialApple => 'assets/icons/social_apple.svg';

  /// File path: assets/icons/social_email.svg
  String get socialEmail => 'assets/icons/social_email.svg';

  /// File path: assets/icons/social_facebook.svg
  String get socialFacebook => 'assets/icons/social_facebook.svg';

  /// File path: assets/icons/social_google.svg
  String get socialGoogle => 'assets/icons/social_google.svg';

  /// List of all assets
  List<dynamic> get values => [
        appIcon,
        appIconForeground,
        earthPlane,
        socialApple,
        socialEmail,
        socialFacebook,
        socialGoogle
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/beach.svg
  String get beach => 'assets/images/beach.svg';

  /// File path: assets/images/cinnamon.jpeg
  AssetGenImage get cinnamon =>
      const AssetGenImage('assets/images/cinnamon.jpeg');

  /// File path: assets/images/cinnamon_logo.svg
  String get cinnamonLogo => 'assets/images/cinnamon_logo.svg';

  /// File path: assets/images/fun_moments.svg
  String get funMoments => 'assets/images/fun_moments.svg';

  /// File path: assets/images/journey.svg
  String get journey => 'assets/images/journey.svg';

  /// File path: assets/images/social_sharing.svg
  String get socialSharing => 'assets/images/social_sharing.svg';

  /// File path: assets/images/team_collaboration.svg
  String get teamCollaboration => 'assets/images/team_collaboration.svg';

  /// File path: assets/images/travelling.svg
  String get travelling => 'assets/images/travelling.svg';

  /// List of all assets
  List<dynamic> get values => [
        beach,
        cinnamon,
        cinnamonLogo,
        funMoments,
        journey,
        socialSharing,
        teamCollaboration,
        travelling
      ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
