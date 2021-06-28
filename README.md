# color_randomizer

Creates random ARGB colors for Dart projects.

Colors are configurable based upon the config you provide for the alpha, red, green and blue channels.
Primary entrypoint is the `RandomARGB` class, configurable with `HexRange` which should contain values between 0 and 255.

Factory methods are provided in `RandomARGB` to easily get random variations for:
- red
- green
- blue
- yellow (red and green)
- magenta (red and blue)
- cyan (green and blue)

## Usage
```dart
import 'dart:ui';
import 'package:color_randomizer/color_randomizer.dart';

void main() {
  // Factory example retrieving a random color with alpha at 255
  RandomARGB randomColor = RandomARGB.randomColor(alphaRange: HexRange.maxValue());

  // You retrieve a random color from the config using:
  Color color1 = randomColor.nextColor();

  // Using the default constructor to configure values more precisely.
  RandomARGB randomColor2 = RandomARGB(
      alphaConfig: HexRange(0, 255), // Alpha ranging from 0 - 255
      redConfig: HexRange.fullRange(), // Equivalent to the above HexRange.
      greenConfig: HexRange.firstHalf(), // Equivalent to values ranging from 0 - 128.
      blueConfig: HexRange.secondHalf() // Equivalent to values ranging from 128 - 255.
  );

  // The nextColor() method will always follow the config you have set.
  Color color2 = randomColor2.nextColor();

  // You can disregard the config you initialized it with by using the 
  // RandomARGB methods:
  // - fromAlphaAndColor
  // - fromRange
  // - fromARGBRanges
  
  Color color3 = randomColor2.fromAlphaAndColor(HexRange.maxValue(), HexRange.secondThird());
  Color color4 = randomColor2.fromRange(HexRange.fullRange());
  Color color5 = randomColor2.fromARGBRanges(
      HexRange.fullRange(),
      HexRange.secondHalf(),
      HexRange.firstTenth(),
      HexRange.fifthTenth()
  );

  print("color1: ${color1}, A: ${color1.alpha}, R: ${color1.red}, G: ${color1.green}, B: ${color1.blue}");
  print("color2: ${color2}, A: ${color2.alpha}, R: ${color2.red}, G: ${color2.green}, B: ${color2.blue}");
  print("color3: ${color3}, A: ${color3.alpha}, R: ${color3.red}, G: ${color3.green}, B: ${color3.blue}");
  print("color4: ${color4}, A: ${color4.alpha}, R: ${color4.red}, G: ${color4.green}, B: ${color4.blue}");
  print("color5: ${color5}, A: ${color5.alpha}, R: ${color5.red}, G: ${color5.green}, B: ${color5.blue}");
}

```
## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
