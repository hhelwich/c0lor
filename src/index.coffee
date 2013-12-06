
{createConstructor} = require "ut1l/obj"

module.exports =
  rgb: require "./rgb"
  RGB: require "./RGB"
  hsv: require "./hsv"
  Lab: require "./Lab"
  LCh: require "./LCh"
  XYZ: require "./XYZ"
  xyY: require "./xyY"
  white: require "./white"
  space:
    rgb: require "./space/rgb"
    lab: require "./space/lab"
