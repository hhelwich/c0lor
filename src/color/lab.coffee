# Imports / Shortcuts
# -------------------

xyz = require "./xyz"
createConstructor = (require "../util/obj").createConstructor

pow = Math.pow
sqrt = Math.sqrt
atan2 = Math.atan2
cos = Math.cos
sin = Math.sin

# Helpers
# -------

N = 4 / 29 # = 16 / 116
e3 = 216 / 24389 # = e^3
foo = 841 / 108  # = (1 / 116) * (24389 / 27) = 1/3 * (29/6)^2
e = 6 / 29 # = e3^(1/3)

f = (w) ->
  if w > e3
    pow w, 1/3
  else
    foo * w + N

fInv = (w) ->
  if w > e
    pow w, 3
  else
    (w - N) / foo

# Derivative of `f`.
fDeriv = (w) ->
  if w > e3
    1 / (3 * (pow w, 2/3))
  else
    foo

# Lab color prototype
# -------------------

labPrototype =

  # Converts color from Lab to LCh color space.
  LCh: (T = do createLch) ->
    T.L = @L # lightness
    T.C = sqrt @a * @a + @b * @b # chroma
    T.h = atan2 @b, @a # hue
    T

  # Returns a human readable string serialization of the color.
  toString: ->
    "L=#{@L}, a=#{@a}, b=#{@b}"


# LCh color prototype
# -------------------

lchPrototype =

  # Converts color from LCh to Lab color space.
  Lab: (T = do createLab) ->
    T.L = @L
    T.a = @C * cos @h
    T.b = @C * sin @h
    T

  # Returns a human readable string serialization of the color.
  toString: ->
    "L=#{@L}, C=#{@C}, h=#{@h}"


# Lab color space prototype
# -------------------------

labCsPrototype =

  # Converts color `XYZ` from *XYZ* to this *Lab* color space.
  fromXYZ: (XYZ, T = do createLab) ->
    l = f XYZ.Y / @white.Y
    T.L = 116 * l - 16
    T.a = 500 * ((f XYZ.X / @white.X) - l)
    T.b = 200 * (l - (f XYZ.Z / @white.Z))
    T

  toXYZ: (Lab, T = do xyz.XYZ) ->
    fy = (Lab.L + 16) / 116
    T.X = (fInv fy + Lab.a / 500) * @white.X
    T.Y = (fInv fy) * @white.Y
    T.Z = (fInv fy - Lab.b / 200) * @white.Z
    T

  fromXYZderivL: (Y) ->
    116 * (fDeriv Y / @white.Y) / @white.Y


# Public API
# ----------

module.exports = createConstructor labCsPrototype, ((@white) ->),
  Lab: createLab = createConstructor labPrototype, (@L, @a, @b) ->
  LCh: createLch = createConstructor lchPrototype, (@L, @C, @h) ->