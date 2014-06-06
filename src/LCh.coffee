O = require "ut1l/create/object"

cos = Math.cos
sin = Math.sin

# LCh color prototype
# -------------------

lchPrototype =

  # Converts color from LCh to Lab color space.
  Lab: (T = do require "./Lab") ->
    T.L = @L
    T.a = @C * cos @h
    T.b = @C * sin @h
    T

  # Returns a human readable string serialization of the color.
  toString: ->
    "L=#{@L}, C=#{@C}, h=#{@h}"


# Public API
# ----------

module.exports = O ((@L, @C, @h) ->), lchPrototype