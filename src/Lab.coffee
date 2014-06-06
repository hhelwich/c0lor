# Imports / Shortcuts
# -------------------

O = require "ut1l/create/object"

sqrt = Math.sqrt
atan2 = Math.atan2


# Lab color prototype
# -------------------

labPrototype =

  # Converts color from Lab to LCh color space.
  LCh: (T = do require "./LCh") ->
    T.L = @L # lightness
    T.C = sqrt @a * @a + @b * @b # chroma
    T.h = atan2 @b, @a # hue
    T

  # Returns a human readable string serialization of the color.
  toString: ->
    "L=#{@L}, a=#{@a}, b=#{@b}"



# Public API
# ----------

module.exports = O ((@L, @a, @b) ->), labPrototype