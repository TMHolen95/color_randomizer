library color_randomizer;

import 'dart:math' as Math;
import 'dart:ui';

abstract class RandomARGBMethods {
  final _r = Math.Random();

  Color nextColor();
  List<Color> getUniqueColors(int colorAmount,
      {Color loopBreakerColor = const Color(0xffffffff)});
  Color fromRange(HexRange alphaAndColor, {int resolution});
  Color fromAlphaAndColor(HexRange alpha, HexRange colors, {int resolution});
  Color fromARGBRanges(
      HexRange alpha, HexRange red, HexRange green, HexRange blue,
      {int resolution});

  /// Returns the absolute value of the RGB color channels - summed up.
  ///
  /// Alpha can be included as a color channel in the abs calculation.
  static int absoluteDifference(Color color1, Color color2, {bool alphaIncluded = false}) {
    var alphaAbs = alphaIncluded ? (color1.alpha - color2.alpha).abs() : 0;
    return alphaAbs +
    (color1.red - color2.red).abs() +
    (color1.green - color2.green).abs() +
    (color1.blue - color2.blue).abs();
  }

  /// Gives a random number, depending on the HexRange constraints and the resolution.
  ///
  /// `range` - f.ex: HexRange(0, 255)
  ///
  /// `resolution` - recommended to be either 1, 3, 5, 15, 51 or 85,
  /// for hex ranges from 0 to 255.
  /// A resolution of 5 would give values from: 0, 5, 10, ... , 255.
  int randomHexValue(HexRange range, {int resolution = 1}) {
    assert(resolution > 0, "Resolution should be larger than 0");
    int maxValue = (range.max - range.min + resolution) ~/ resolution;
    int rangeOffset = range.min ~/ resolution;
    return (_r.nextInt(maxValue) + rangeOffset) * resolution;
  }
}

enum ARGBChannel { alpha, red, green, blue }

/// Provides Random ARGB colors from a set [HexRange] config
/// on each ARGB channel.
class RandomARGB extends RandomARGBMethods {
  final HexRange alphaConfig;
  final HexRange redConfig;
  final HexRange greenConfig;
  final HexRange blueConfig;
  final int resolution;

  /// Provides random colors from the specified [HexRange]s.
  RandomARGB(
      {required this.alphaConfig,
      required this.redConfig,
      required this.greenConfig,
      required this.blueConfig,
      this.resolution = 1});

  factory RandomARGB.randomColor({
    HexRange alphaRange = const HexRange(255, 255),
    int resolution = 1,
  }) =>
      RandomARGB(
          alphaConfig: alphaRange,
          redConfig: HexRange.fullRange(),
          greenConfig: HexRange.fullRange(),
          blueConfig: HexRange.fullRange(),
          resolution: resolution);

  factory RandomARGB.redValues({
    HexRange alphaRange = const HexRange(255, 255),
    HexRange colorRange = const HexRange(0, 255),
    int resolution = 1,
  }) =>
      RandomARGB(
          alphaConfig: alphaRange,
          redConfig: colorRange,
          greenConfig: HexRange.zeroValue(),
          blueConfig: HexRange.zeroValue(),
          resolution: resolution);

  factory RandomARGB.greenValues({
    HexRange alphaRange = const HexRange(255, 255),
    HexRange colorRange = const HexRange(0, 255),
    int resolution = 1,
  }) =>
      RandomARGB(
          alphaConfig: alphaRange,
          redConfig: HexRange.zeroValue(),
          greenConfig: colorRange,
          blueConfig: HexRange.zeroValue(),
          resolution: resolution);

  factory RandomARGB.blueValues(
          {HexRange alphaRange = const HexRange(255, 255),
          HexRange colorRange = const HexRange(0, 255),
          resolution = 1}) =>
      RandomARGB(
          alphaConfig: alphaRange,
          redConfig: HexRange.zeroValue(),
          greenConfig: HexRange.zeroValue(),
          blueConfig: colorRange,
          resolution: resolution);

  factory RandomARGB.magenta(
          {HexRange alphaRange = const HexRange(255, 255),
          HexRange colorRange = const HexRange(0, 255),
          resolution = 1}) =>
      RandomARGB(
          alphaConfig: alphaRange,
          redConfig: colorRange,
          greenConfig: HexRange.zeroValue(),
          blueConfig: colorRange,
          resolution: resolution);

  factory RandomARGB.yellow(
          {HexRange alphaRange = const HexRange(255, 255),
          HexRange colorRange = const HexRange(0, 255),
          resolution = 1}) =>
      RandomARGB(
          alphaConfig: alphaRange,
          redConfig: colorRange,
          greenConfig: colorRange,
          blueConfig: HexRange.zeroValue(),
          resolution: resolution);

  factory RandomARGB.cyan(
          {HexRange alphaRange = const HexRange(255, 255),
          HexRange colorRange = const HexRange(0, 255),
          resolution = 1}) =>
      RandomARGB(
          alphaConfig: alphaRange,
          redConfig: HexRange.zeroValue(),
          greenConfig: colorRange,
          blueConfig: colorRange,
          resolution: resolution);

