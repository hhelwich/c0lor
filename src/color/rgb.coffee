xyz = require './xyz'
white = require './whites'
M = require '../math/matrix'
lu = require '../math/luDecomposition'

xyY = xyz.xyY

pow = Math.pow
round = Math.round

gammaSRgb = (x) ->
  if (x <= 0.04045)
    return x / 12.92;
  pow((x + 0.055) / 1.055, 2.4)

gammaSRgbInv = (x) ->
  if (x <= 0.0031308)
    return x * 12.92
  1.055 * pow(x, 1 / 2.4) - 0.055

cutByte = (b) ->
  if 0 <= b <= 255 then b else undefined

toByte = (d) ->
  cutByte(round(d * 255))

fromByte = (b) ->
  if b == undefined then b else b / 255

to2Hex = (b) ->
  hex = b.toString(16).toUpperCase()
  if hex.length == 1 then '0' + hex else hex

from2Hex = (str) ->
  parseInt(str, 16)


class Rgb
  constructor: (@r, @g, @b) ->

  RGB: (T = new RGB) ->
    T.R = toByte @r
    T.G = toByte @g
    T.B = toByte @b
    T

  isDefined: ->
    @r? and @g? and @b?


class RGB
  constructor: (@R, @G, @B) ->

  rgb: (T = new Rgb) ->
    T.r = fromByte @R
    T.g = fromByte @G
    T.b = fromByte @B
    T

  hex: (str) ->
    if str?
      @R = from2Hex(str.substring(0, 2))
      @G = from2Hex(str.substring(2, 4))
      @B = from2Hex(str.substring(4, 6))
      @
    else
      if @isDefined() then to2Hex(@R) + to2Hex(@G) + to2Hex(@B) else undefined

  isDefined: ->
    @R? and @G? and @B?


class RgbCS
  constructor: (@red, @green, @blue, @white, gamma, gammaInv) ->
    if typeof gamma == 'function'
      @gamma = gamma
      @gammaInv = gammaInv
    else
      @g = gamma
      @gInv = 1 / gamma
    # assume: white.Y = 1
    @fromXYZ = (XYZ, T) ->
      @init()
      @fromXYZ XYZ, T

    @toXYZ = (Rgb, T) ->
      @init()
      @toXYZ Rgb, T

  init: ->
    if not @base?
      # create xyz base (luminance is unknown => need to multiply each column by a scalar)
      bxyz = M [
            @red.x         ,     @green.x           ,     @blue.x
                     @red.y,                @green.y,               @blue.y
        1 - @red.x - @red.y, 1 - @green.x - @green.y, 1 - @blue.x - @blue.y
      ]
      # calculate LU decomposition of xyz base
      bxyzLU = lu bxyz
      w = M [ @white.X, @white.Y, @white.Z ], 1
      # get the needed scales or the columns of bxyz (sum of the columns of the base must be the white point)
      bxyzLU.solve w, w # calculate in place
      # scale bxyz to get the wanted XYZ base (sum of columns is white point)
      @base = bxyz.mult(M.diag w)
      @baseInv = (lu @base).getInverse()

      delete @toXYZ
      delete @fromXYZ
      return

  gamma: (x) ->
    pow(x, @g)

  gammaInv: (x) ->
    pow(x, @gInv)

  fromXYZ: (XYZ, T = new Rgb) ->
    c = M [ XYZ.X, XYZ.Y, XYZ.Z ], 1
    c = @baseInv.mult c
    T.r = @gammaInv(c.get 0, 0)
    T.g = @gammaInv(c.get 1, 0)
    T.b = @gammaInv(c.get 2, 0)
    T

  toXYZ: (Rgb, T = xyz.XYZ()) ->
    c = M [ @gamma(Rgb.r), @gamma(Rgb.g), @gamma(Rgb.b) ], 1
    c = @base.mult c
    T.X = c.get 0, 0
    T.Y = c.get 1, 0
    T.Z = c.get 2, 0
    T

# public api
module.exports = (red, green, blue, white, gamma, gammaInv) ->
  new RgbCS(red, green, blue, xyY(white.x, white.y, 1).XYZ(), gamma, gammaInv)

module.exports.rgb = (r, g, b) ->
  new Rgb(r, g, b)

module.exports.RGB = (R, G, B) ->
  new RGB(R, G, B)

module.exports.space =
  'Adobe-98': new RgbCS(
    xyY 0.6400, 0.3300
    xyY 0.2100, 0.7100
    xyY 0.1500, 0.0600
    white.D65
    2.2
  )
  'Adobe-RGB': new RgbCS(
    xyY 0.6250, 0.3400
    xyY 0.2800, 0.5950
    xyY 0.1550, 0.0700
    white.D65
    1.8
  )
  'CIE-RGB': new RgbCS(
    xyY 0.7350, 0.2650
    xyY 0.2740, 0.7170
    xyY 0.1670, 0.0090
    white.E
    1
  )
  ColorMatch: new RgbCS(
    xyY 0.6300, 0.3400
    xyY 0.2950, 0.6050
    xyY 0.1500, 0.0750
    white.D50
    1.8
  )
  'EBU-Monitor': new RgbCS(
    xyY 0.6314, 0.3391
    xyY 0.2809, 0.5971
    xyY 0.1487, 0.0645
    white.D50
    1.9
  )
  'ECI-RGB': new RgbCS(
    xyY 0.6700, 0.3300
    xyY 0.2100, 0.7100
    xyY 0.1400, 0.0800
    white.D50
    1.8
  )
  HDTV: new RgbCS(
    xyY 0.6400, 0.3300
    xyY 0.2900, 0.6000
    xyY 0.1500, 0.0600
    white.D65
    2.2
  )
  'Kodak-DC': new RgbCS(
    xyY 0.6492, 0.3314
    xyY 0.3219, 0.5997
    xyY 0.1548, 0.0646
    white.D50
    2.22
  )
  'NTSC-53': new RgbCS(
    xyY 0.6700, 0.3300
    xyY 0.2100, 0.7100
    xyY 0.1400, 0.0800
    white.C
    2.2
  )
  'PAL-SECAM': new RgbCS(
    xyY 0.6400, 0.3300
    xyY 0.2900, 0.6000
    xyY 0.1500, 0.0600
    white.D65
    2.2
  )
  WideGamut: new RgbCS(
    xyY 0.7347, 0.2653
    xyY 0.1152, 0.8264
    xyY 0.1566, 0.0177
    white.D50
    2.2
  )
  sRGB: new RgbCS(
    xyY 0.6400, 0.3300
    xyY 0.3000, 0.6000
    xyY 0.1500, 0.0600
    white.D65
    gammaSRgb, gammaSRgbInv
  )
