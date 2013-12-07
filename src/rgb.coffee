# Imports / Shortcuts
# -------------------


{creator} = require "ut1l/obj"

round = Math.round

# Helpers
# -------



cutByte = (b) ->
  if 0 <= b <= 255 then b else undefined

toByte = (d) ->
  cutByte round d * 255

validRgbEl = (x) ->
  (isFinite x) and 0 <= x <= 1

# RGB prototype
# -------------

rgbPrototype =

  RGB: (T = do require "./RGB") ->
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



# Public api
# ----------

module.exports =  creator rgbPrototype, ((@r, @g, @b) -> return),
  extendRgb: (f) -> f rgbPrototype