  /// Number from 0 - 255, for the alpha or a color channel [ARGBChannel].
  ///
  /// Note, value is constrained by [HexRange]s configs provided to [RandomARGB]
  int randomHexValueFor(ARGBChannel argbChannel) {
    switch (argbChannel) {
      case ARGBChannel.alpha:
        return randomHexValue(alphaConfig, resolution: resolution);
      case ARGBChannel.red:
        return randomHexValue(redConfig, resolution: resolution);
      case ARGBChannel.green:
        return randomHexValue(greenConfig, resolution: resolution);
      case ARGBChannel.blue:
        return randomHexValue(blueConfig, resolution: resolution);
    }
  }

  @override
  Color nextColor() {
    return Color.fromARGB(
        randomHexValueFor(ARGBChannel.alpha),
        randomHexValueFor(ARGBChannel.red),
        randomHexValueFor(ARGBChannel.green),
        randomHexValueFor(ARGBChannel.blue));
  }

  @override
  List<Color> getUniqueColors(int colorAmount,
      {Color loopBreakerColor = const Color(0xffffffff),
      int maxUniquenessTries = 42}) {
    List<Color> uniqueColors = [];

    void pickUniqueColor({int uniquenessTries = 0}) {
      Color color = nextColor();
      if (uniquenessTries >= maxUniquenessTries) {
        uniqueColors.add(loopBreakerColor);
        print("Color Randomizer Error: unique color could not be generated, providing loop breaker color instead: ${loopBreakerColor.toString()}");
      } else if (uniqueColors.contains(color)) {
        pickUniqueColor(uniquenessTries: ++uniquenessTries);
      } else {
        uniqueColors.add(color);
      }
    }

    for (int i = 0; i < colorAmount; i++) {
      pickUniqueColor();
    }
    return uniqueColors;
  }

  @override
  Color fromARGBRanges(HexRange alphaRange, HexRange redRange,
      HexRange greenRange, HexRange blueRange,
      {resolution = 1}) {
    return Color.fromARGB(
        randomHexValue(alphaRange, resolution: resolution),
        randomHexValue(redRange, resolution: resolution),
        randomHexValue(greenRange, resolution: resolution),
        randomHexValue(blueRange, resolution: resolution));
  }

  @override
  Color fromAlphaAndColor(HexRange alphaRange, HexRange colorRange,
      {resolution = 1}) {
    return Color.fromARGB(
        randomHexValue(alphaRange, resolution: resolution),
        randomHexValue(colorRange, resolution: resolution),
        randomHexValue(colorRange, resolution: resolution),
        randomHexValue(colorRange, resolution: resolution));
  }

  @override
  Color fromRange(HexRange alphaAndColorRange, {resolution = 1}) {
    return Color.fromARGB(
        randomHexValue(alphaAndColorRange, resolution: resolution),
        randomHexValue(alphaAndColorRange, resolution: resolution),
        randomHexValue(alphaAndColorRange, resolution: resolution),
        randomHexValue(alphaAndColorRange, resolution: resolution));
  }
}

/// Specifies the range we want from 0 to 255.
///
/// Contains factories for easy access to values constraining
/// the color config to multiples of fractions ranging from:
/// 1/2, 1/3, ... , 1/10.
class HexRange {
  final int max;
  final int min;

  /// Only use values between 0 and 255.
  const HexRange(this.min, this.max);

  /// HexRange(255, 255)
  factory HexRange.maxValue() => const HexRange(255, 255);

  /// HexRange(0, 0)
  factory HexRange.zeroValue() => const HexRange(0, 0);

  /// HexRange(0, 255)
  factory HexRange.fullRange() => const HexRange(0, 255);

  // Factories below are for convenience.

  /// HexRange(0, 128)
  factory HexRange.firstHalf() => const HexRange(0, 128);

  /// HexRange(128, 255)
  factory HexRange.secondHalf() => const HexRange(128, 255);

  /// HexRange(0, 85)
  factory HexRange.firstThird() => const HexRange(0, 85);

  /// HexRange(85, 170)
  factory HexRange.secondThird() => const HexRange(85, 170);

  /// HexRange(170, 255)
  factory HexRange.thirdThird() => const HexRange(170, 255);

  /// HexRange(0, 64)
  factory HexRange.firstQuarter() => const HexRange(0, 64);

  /// HexRange(64, 128)
  factory HexRange.secondQuarter() => const HexRange(64, 128);

  /// HexRange(128, 192)
  factory HexRange.thirdQuarter() => const HexRange(128, 192);

  /// HexRange(192, 255)
  factory HexRange.fourthQuarter() => const HexRange(192, 255);

  /// HexRange(0, 51)
  factory HexRange.firstFifth() => const HexRange(0, 51);

