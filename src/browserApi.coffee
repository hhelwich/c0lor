rgb = require "./rgb"
require "./hsv"
lab = require "./lab"
xyz = require "./xyz"
createConstructor = (require "ut1l/obj").createConstructor

module.exports =
  rgb: rgb.rgb
  RGB: rgb.RGB
  hsv: rgb.hsv
  Lab: lab.Lab
  LCh: lab.LCh
  XYZ: xyz.XYZ
  xyY: xyz.xyY
  white: require "./white"
  space:
    rgb: createConstructor null, rgb.createSpace, rgb.space
    lab: lab
