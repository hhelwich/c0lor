# Imports / Shortcuts
# -------------------

xyz = require "./xyz"
white = require "./whites"
M = require "../math/matrix"
lu = require "../math/luDecomposition"
createConstructor = (require "../util/obj").createConstructor

xyY = xyz.xyY

pow = Math.pow
round = Math.round

# Helpers
# -------

gammaSRgb = (x) ->
  if x <= 0.04045
    x / 12.92;
  else
    pow (x + 0.055) / 1.055, 2.4

gammaSRgbInv = (x) ->
  if x <= 0.0031308
    x * 12.92
  else
    1.055 * (pow x, 1 / 2.4) - 0.055

cutByte = (b) ->
  if 0 <= b <= 255 then b else undefined

toByte = (d) ->
  cutByte round d * 255

fromByte = (b) ->
  if b == undefined then b else b / 255

to2Hex = (b) ->
  hex = do (b.toString 16).toUpperCase
  if hex.length == 1 then "0" + hex else hex

from2Hex = (str) ->
  parseInt str, 16

validRgbEl = (x) ->
  (isFinite x) and 0 <= x <= 1

# RGB prototype
# -------------

rgbPrototype =

  RGB: (T = do createRgbByte) ->
    T.R = toByte @r
    T.G = toByte @g
    T.B = toByte @b
    T

  set: (@r, @g, @b) ->
    @

  isDefined: ->
    @r? and @g? and @b?

  isValid: ->
    do @isDefined and (validRgbEl @r) and (validRgbEl @g) and (validRgbEl @b)

  toString: ->
    "r=#{@r}, g=#{@g}, b=#{@b}"


# RGB 3 byte prototype
# --------------------

rgbBytePrototype =

  rgb: (T = do createRgb) ->
    T.r = fromByte @R
    T.g = fromByte @G
    T.b = fromByte @B
    T

  hex: (str) ->
    if str?
      @R = from2Hex str.substring 0, 2
      @G = from2Hex str.substring 2, 4
      @B = from2Hex str.substring 4, 6
      @
    else
      if do @isDefined then (to2Hex @R) + (to2Hex @G) + (to2Hex @B) else undefined

  isDefined: ->
    @R? and @G? and @B?

  toString: ->
    "R=#{@R}, G=#{@G}, B=#{@B}"


# RGB space constructor
# ---------------------

rgbSpaceConstructor = (@red, @green, @blue, @white, gamma, gammaInv) ->
  if typeof gamma == "function"
    @gamma = gamma
    @gammaInv = gammaInv
  else
    @g = gamma
    @gInv = 1 / gamma
  # assume: white.Y = 1
  @fromXYZ = (XYZ, T) ->
    do @init
    @fromXYZ XYZ, T
  @toXYZ = (Rgb, T) ->
    do @init
    @toXYZ Rgb, T

# RGB space prototype
# -------------------

rgbSpacePrototype =

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
      bxyz = bxyz.mult M.diag w
      @base = bxyz.array
      @baseInv = (lu bxyz).getInverse().array

      delete @toXYZ
      delete @fromXYZ
      return

  gamma: (x) ->
    pow(x, @g)

  gammaInv: (x) ->
    pow(x, @gInv)

  fromXYZ: (XYZ, T = do createRgb) ->
    a = @baseInv
    T.r = @gammaInv a[0] * XYZ.X + a[1] * XYZ.Y + a[2] * XYZ.Z
    T.g = @gammaInv a[3] * XYZ.X + a[4] * XYZ.Y + a[5] * XYZ.Z
    T.b = @gammaInv a[6] * XYZ.X + a[7] * XYZ.Y + a[8] * XYZ.Z
    T

  toXYZ: (Rgb, T = xyz.XYZ()) ->
    a = @base
    gr = @gamma Rgb.r
    gg = @gamma Rgb.g
    gb = @gamma Rgb.b
    T.X = a[0] * gr + a[1] * gg + a[2] * gb
    T.Y = a[3] * gr + a[4] * gg + a[5] * gb
    T.Z = a[6] * gr + a[7] * gg + a[8] * gb
    T




# Public api
# ----------

module.exports = createRgbSpace = createConstructor rgbSpacePrototype, rgbSpaceConstructor,
  rgb: createRgb = createConstructor rgbPrototype, (@r, @g, @b) ->
  RGB: createRgbByte = createConstructor rgbBytePrototype, (@R, @G, @B) ->
  extendRgb: (f) -> f rgbPrototype

createRgbSpace.space =
  "Adobe-98":    createRgbSpace (xyY 0.6400, 0.3300), (xyY 0.2100, 0.7100), (xyY 0.1500, 0.0600), white.D65, 2.2
  "Adobe-RGB":   createRgbSpace (xyY 0.6250, 0.3400), (xyY 0.2800, 0.5950), (xyY 0.1550, 0.0700), white.D65, 1.8
  "CIE-RGB":     createRgbSpace (xyY 0.7350, 0.2650), (xyY 0.2740, 0.7170), (xyY 0.1670, 0.0090), white.E  , 1
  "ColorMatch":  createRgbSpace (xyY 0.6300, 0.3400), (xyY 0.2950, 0.6050), (xyY 0.1500, 0.0750), white.D50, 1.8
  "EBU-Monitor": createRgbSpace (xyY 0.6314, 0.3391), (xyY 0.2809, 0.5971), (xyY 0.1487, 0.0645), white.D50, 1.9
  "ECI-RGB":     createRgbSpace (xyY 0.6700, 0.3300), (xyY 0.2100, 0.7100), (xyY 0.1400, 0.0800), white.D50, 1.8
  "HDTV":        createRgbSpace (xyY 0.6400, 0.3300), (xyY 0.2900, 0.6000), (xyY 0.1500, 0.0600), white.D65, 2.2
  "Kodak-DC":    createRgbSpace (xyY 0.6492, 0.3314), (xyY 0.3219, 0.5997), (xyY 0.1548, 0.0646), white.D50, 2.22
  "NTSC-53":     createRgbSpace (xyY 0.6700, 0.3300), (xyY 0.2100, 0.7100), (xyY 0.1400, 0.0800), white.C  , 2.2
  "PAL-SECAM":   createRgbSpace (xyY 0.6400, 0.3300), (xyY 0.2900, 0.6000), (xyY 0.1500, 0.0600), white.D65, 2.2
  "sRGB":        createRgbSpace (xyY 0.6400, 0.3300), (xyY 0.3000, 0.6000), (xyY 0.1500, 0.0600), white.D65, gammaSRgb,
                                                                                                             gammaSRgbInv
  "WideGamut":   createRgbSpace (xyY 0.7347, 0.2653), (xyY 0.1152, 0.8264), (xyY 0.1566, 0.0177), white.D50, 2.2

