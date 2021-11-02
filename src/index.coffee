module.exports = index =
  rgb: require "./rgbFloat"
  RGB: require "./RGBInt"
  hsv: require "./hsv"
  Lab: require "./Lab"
  LCh: require "./LCh"
  XYZ: require "./XYZ"
  xyY: require "./xyY"
  white: require "./white"
  #gamut: require "./gamut"
  space:
    rgb: require "./space/rgb"
    lab: require "./space/lab"

# create global index if in browser
if window?
  window.c0lor = index
