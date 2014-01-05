c0lor [![.](https://badge.fury.io/js/c0lor.png)](http://badge.fury.io/js/c0lor) [![.](https://travis-ci.org/hhelwich/c0lor.png?branch=master)](https://travis-ci.org/hhelwich/c0lor) [![.](https://coveralls.io/repos/hhelwich/c0lor/badge.png)](https://coveralls.io/r/hhelwich/c0lor)
=====

A color space conversion library to use in the browser or node.js. It currently contains:

* RGB, HSV color space
* XYZ, xyY color space
* Lab, LCh color space


Browser
-------

To use the library in the browser, you need to include [this](https://raw.github.com/hhelwich/c0lor/master/c0lor.min.js) JavaScript file:

```html
<script src="c0lor.min.js"></script>
```

It exports the global `c0lor` object. You can create an alias variable if you like:

```javascript
var C = c0lor;
```

node.js
-------

You can install this package with:

```
npm install c0lor
```

You can load the global module:

```javascript
var C = require('c0lor');
```

You can also require directly on submodules
(can e.g. be useful with [browserify](https://github.com/substack/node-browserify)):

```javascript
var rgb = require('c0lor/rgb'); // same as: require('c0lor').rgb;
```


Examples
========

Color Creation
--------------

```javascript
var cyan_rgb, red_RGB, yellow_RGB, magenta_hsv,
    green_XYZ, orange_xyY, purple_Lab, blue_LCh;

// create RGB colors:
cyan_rgb = C.rgb(0, 1, 1);
red_RGB = C.RGB(255, 0, 0);
yellow_RGB = C.RGB().hex('FFFF00');

// create HSV color:
magenta_hsv = C.hsv(0.8, 1, 1);

// create XYZ and xyY color:
green_XYZ = C.XYZ(0.4, 0.7, 0.2);
orange_xyY = C.xyY(0.5, 0.4, 0.3);

// create Lab and LCh color:
purple_Lab = C.Lab(31, 24, -22);
blue_LCh = C.LCh(30, 56, -1);
```

Simple Conversions
------------------

```javascript
var cyan_RGB, red_hexStr, yellow_rgb, magenta_rgb, yellow_hsv,
    green_xyY, orange_XYZ, purple_LCh, blue_Lab;

// convert between RGB color spaces:
cyan_RGB = cyan_rgb.RGB();
red_hexStr = red_RGB.hex();
yellow_rgb = yellow_RGB.rgb();

// convert between hsv and rgb color space:
magenta_rgb = magenta_hsv.rgb();
yellow_hsv = yellow_rgb.hsv();

// convert between XYZ and xyY color space:
green_xyY = green_XYZ.xyY();
orange_XYZ = orange_xyY.XYZ();

// convert between Lab and LCh color space:
purple_LCh = purple_Lab.LCh();
blue_Lab = blue_LCh.Lab();
```

Instead of creating a new color, you can also pass an existing color which will be used to store the result:

```javascript
// convert hsv to rgb color:
hsvColor.rgb(rgbColor);
```

rgb ↔ XYZ Conversion
--------------------

To convert between rgb and XYZ color spaces you need to pick one of the predefined rgb color space definitions or create
one by yourself.
The following rgb color spaces are included:

    Adobe-98, Adobe-RGB, CIE-RGB, ColorMatch, EBU-Monitor, ECI-RGB, HDTV, Kodak-DC, NTSC-53, PAL-SECAM, sRGB, WideGamut

Use predefined rgb color spaces to convert colors:

```javascript
var sRGB, adobe98, cyan_XYZ;

// create alias to rgb color spaces:
sRGB = C.space.rgb.sRGB;
adobe98 = C.space.rgb['Adobe-98'];

// convert color from sRGB to XYZ color space:
cyan_XYZ = sRGB.XYZ(cyan_rgb);
// convert color from XYZ to Adobe-98 color space:
cyan_rgb = adobe98.rgb(cyan_XYZ);
```

Instead of creating a new color, you can also pass an existing color which will be used to store the result:

```javascript
// convert color from XYZ to Adobe-98 color space:
adobe98.rgb(cyan_XYZ, cyan_rgb);
```

You can create your own rgb color space if you like:

```javascript
var myRed, myGreen, myBlue, myRgbSpace;

myRed = C.xyY(0.6, 0.3);
myGreen = C.xyY(0.2, 0.7);
myBlue = C.xyY(0.1, 0.1);

myRgbSpace = C.space.rgb(myRed, myGreen, myBlue, C.white.D65, 2.1);
```

Instead of giving a gamma value you can also give a gamma function and its inverse function:

```javascript
myRgbSpace = C.space.rgb(myRed, myGreen, myBlue, C.white.D65, function (x) {
    return Math.pow(x, 2.1);
}, function (x) {
    return Math.pow(x, 1 / 2.1);
});
```

The following white points (in XYZ color space) are included:

    A, B, C, D50, D55, D65, D75, E, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12


Lab ↔ XYZ Conversion
--------------------

Convert between Lab and XYZ color space:

```javascript
var lab50, purple_XYZ, green_Lab;

// create Lab color space with D50 white point
labD50 = C.space.lab(C.white.D50);

// convert color from Lab to XYZ color space:
purple_XYZ = labD50.XYZ(purple_Lab);
// convert color from XYZ to Lab color space:
green_Lab = labD50.Lab(green_XYZ);
```

Instead of creating a new color, you can also pass an existing color which will be used to store the result:

```javascript
// convert color from XYZ to Lab color space:
labD50.Lab(green_XYZ, green_Lab);
```
