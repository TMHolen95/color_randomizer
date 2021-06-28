import 'dart:ui';
import 'package:color_randomizer/color_randomizer.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Next color works', () {
    final randomColor = RandomARGB(
        alphaConfig: HexRange.fullRange(),
        redConfig: HexRange.fullRange(),
        greenConfig: HexRange.fullRange(),
        blueConfig: HexRange.fullRange());

    for (int i = 0; i < 10000; i++) {
      Color c = randomColor.nextColor();
      expect(c.alpha <= 255 && c.alpha >= 0, true,
          reason: "Should be constrained between 0 and 255");
      expect(c.red <= 255 && c.red >= 0, true,
          reason: "Should be constrained between 0 and 255");
      expect(c.green <= 255 && c.green >= 0, true,
          reason: "Should be constrained between 0 and 255");
      expect(c.blue <= 255 && c.blue >= 0, true,
          reason: "Should be constrained between 0 and 255");
    }
  });

  test('Factory fullRanges works', () {
    final randomColor =
        RandomARGB.randomColor(alphaRange: HexRange.fullRange());

    for (int i = 0; i < 10000; i++) {
      Color c = randomColor.nextColor();
      expect(c.alpha <= 255 && c.alpha >= 0, true,
          reason: "Should be constrained between 0 and 255");
      expect(c.red <= 255 && c.red >= 0, true,
          reason: "Should be constrained between 0 and 255");
      expect(c.green <= 255 && c.green >= 0, true,
          reason: "Should be constrained between 0 and 255");
      expect(c.blue <= 255 && c.blue >= 0, true,
          reason: "Should be constrained between 0 and 255");
    }
  });

  test('Factory randomColor gives expected ranges', () {
    final randomColor = RandomARGB.randomColor();

    for (int i = 0; i < 10000; i++) {
      Color c = randomColor.nextColor();
      expect(c.alpha == 255, true, reason: "Should be 255");
      expect(c.red <= 255 && c.red >= 0, true,
          reason: "Should be constrained between 0 and 255");
      expect(c.green <= 255 && c.green >= 0, true,
          reason: "Should be constrained between 0 and 255");
      expect(c.blue <= 255 && c.blue >= 0, true,
          reason: "Should be constrained between 0 and 255");
    }
  });

  test('RandomColor from specific range works', () {
    final randomColor = RandomARGB.randomColor();

    for (int i = 0; i < 100; i++) {
      Color c = randomColor.fromRange(HexRange(0, 10));
      expect(c.alpha <= 10 && c.alpha >= 0, true,
          reason: "Should be constrained between 0 and 10");
      expect(c.red <= 10 && c.red >= 0, true,
          reason: "Should be constrained between 0 and 10");
      expect(c.green <= 10 && c.green >= 0, true,
          reason: "Should be constrained between 0 and 10");
      expect(c.blue <= 10 && c.blue >= 0, true,
          reason: "Should be constrained between 0 and 10");

      Color c2 = randomColor.fromRange(HexRange(245, 255));
      expect(c2.alpha <= 255 && c2.alpha >= 245, true,
          reason: "Should be constrained between 245 and 255 ");
      expect(c2.red <= 255 && c2.red >= 245, true,
          reason: "Should be constrained between 245 and 255 ");
      expect(c2.green <= 255 && c2.green >= 245, true,
          reason: "Should be constrained between 245 and 255 ");
      expect(c2.blue <= 255 && c2.blue >= 245, true,
          reason: "Should be constrained between 245 and 255");
    }
  });

  test('RandomColor from specific ARGB ranges works', () {
    final randomColor = RandomARGB.randomColor();

    for (int i = 0; i < 100; i++) {
      Color c = randomColor.fromARGBRanges(HexRange(0, 10), HexRange(25, 50),
          HexRange(100, 110), HexRange(240, 255));
      expect(c.alpha <= 10 && c.alpha >= 0, true,
          reason: "Should be constrained between 0 and 10");
      expect(c.red <= 50 && c.red >= 25, true,
          reason: "Should be constrained between 25 and 50");
      expect(c.green <= 110 && c.green >= 100, true,
          reason: "Should be constrained between 100 and 110");
      expect(c.blue <= 255 && c.blue >= 240, true,
          reason: "Should be constrained between 240 and 255");
    }
  });

  test('RandomColor from specific Alpha and Color Range works', () {
    final randomColor = RandomARGB.randomColor();

    for (int i = 0; i < 100; i++) {
      Color c =
          randomColor.fromAlphaAndColor(HexRange(0, 128), HexRange(128, 255));
      expect(c.alpha <= 128 && c.alpha >= 0, true,
          reason: "Should be constrained between 0 and 128 ");
      expect(c.red <= 255 && c.red >= 128, true,
          reason: "Should be constrained between 128 and 255");
      expect(c.green <= 255 && c.green >= 128, true,
          reason: "Should be constrained between 128 and 255");
      expect(c.blue <= 255 && c.blue >= 128, true,
          reason: "Should be constrained between 128 and 255");
    }
  });
}
