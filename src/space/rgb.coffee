# Imports / Shortcuts
# -------------------


{creator} = require "ut1l/obj"

XYZM = require "../XYZ"
xyYM = require "../xyY"
white = require "../white"
M = require "m4th/matrix"
lu = require "m4th/lu"


xyY = xyYM

pow = Math.pow

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


# RGB space constructor
# ---------------------

lazyInitRgbBase = ->
  # create xyz base (luminance is unknown => need to multiply each column by a scalar)
  bxyz = M [
    @red.x         ,     @green.x           ,     @blue.x
    @red.y,                @green.y,               @blue.y
    1 - @red.x - @red.y, 1 - @green.x - @green.y, 1 - @blue.x - @blue.y
  ]
  # calculate LU decomposition of xyz base
  bxyzLU = lu bxyz
  w = M 3, [ @white.X, @white.Y, @white.Z ]
  # get the needed scales or the columns of bxyz (sum of the columns of the base must be the white point)
  bxyzLU.solve w, w # calculate in place
  # scale bxyz to get the wanted XYZ base (sum of columns is white point)
  bxyz = bxyz.mult M.diag w.array
  @base = bxyz.array
  @baseInv = (lu bxyz).getInverse().array

  delete @XYZ
  delete @rgb
  return

rgbSpaceConstructor = (@red, @green, @blue, @white, gamma, gammaInv) ->
  if typeof gamma == "function"
    @gamma = gamma
    @gammaInv = gammaInv
  else
    @g = gamma
    @gInv = 1 / gamma
  # Lazy definition of following two methods.
  @rgb = ->
    lazyInitRgbBase.call @
    @rgb.apply @, arguments
  @XYZ = ->
    lazyInitRgbBase.call @
    @XYZ.apply @, arguments
  return



# RGB space prototype
# -------------------

rgbSpacePrototype =


  gamma: (x) ->
    pow(x, @g)

  gammaInv: (x) ->
    pow(x, @gInv)

  rgb: (XYZ, T = do require "../rgb") ->
    a = @baseInv
    T.r = @gammaInv a[0] * XYZ.X + a[1] * XYZ.Y + a[2] * XYZ.Z
    T.g = @gammaInv a[3] * XYZ.X + a[4] * XYZ.Y + a[5] * XYZ.Z
    T.b = @gammaInv a[6] * XYZ.X + a[7] * XYZ.Y + a[8] * XYZ.Z
    T

  XYZ: (Rgb, T = XYZM()) ->
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



createSpace = creator rgbSpacePrototype, rgbSpaceConstructor

createSpace["Adobe-98"] = createSpace (xyY 0.6400, 0.3300), (xyY 0.2100, 0.7100), (xyY 0.1500, 0.0600), white.D65, 2.2
createSpace["Adobe-RGB"] = createSpace (xyY 0.6250, 0.3400), (xyY 0.2800, 0.5950), (xyY 0.1550, 0.0700), white.D65, 1.8
createSpace["CIE-RGB"] =   createSpace (xyY 0.7350, 0.2650), (xyY 0.2740, 0.7170), (xyY 0.1670, 0.0090), white.E  , 1
createSpace["ColorMatch"] =   createSpace (xyY 0.6300, 0.3400), (xyY 0.2950, 0.6050), (xyY 0.1500, 0.0750), white.D50, 1.8
createSpace["EBU-Monitor"] =  createSpace (xyY 0.6314, 0.3391), (xyY 0.2809, 0.5971), (xyY 0.1487, 0.0645), white.D50, 1.9
createSpace["ECI-RGB"] =   createSpace (xyY 0.6700, 0.3300), (xyY 0.2100, 0.7100), (xyY 0.1400, 0.0800), white.D50, 1.8
createSpace["HDTV"] =      createSpace (xyY 0.6400, 0.3300), (xyY 0.2900, 0.6000), (xyY 0.1500, 0.0600), white.D65, 2.2
createSpace["Kodak-DC"] =  createSpace (xyY 0.6492, 0.3314), (xyY 0.3219, 0.5997), (xyY 0.1548, 0.0646), white.D50, 2.22
createSpace["NTSC-53"] =   createSpace (xyY 0.6700, 0.3300), (xyY 0.2100, 0.7100), (xyY 0.1400, 0.0800), white.C  , 2.2
createSpace["PAL-SECAM"] = createSpace (xyY 0.6400, 0.3300), (xyY 0.2900, 0.6000), (xyY 0.1500, 0.0600), white.D65, 2.2
createSpace["sRGB"] =      createSpace (xyY 0.6400, 0.3300), (xyY 0.3000, 0.6000), (xyY 0.1500, 0.0600), white.D65, gammaSRgb,  gammaSRgbInv
createSpace["WideGamut"] = createSpace (xyY 0.7347, 0.2653), (xyY 0.1152, 0.8264), (xyY 0.1566, 0.0177), white.D50, 2.2


module.exports = createSpace
