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

gammaSRgbInverse = (x) ->
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
  constructor: (@white, @red, @green, @blue, @g) ->
    @gInv = 1 / g
    # assume: white.Y = 1
    @fromXYZ = (XYZ, T) ->
      @init()
      @fromXYZ XYZ, T

    @toXYZ = (Rgb, T) ->
      @init()
      @toXYZ Rgb, T

  init: ->
    if not @baseXYZ?
      # create xyz base (luminance is unknown => need to multiply each column by a scalar)
      bxyz = M [
            @red.x         ,     @green.x           ,     @blue.x
                     @red.y,                @green.y,               @blue.y
        1 - @red.x - @red.y, 1 - @green.x - @green.y, 1 - @blue.x - @blue.y
      ]
      # calculate LU decomposition of xyz base
      bxyzLU = lu bxyz
      # calculate white point in XYZ from chromaticity (luminance should be 1)
      w = @white.XYZ()
      w = M [ w.X, w.Y, w.Z ], 1
      # get the needed scales or the columns of bxyz (sum of the columns of the base must be the white point)
      bxyzLU.solve w, w # calculate in place
      # scale bxyz to get the wanted XYZ base (sum of columns is white point)
      @base = bxyz.mult(M.diag w)
      @baseLU = lu @base

      delete @toXYZ
      delete @fromXYZ

  gamma: (x) ->
    pow(x, @g)

  gammaInv: (x) ->
    pow(x, @gInv)

  fromXYZ: (XYZ, T = new Rgb) ->
    c = M [ XYZ.X, XYZ.Y, XYZ.Z ], 1
    @baseLU.solve c, c
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
module.exports = (white) ->
  new RgbCS(white)

module.exports.rgb = (r, g, b) ->
  new Rgb(r, g, b)

module.exports.RGB = (R, G, B) ->
  new RGB(R, G, B)

module.exports.space =
  'Adobe-98': new RgbCS(
    white.D65
    xyY(0.6400, 0.3300)
    xyY(0.2100, 0.7100)
    xyY(0.1500, 0.0600)
    2.2
  )