  /// HexRange(51, 102)
  factory HexRange.secondFifth() => const HexRange(51, 102);

  /// HexRange(102, 153)
  factory HexRange.thirdFifth() => const HexRange(102, 153);

  /// HexRange(153, 204)
  factory HexRange.fourthFifth() => const HexRange(153, 204);

  /// HexRange(204, 255)
  factory HexRange.fifthFifth() => const HexRange(204, 255);

  /// HexRange(0, 43)
  factory HexRange.firstSixth() => const HexRange(0, 43);

  /// HexRange(43, 85)
  factory HexRange.secondSixth() => const HexRange(43, 85);

  /// HexRange(85, 128)
  factory HexRange.thirdSixth() => const HexRange(85, 128);

  /// HexRange(128, 170)
  factory HexRange.fourthSixth() => const HexRange(128, 170);

  /// HexRange(170, 213)
  factory HexRange.fifthSixth() => const HexRange(170, 213);

  /// HexRange(213, 255)
  factory HexRange.sixthSixth() => const HexRange(213, 255);

  /// HexRange(0, 36)
  factory HexRange.firstSeventh() => const HexRange(0, 36);

  /// HexRange(36, 73)
  factory HexRange.secondSeventh() => const HexRange(36, 73);

  /// HexRange(73, 109)
  factory HexRange.thirdSeventh() => const HexRange(73, 109);

  /// HexRange(109, 146)
  factory HexRange.fourthSeventh() => const HexRange(109, 146);

  /// HexRange(146, 182)
  factory HexRange.fifthSeventh() => const HexRange(146, 182);

  /// HexRange(182, 219)
  factory HexRange.sixthSeventh() => const HexRange(182, 219);

  /// HexRange(219, 255)
  factory HexRange.seventhSeventh() => const HexRange(219, 255);

  /// HexRange(0, 32)
  factory HexRange.firstEighth() => const HexRange(0, 32);

  /// HexRange(32, 64)
  factory HexRange.secondEighth() => const HexRange(32, 64);

  /// HexRange(64, 96)
  factory HexRange.thirdEighth() => const HexRange(64, 96);

  /// HexRange(96, 128)
  factory HexRange.fourthEighth() => const HexRange(96, 128);

  /// HexRange(128, 159)
  factory HexRange.fifthEighth() => const HexRange(128, 159);

  /// HexRange(159, 191)
  factory HexRange.sixthEighth() => const HexRange(159, 191);

  /// HexRange(191, 223)
  factory HexRange.seventhEighth() => const HexRange(191, 223);

  /// HexRange(223, 255)
  factory HexRange.eighthEighth() => const HexRange(223, 255);

  /// HexRange(0, 28)
  factory HexRange.firstNinth() => const HexRange(0, 28);

  /// HexRange(28, 57)
  factory HexRange.secondNinth() => const HexRange(28, 57);

  /// HexRange(57, 85)
  factory HexRange.thirdNinth() => const HexRange(57, 85);

  /// HexRange(85, 113)
  factory HexRange.fourthNinth() => const HexRange(85, 113);

  /// HexRange(113, 142)
  factory HexRange.fifthNinth() => const HexRange(113, 142);

  /// HexRange(142, 170)
  factory HexRange.sixthNinth() => const HexRange(142, 170);

  /// HexRange(170, 198)
  factory HexRange.seventhNinth() => const HexRange(170, 198);

  /// HexRange(198, 223)
  factory HexRange.eighthNinth() => const HexRange(198, 223);

  /// HexRange(223, 255)
  factory HexRange.ninthNinth() => const HexRange(223, 255);

  /// HexRange(0, 26)
  factory HexRange.firstTenth() => const HexRange(0, 26);

  /// HexRange(26, 51)
  factory HexRange.secondTenth() => const HexRange(26, 51);

  /// HexRange(51, 77)
  factory HexRange.thirdTenth() => const HexRange(51, 77);

  /// HexRange(77, 102)
  factory HexRange.fourthTenth() => const HexRange(77, 102);

  /// HexRange(102, 128)
  factory HexRange.fifthTenth() => const HexRange(102, 128);

  /// HexRange(128, 153)
  factory HexRange.sixthTenth() => const HexRange(128, 153);

  /// HexRange(153, 179)
  factory HexRange.seventhTenth() => const HexRange(153, 179);

  /// HexRange(179, 204)
  factory HexRange.eighthTenth() => const HexRange(179, 204);

  /// HexRange(204, 230)
  factory HexRange.ninthTenth() => const HexRange(204, 230);

  /// HexRange(230, 255)
  factory HexRange.tenthTenth() => const HexRange(230, 255);

  /// Form a new Hex range from the lowest and highest values
  /// from two [HexRange]s.
  factory HexRange.lowestAndHighestFrom(HexRange range1, HexRange range2) {
    int min = Math.min(range1.min, range2.min);
    int max = Math.max(range1.max, range2.max);

    return HexRange(min, max);
  }
}
