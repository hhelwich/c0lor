O = require "ut1l/create/object"

xyz = require "../XYZ"
Lab = require "../Lab"

pow = Math.pow

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

# Lab color space prototype
# -------------------------

labCsPrototype =

# Converts color `XYZ` from *XYZ* to this *Lab* color space.
  Lab: (XYZ, T = do Lab) ->
    l = f XYZ.Y / @white.Y
    T.L = 116 * l - 16
    T.a = 500 * ((f XYZ.X / @white.X) - l)
    T.b = 200 * (l - (f XYZ.Z / @white.Z))
    T

  XYZ: (Lab, T = do xyz) ->
    fy = (Lab.L + 16) / 116
    T.X = (fInv fy + Lab.a / 500) * @white.X
    T.Y = (fInv fy) * @white.Y
    T.Z = (fInv fy - Lab.b / 200) * @white.Z
    T

  LabderivL: (Y) ->
    116 * (fDeriv Y / @white.Y) / @white.Y



# Public API
# ----------

module.exports = O ((@white) ->), labCsPrototype